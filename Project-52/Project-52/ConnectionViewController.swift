//
//  ConnectionViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/17.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit
import CoreBluetooth

class ConnectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets.
    @IBOutlet weak var connectionTableView: UITableView!
    
    // Properties.
    var centralManager: CBCentralManager!
    var peripheralDevices = [CBPeripheral]()
    var connectedDevice: CBPeripheral?
    var timer = Timer()
    var displayInterval = 2.0
    var refreshControl = UIRefreshControl()
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the central manager.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Set up the table view.
        connectionTableView.delegate = self
        connectionTableView.dataSource = self
        // Set up refresh control.
        refreshControl.addTarget(self, action: #selector(reloadConnections), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading available devices.")
        connectionTableView.addSubview(refreshControl)
        // Set up the timer.
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: displayInterval, target: self, selector: #selector(reloadTableView), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
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
        connectionTableView.reloadData()
        let deviceCBUUID = CBUUID(string: "0xFFE0")
        centralManager.scanForPeripherals(withServices: [deviceCBUUID])
        refreshControl.endRefreshing()
    }
    
    @objc func reloadTableView() {
        connectionTableView.reloadData()
    }
}

extension ConnectionViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Central is unknown.")
        case .resetting:
            print("Central is resetting.")
        case .unsupported:
            print("Central is unsupported.")
            // Alert and quit.
            let alert = UIAlertController(title: "Oh shit!", message: "Bluetooth is not supported on your device!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Fine", style: UIAlertAction.Style.destructive, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true)
        case .unauthorized:
            print("Central is unauthorized.")
        case .poweredOff:
            print("Central is powered off.")
            // Alert.
            let alert = UIAlertController(title: "Oh shit!", message: "Bluetooth is turned off on your device!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Fine", style: UIAlertAction.Style.default))
            self.present(alert, animated: true)
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
