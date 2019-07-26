//
//  ConnectionsViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/20.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets.
    @IBOutlet weak var connectionsTableView: UITableView!
    
    // Properties.
    var centralManager: CBCentralManager!
    var peripheralDevices: [CBPeripheral] = []
    var connectedDevice: CBPeripheral?
    var connectionsTimer = Timer()
    let displayInterval = 2.0
    var refreshControl: UIRefreshControl!
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the central manager.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Set up the table view.
        connectionsTableView.delegate = self
        connectionsTableView.dataSource = self
        connectionsTableView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        // Set up the refresh control.
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadConnections), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading available devices.")
        connectionsTableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Reload table view.
        connectionsTableView.reloadData()
        // Restart timer.
        connectionsTimer.invalidate()
        connectionsTimer = Timer.scheduledTimer(timeInterval: displayInterval, target: self, selector: #selector(reloadTableView), userInfo: nil, repeats: true)
        RunLoop.current.add(connectionsTimer, forMode: .common)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop scanning.
        centralManager.stopScan()
        // Invalidate timer.
        connectionsTimer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OptionsViewController {
            let optionsViewController = segue.destination as! OptionsViewController
            optionsViewController.centralManager = centralManager
            optionsViewController.connectedDevice = connectedDevice
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = peripheralDevices[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        centralManager.connect(peripheralDevices[indexPath.row])
        connectedDevice = peripheralDevices[indexPath.row]
    }
    
    @objc func reloadConnections() {
        centralManager.stopScan()
        peripheralDevices.removeAll()
        connectionsTableView.reloadData()
        let deviceCBUUID = CBUUID(string: "0xFFE0")
        centralManager.scanForPeripherals(withServices: [deviceCBUUID])
        refreshControl.endRefreshing()
    }
    
    @objc func reloadTableView() {
        connectionsTableView.reloadData()
    }
}

extension ConnectionsViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Central is unknown.")
        case .resetting:
            print("Central is resetting.")
        case .unsupported:
            print("Central is unsupported.")
            // Alert and quit.
            let alert = UIAlertController(title: "Oops", message: "Bluetooth is not supported on your device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fine", style: .destructive, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        case .unauthorized:
            print("Central is unauthorized.")
        case .poweredOff:
            print("Central is powered off.")
            // Alert.
            let alert = UIAlertController(title: "Oops", message: "Bluetooth is turned off on your device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Fine", style: .default))
            present(alert, animated: true)
        case .poweredOn:
            print("Central is powered on.")
            // Scan for peripherals.
            let deviceCBUUID = CBUUID(string: "0xFFE0")
            centralManager.scanForPeripherals(withServices: [deviceCBUUID])
        @unknown default:
            print("Central is mysterious.")
        }
    }
    
    // Delegate method for confirmation of finding peripherals.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Append the discovered peripheral to the array.
        if !peripheralDevices.contains(peripheral) {
            peripheralDevices.append(peripheral)
        }
    }
    
    // Delegate method for confirmation of connection.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected.")
        performSegue(withIdentifier: "showOptions", sender: nil)
    }
}
