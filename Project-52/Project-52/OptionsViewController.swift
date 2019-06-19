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
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Discover services on the connected device.
        connectedDevice.delegate = self
        let deviceCBUUID = CBUUID(string: "0xFFE0")
        connectedDevice.discoverServices([deviceCBUUID])
    }
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
        AppData.dataString = String(data: characteristic.value!, encoding: String.Encoding.utf8) ?? "Data string not present."
        let splitIndex1 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 4)
        let splitIndex2 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 8)
        let splitIndex3 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 12)
        AppData.temperature = Int(AppData.dataString[..<splitIndex1], radix: 16)!
        AppData.humidity = Int(AppData.dataString[splitIndex1..<splitIndex2], radix: 16)!
        AppData.light = Int(AppData.dataString[splitIndex2..<splitIndex3], radix: 16)!
        AppData.sound = Int(AppData.dataString[splitIndex3...], radix: 16)!
    }
}
