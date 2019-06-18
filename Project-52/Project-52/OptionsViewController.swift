//
//  OptionsViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/14.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit
import CoreBluetooth

class OptionsViewController: UIViewController {
    // Properties.
    var connectedDevice: CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Discover services on the connected device.
        connectedDevice.delegate = self
        let deviceCBUUID = CBUUID(string: "0xFFE0")
        connectedDevice.discoverServices([deviceCBUUID])
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension OptionsViewController: CBPeripheralDelegate {
    // Delegate method for confirmation of services discovery.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let services = peripheral.services!
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    // Delegate method for confirmation of characteristics discovery.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let characteristics = service.characteristics!
        for characteristic in characteristics {
            print(characteristic)
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    // Delegate method for confirmation of value update in characteristics.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let dataString = String(data: characteristic.value!, encoding: String.Encoding.utf8)
        print(dataString ?? "Data does not exist.")
    }
}
