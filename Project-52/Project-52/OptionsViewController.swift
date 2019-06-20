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
    // Outlets.
    @IBOutlet weak var optionsScrollView: UIScrollView!
    
    // Properties.
    var centralManager: CBCentralManager!
    var connectedDevice: CBPeripheral!
    let temperatureLabel = UILabel()
    let temperatureSwitch = UISwitch()
    let temperatureSliderLabel = UILabel()
    let temperatureSlider = UISlider()
    let humidityLabel = UILabel()
    let humiditySwitch = UISwitch()
    let humiditySliderLabel = UILabel()
    let humiditySlider = UISlider()
    let lightLabel = UILabel()
    let lightSwitch = UISwitch()
    let lightSliderLabel = UILabel()
    let lightSlider = UISlider()
    let soundLabel = UILabel()
    let soundSwitch = UISwitch()
    let soundSliderLabel = UILabel()
    let soundSlider = UISlider()
    let timeLabel = UILabel()
    let timeSwitch = UISwitch()
    let timeSliderLabel = UILabel()
    let timeSlider = UISlider()
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Discover services on the connected device.
        connectedDevice.delegate = self
        let deviceCBUUID = CBUUID(string: "0xFFE0")
        connectedDevice.discoverServices([deviceCBUUID])
        // Adjust layout.
        optionsScrollView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        // Load labels and switches for available sensors.
        // Temperature.
        temperatureLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        temperatureLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 50)
        temperatureLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.textAlignment = .natural
        temperatureLabel.text = "Temperature sensor: ON"
        optionsScrollView.addSubview(temperatureLabel)
        temperatureSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        temperatureSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 50)
        temperatureSwitch.isOn = true
        temperatureSwitch.addTarget(self, action: #selector(toggleTemperature), for: .valueChanged)
        optionsScrollView.addSubview(temperatureSwitch)
        temperatureSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        temperatureSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 90)
        temperatureSliderLabel.adjustsFontSizeToFitWidth = true
        temperatureSliderLabel.textColor = UIColor.darkGray
        temperatureSliderLabel.textAlignment = .natural
        temperatureSliderLabel.text = "Sample interval: 1 s."
        optionsScrollView.addSubview(temperatureSliderLabel)
        temperatureSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        temperatureSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 120)
        temperatureSlider.minimumValue = 1
        temperatureSlider.maximumValue = 60
        temperatureSlider.setValue(1, animated: false)
        temperatureSlider.addTarget(self, action: #selector(setTemperatureSampleInterval), for: .valueChanged)
        optionsScrollView.addSubview(temperatureSlider)
        // Humidity.
        humidityLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        humidityLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 180)
        humidityLabel.adjustsFontSizeToFitWidth = true
        humidityLabel.textAlignment = .natural
        humidityLabel.text = "Humidity sensor: ON"
        optionsScrollView.addSubview(humidityLabel)
        humiditySwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        humiditySwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 180)
        humiditySwitch.isOn = true
        humiditySwitch.addTarget(self, action: #selector(toggleHumidity), for: .valueChanged)
        optionsScrollView.addSubview(humiditySwitch)
        humiditySliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        humiditySliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 220)
        humiditySliderLabel.adjustsFontSizeToFitWidth = true
        humiditySliderLabel.textColor = UIColor.darkGray
        humiditySliderLabel.textAlignment = .natural
        humiditySliderLabel.text = "Sample interval: 1 s."
        optionsScrollView.addSubview(humiditySliderLabel)
        humiditySlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        humiditySlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 250)
        humiditySlider.minimumValue = 1
        humiditySlider.maximumValue = 60
        humiditySlider.setValue(1, animated: false)
        humiditySlider.addTarget(self, action: #selector(setHumiditySampleInterval), for: .valueChanged)
        optionsScrollView.addSubview(humiditySlider)
        // Light.
        lightLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        lightLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 310)
        lightLabel.adjustsFontSizeToFitWidth = true
        lightLabel.textAlignment = .natural
        lightLabel.text = "Light sensor: ON"
        optionsScrollView.addSubview(lightLabel)
        lightSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        lightSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 310)
        lightSwitch.isOn = true
        lightSwitch.addTarget(self, action: #selector(toggleLight), for: .valueChanged)
        optionsScrollView.addSubview(lightSwitch)
        lightSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        lightSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 350)
        lightSliderLabel.adjustsFontSizeToFitWidth = true
        lightSliderLabel.textColor = UIColor.darkGray
        lightSliderLabel.textAlignment = .natural
        lightSliderLabel.text = "Sample rate: 1."
        optionsScrollView.addSubview(lightSliderLabel)
        lightSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        lightSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 380)
        lightSlider.minimumValue = 1
        lightSlider.maximumValue = 100
        lightSlider.setValue(1, animated: false)
        lightSlider.addTarget(self, action: #selector(setLightSampleRate), for: .valueChanged)
        optionsScrollView.addSubview(lightSlider)
        // Sound.
        soundLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        soundLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 440)
        soundLabel.adjustsFontSizeToFitWidth = true
        soundLabel.textAlignment = .natural
        soundLabel.text = "Sound sensor: ON"
        optionsScrollView.addSubview(soundLabel)
        soundSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        soundSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 440)
        soundSwitch.isOn = true
        soundSwitch.addTarget(self, action: #selector(toggleSound), for: .valueChanged)
        optionsScrollView.addSubview(soundSwitch)
        soundSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        soundSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 480)
        soundSliderLabel.adjustsFontSizeToFitWidth = true
        soundSliderLabel.textColor = UIColor.darkGray
        soundSliderLabel.textAlignment = .natural
        soundSliderLabel.text = "Sample rate: 1."
        optionsScrollView.addSubview(soundSliderLabel)
        soundSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        soundSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 510)
        soundSlider.minimumValue = 1
        soundSlider.maximumValue = 100
        soundSlider.setValue(1, animated: false)
        soundSlider.addTarget(self, action: #selector(setSoundSampleRate), for: .valueChanged)
        optionsScrollView.addSubview(soundSlider)
        // Option of setting a fixed recording time.
        timeLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        timeLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 570)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textAlignment = .natural
        timeLabel.text = "Record for a fixed time: OFF"
        optionsScrollView.addSubview(timeLabel)
        timeSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        timeSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 570)
        timeSwitch.isOn = false
        timeSwitch.addTarget(self, action: #selector(toggleTime), for: .valueChanged)
        optionsScrollView.addSubview(timeSwitch)
        timeSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        timeSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 610)
        timeSliderLabel.adjustsFontSizeToFitWidth = true
        timeSliderLabel.textColor = UIColor.lightGray
        timeSliderLabel.textAlignment = .natural
        timeSliderLabel.text = "Record for 5 minutes."
        optionsScrollView.addSubview(timeSliderLabel)
        timeSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        timeSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 640)
        timeSlider.minimumValue = 1
        timeSlider.maximumValue = 24
        timeSlider.setValue(1, animated: false)
        timeSlider.isEnabled = false
        timeSlider.addTarget(self, action: #selector(setTimePeriod), for: .valueChanged)
        optionsScrollView.addSubview(timeSlider)
        // Set content size of scroll view.
        if view.safeAreaLayoutGuide.layoutFrame.height > timeSlider.frame.maxY {
            optionsScrollView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height - 50)
        } else {
            optionsScrollView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: timeSlider.frame.maxY + 30)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GeneralViewController {
            let generalViewController = segue.destination as! GeneralViewController
            generalViewController.temperatureIsOn = temperatureSwitch.isOn
            generalViewController.temperatureSampleInterval = Int(temperatureSlider.value)
            generalViewController.humidityIsOn = humiditySwitch.isOn
            generalViewController.humiditySampleInterval = Int(humiditySlider.value)
            generalViewController.lightIsOn = lightSwitch.isOn
            generalViewController.lightSampleRate = Int(lightSlider.value)
            generalViewController.soundIsOn = soundSwitch.isOn
            generalViewController.soundSampleRate = Int(soundSlider.value)
            generalViewController.timeisFixed = timeSwitch.isOn
            generalViewController.timePeriod = Int(timeSlider.value) * 5
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isMovingFromParent {
            centralManager.cancelPeripheralConnection(connectedDevice)
        }
    }
    
    @objc func toggleTemperature() {
        if temperatureSwitch.isOn {
            temperatureLabel.text = "Temperature sensor: ON"
            temperatureSliderLabel.textColor = UIColor.darkGray
            temperatureSlider.isEnabled = true
        } else {
            temperatureLabel.text = "Temperature sensor: OFF"
            temperatureSliderLabel.textColor = UIColor.lightGray
            temperatureSlider.isEnabled = false
        }
    }
    
    @objc func setTemperatureSampleInterval() {
        temperatureSliderLabel.text = "Sample interval: " + String(Int(temperatureSlider.value)) + " s."
    }
    
    @objc func toggleHumidity() {
        if humiditySwitch.isOn {
            humidityLabel.text = "Humidity sensor: ON"
            humiditySliderLabel.textColor = UIColor.darkGray
            humiditySlider.isEnabled = true
        } else {
            humidityLabel.text = "Humidity sensor: OFF"
            humiditySliderLabel.textColor = UIColor.lightGray
            humiditySlider.isEnabled = false
        }
    }
    
    @objc func setHumiditySampleInterval() {
        humiditySliderLabel.text = "Sample interval: " + String(Int(humiditySlider.value)) + " s."
    }
    
    @objc func toggleLight() {
        if lightSwitch.isOn {
            lightLabel.text = "Light sensor: ON"
            lightSliderLabel.textColor = UIColor.darkGray
            lightSlider.isEnabled = true
        } else {
            lightLabel.text = "Light sensor: OFF"
            lightSliderLabel.textColor = UIColor.lightGray
            lightSlider.isEnabled = false
        }
    }
    
    @objc func setLightSampleRate() {
        lightSliderLabel.text = "Sample rate: " + String(Int(lightSlider.value)) + "."
    }
    
    @objc func toggleSound() {
        if soundSwitch.isOn {
            soundLabel.text = "Sound sensor: ON"
            soundSliderLabel.textColor = UIColor.darkGray
            soundSlider.isEnabled = true
        } else {
            soundLabel.text = "Sound sensor: OFF"
            soundSliderLabel.textColor = UIColor.lightGray
            soundSlider.isEnabled = false
        }
    }
    
    @objc func setSoundSampleRate() {
        soundSliderLabel.text = "Sample rate: " + String(Int(soundSlider.value)) + "."
    }
    
    @objc func toggleTime() {
        if timeSwitch.isOn {
            timeLabel.text = "Record for a fixed time: ON"
            timeSliderLabel.textColor = UIColor.darkGray
            timeSlider.isEnabled = true
        } else {
            timeLabel.text = "Record for a fixed time: OFF"
            timeSliderLabel.textColor = UIColor.lightGray
            timeSlider.isEnabled = false
        }
    }
    
    @objc func setTimePeriod() {
        timeSliderLabel.text = "Record for " + String(Int(timeSlider.value) * 5) + " minutes."
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
        AppData.dataString = String(data: characteristic.value!, encoding: String.Encoding.utf8) ?? "0000000000000000"
        let splitIndex1 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 4)
        let splitIndex2 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 8)
        let splitIndex3 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 12)
        AppData.temperature = Int(AppData.dataString[..<splitIndex1], radix: 16)!
        AppData.humidity = Int(AppData.dataString[splitIndex1..<splitIndex2], radix: 16)!
        AppData.light = Int(AppData.dataString[splitIndex2..<splitIndex3], radix: 16)!
        AppData.sound = Int(AppData.dataString[splitIndex3...], radix: 16)!
    }
}
