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
    var temperatureLabel: UILabel!
    var temperatureSwitch: UISwitch!
    var temperatureSliderLabel: UILabel!
    var temperatureSlider: UISlider!
    var humidityLabel: UILabel!
    var humiditySwitch: UISwitch!
    var humiditySliderLabel: UILabel!
    var humiditySlider: UISlider!
    var lightLabel: UILabel!
    var lightSwitch: UISwitch!
    var lightSliderLabel: UILabel!
    var lightSlider: UISlider!
    var soundLabel: UILabel!
    var soundSwitch: UISwitch!
    var soundSliderLabel: UILabel!
    var soundSlider: UISlider!
    var microphoneLabel: UILabel!
    var microphoneSwitch: UISwitch!
    var microphoneSliderLabel: UILabel!
    var microphoneSlider: UISlider!
    var timeLabel: UILabel!
    var timeSwitch: UISwitch!
    var timeSliderLabel: UILabel!
    var timeSlider: UISlider!
    
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
        temperatureLabel = UILabel()
        temperatureLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        temperatureLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 50)
        temperatureLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.textAlignment = .natural
        temperatureLabel.text = "Temperature sensor: ON"
        optionsScrollView.addSubview(temperatureLabel)
        temperatureSwitch = UISwitch()
        temperatureSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        temperatureSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 50)
        temperatureSwitch.isOn = true
        temperatureSwitch.addTarget(self, action: #selector(toggleTemperature), for: .valueChanged)
        optionsScrollView.addSubview(temperatureSwitch)
        temperatureSliderLabel = UILabel()
        temperatureSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        temperatureSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 90)
        temperatureSliderLabel.adjustsFontSizeToFitWidth = true
        temperatureSliderLabel.textColor = .darkGray
        temperatureSliderLabel.textAlignment = .natural
        temperatureSliderLabel.text = "Sample rate: 1/1."
        optionsScrollView.addSubview(temperatureSliderLabel)
        temperatureSlider = UISlider()
        temperatureSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        temperatureSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 120)
        temperatureSlider.minimumValue = 1
        temperatureSlider.maximumValue = 60
        temperatureSlider.setValue(60, animated: false)
        temperatureSlider.addTarget(self, action: #selector(setTemperatureSampleRate), for: .valueChanged)
        optionsScrollView.addSubview(temperatureSlider)
        // Humidity.
        humidityLabel = UILabel()
        humidityLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        humidityLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 180)
        humidityLabel.adjustsFontSizeToFitWidth = true
        humidityLabel.textAlignment = .natural
        humidityLabel.text = "Humidity sensor: ON"
        optionsScrollView.addSubview(humidityLabel)
        humiditySwitch = UISwitch()
        humiditySwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        humiditySwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 180)
        humiditySwitch.isOn = true
        humiditySwitch.addTarget(self, action: #selector(toggleHumidity), for: .valueChanged)
        optionsScrollView.addSubview(humiditySwitch)
        humiditySliderLabel = UILabel()
        humiditySliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        humiditySliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 220)
        humiditySliderLabel.adjustsFontSizeToFitWidth = true
        humiditySliderLabel.textColor = .darkGray
        humiditySliderLabel.textAlignment = .natural
        humiditySliderLabel.text = "Sample rate: 1/1."
        optionsScrollView.addSubview(humiditySliderLabel)
        humiditySlider = UISlider()
        humiditySlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        humiditySlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 250)
        humiditySlider.minimumValue = 1
        humiditySlider.maximumValue = 60
        humiditySlider.setValue(60, animated: false)
        humiditySlider.addTarget(self, action: #selector(setHumiditySampleRate), for: .valueChanged)
        optionsScrollView.addSubview(humiditySlider)
        // Light.
        lightLabel = UILabel()
        lightLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        lightLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 310)
        lightLabel.adjustsFontSizeToFitWidth = true
        lightLabel.textAlignment = .natural
        lightLabel.text = "Light sensor: ON"
        optionsScrollView.addSubview(lightLabel)
        lightSwitch = UISwitch()
        lightSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        lightSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 310)
        lightSwitch.isOn = true
        lightSwitch.addTarget(self, action: #selector(toggleLight), for: .valueChanged)
        optionsScrollView.addSubview(lightSwitch)
        lightSliderLabel = UILabel()
        lightSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        lightSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 350)
        lightSliderLabel.adjustsFontSizeToFitWidth = true
        lightSliderLabel.textColor = .darkGray
        lightSliderLabel.textAlignment = .natural
        lightSliderLabel.text = "Sample rate: 20."
        optionsScrollView.addSubview(lightSliderLabel)
        lightSlider = UISlider()
        lightSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        lightSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 380)
        lightSlider.minimumValue = 1
        lightSlider.maximumValue = 100
        lightSlider.setValue(20, animated: false)
        lightSlider.addTarget(self, action: #selector(setLightSampleRate), for: .valueChanged)
        optionsScrollView.addSubview(lightSlider)
        // Sound.
        soundLabel = UILabel()
        soundLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        soundLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 440)
        soundLabel.adjustsFontSizeToFitWidth = true
        soundLabel.textAlignment = .natural
        soundLabel.text = "Sound sensor: ON"
        optionsScrollView.addSubview(soundLabel)
        soundSwitch = UISwitch()
        soundSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        soundSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 440)
        soundSwitch.isOn = true
        soundSwitch.addTarget(self, action: #selector(toggleSound), for: .valueChanged)
        optionsScrollView.addSubview(soundSwitch)
        soundSliderLabel = UILabel()
        soundSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        soundSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 480)
        soundSliderLabel.adjustsFontSizeToFitWidth = true
        soundSliderLabel.textColor = .darkGray
        soundSliderLabel.textAlignment = .natural
        soundSliderLabel.text = "Sample rate: 20."
        optionsScrollView.addSubview(soundSliderLabel)
        soundSlider = UISlider()
        soundSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        soundSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 510)
        soundSlider.minimumValue = 1
        soundSlider.maximumValue = 100
        soundSlider.setValue(20, animated: false)
        soundSlider.addTarget(self, action: #selector(setSoundSampleRate), for: .valueChanged)
        optionsScrollView.addSubview(soundSlider)
        // Microphone.
        microphoneLabel = UILabel()
        microphoneLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        microphoneLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 570)
        microphoneLabel.adjustsFontSizeToFitWidth = true
        microphoneLabel.textAlignment = .natural
        microphoneLabel.text = "Microphone: ON"
        optionsScrollView.addSubview(microphoneLabel)
        microphoneSwitch = UISwitch()
        microphoneSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        microphoneSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 570)
        microphoneSwitch.isOn = true
        microphoneSwitch.addTarget(self, action: #selector(toggleMicrophone), for: .valueChanged)
        optionsScrollView.addSubview(microphoneSwitch)
        microphoneSliderLabel = UILabel()
        microphoneSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        microphoneSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 610)
        microphoneSliderLabel.adjustsFontSizeToFitWidth = true
        microphoneSliderLabel.textColor = .darkGray
        microphoneSliderLabel.textAlignment = .natural
        microphoneSliderLabel.text = "Sample rate: 20."
        optionsScrollView.addSubview(microphoneSliderLabel)
        microphoneSlider = UISlider()
        microphoneSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        microphoneSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 640)
        microphoneSlider.minimumValue = 1
        microphoneSlider.maximumValue = 100
        microphoneSlider.setValue(20, animated: false)
        microphoneSlider.addTarget(self, action: #selector(setMicrophoneSampleRate), for: .valueChanged)
        optionsScrollView.addSubview(microphoneSlider)
        // Option of setting a fixed recording time.
        timeLabel = UILabel()
        timeLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        timeLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 700)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textAlignment = .natural
        timeLabel.text = "Record for a fixed time: OFF"
        optionsScrollView.addSubview(timeLabel)
        timeSwitch = UISwitch()
        timeSwitch.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.2, height: 80)
        timeSwitch.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.85, y: 700)
        timeSwitch.isOn = false
        timeSwitch.addTarget(self, action: #selector(toggleTime), for: .valueChanged)
        optionsScrollView.addSubview(timeSwitch)
        timeSliderLabel = UILabel()
        timeSliderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 80)
        timeSliderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.4, y: 740)
        timeSliderLabel.adjustsFontSizeToFitWidth = true
        timeSliderLabel.textColor = .lightGray
        timeSliderLabel.textAlignment = .natural
        timeSliderLabel.text = "Record for 5 minutes."
        optionsScrollView.addSubview(timeSliderLabel)
        timeSlider = UISlider()
        timeSlider.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.7, height: 60)
        timeSlider.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 770)
        timeSlider.minimumValue = 1
        timeSlider.maximumValue = 24
        timeSlider.setValue(1, animated: false)
        timeSlider.isEnabled = false
        timeSlider.addTarget(self, action: #selector(setTimePeriod), for: .valueChanged)
        optionsScrollView.addSubview(timeSlider)
        // Set content size of scroll view.
        optionsScrollView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: timeSlider.frame.maxY)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Cancel conntection.
        if isMovingFromParent {
            centralManager.cancelPeripheralConnection(connectedDevice)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GeneralViewController {
            let generalViewController = segue.destination as! GeneralViewController
            generalViewController.temperatureIsOn = temperatureSwitch.isOn
            generalViewController.temperatureSampleInterval = (61 - Int(temperatureSlider.value)) * 100
            generalViewController.humidityIsOn = humiditySwitch.isOn
            generalViewController.humiditySampleInterval = (61 - Int(humiditySlider.value)) * 100
            generalViewController.lightIsOn = lightSwitch.isOn
            generalViewController.lightSampleInterval = 100 / Int(lightSlider.value)
            generalViewController.soundIsOn = soundSwitch.isOn
            generalViewController.soundSampleInterval = 100 / Int(soundSlider.value)
            generalViewController.microphoneIsOn = microphoneSwitch.isOn
            generalViewController.microphoneSampleInterval = 100 / Int(microphoneSlider.value)
            generalViewController.timeisFixed = timeSwitch.isOn
            generalViewController.timePeriod = Int(timeSlider.value) * 30000
        }
    }
    
    @objc func toggleTemperature() {
        if temperatureSwitch.isOn {
            temperatureLabel.text = "Temperature sensor: ON"
            temperatureSliderLabel.textColor = .darkGray
            temperatureSlider.isEnabled = true
        } else {
            temperatureLabel.text = "Temperature sensor: OFF"
            temperatureSliderLabel.textColor = .lightGray
            temperatureSlider.isEnabled = false
        }
        if !temperatureSwitch.isOn && !humiditySwitch.isOn && !lightSwitch.isOn && !soundSwitch.isOn && !microphoneSwitch.isOn {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func setTemperatureSampleRate() {
        temperatureSliderLabel.text = "Sample rate: 1/" + String(61 - Int(temperatureSlider.value)) + "."
    }
    
    @objc func toggleHumidity() {
        if humiditySwitch.isOn {
            humidityLabel.text = "Humidity sensor: ON"
            humiditySliderLabel.textColor = .darkGray
            humiditySlider.isEnabled = true
        } else {
            humidityLabel.text = "Humidity sensor: OFF"
            humiditySliderLabel.textColor = .lightGray
            humiditySlider.isEnabled = false
        }
        if !temperatureSwitch.isOn && !humiditySwitch.isOn && !lightSwitch.isOn && !soundSwitch.isOn && !microphoneSwitch.isOn {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func setHumiditySampleRate() {
        humiditySliderLabel.text = "Sample rate: 1/" + String(61 - Int(humiditySlider.value)) + "."
    }
    
    @objc func toggleLight() {
        if lightSwitch.isOn {
            lightLabel.text = "Light sensor: ON"
            lightSliderLabel.textColor = .darkGray
            lightSlider.isEnabled = true
        } else {
            lightLabel.text = "Light sensor: OFF"
            lightSliderLabel.textColor = .lightGray
            lightSlider.isEnabled = false
        }
        if !temperatureSwitch.isOn && !humiditySwitch.isOn && !lightSwitch.isOn && !soundSwitch.isOn && !microphoneSwitch.isOn {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func setLightSampleRate() {
        lightSliderLabel.text = "Sample rate: " + String(Int(lightSlider.value)) + "."
    }
    
    @objc func toggleSound() {
        if soundSwitch.isOn {
            soundLabel.text = "Sound sensor: ON"
            soundSliderLabel.textColor = .darkGray
            soundSlider.isEnabled = true
        } else {
            soundLabel.text = "Sound sensor: OFF"
            soundSliderLabel.textColor = .lightGray
            soundSlider.isEnabled = false
        }
        if !temperatureSwitch.isOn && !humiditySwitch.isOn && !lightSwitch.isOn && !soundSwitch.isOn && !microphoneSwitch.isOn {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func setSoundSampleRate() {
        soundSliderLabel.text = "Sample rate: " + String(Int(soundSlider.value)) + "."
    }
    
    @objc func toggleMicrophone() {
        if microphoneSwitch.isOn {
            microphoneLabel.text = "Microphone: ON"
            microphoneSliderLabel.textColor = .darkGray
            microphoneSlider.isEnabled = true
        } else {
            microphoneLabel.text = "Microphone: OFF"
            microphoneSliderLabel.textColor = .lightGray
            microphoneSlider.isEnabled = false
        }
        if !temperatureSwitch.isOn && !humiditySwitch.isOn && !lightSwitch.isOn && !soundSwitch.isOn && !microphoneSwitch.isOn {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func setMicrophoneSampleRate() {
        microphoneSliderLabel.text = "Sample rate: " + String(Int(microphoneSlider.value)) + "."
    }
    
    @objc func toggleTime() {
        if timeSwitch.isOn {
            timeLabel.text = "Record for a fixed time: ON"
            timeSliderLabel.textColor = .darkGray
            timeSlider.isEnabled = true
        } else {
            timeLabel.text = "Record for a fixed time: OFF"
            timeSliderLabel.textColor = .lightGray
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
        if String(data: characteristic.value!, encoding: .utf8)!.count == 16 {
            AppData.dataString = String(data: characteristic.value!, encoding: .utf8)!
            let splitIndex1 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 4)
            let splitIndex2 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 8)
            let splitIndex3 = AppData.dataString.index(AppData.dataString.startIndex, offsetBy: 12)
            AppData.temperature = Int(AppData.dataString[..<splitIndex1], radix: 16)!
            AppData.humidity = Int(AppData.dataString[splitIndex1..<splitIndex2], radix: 16)!
            AppData.light = Int(AppData.dataString[splitIndex2..<splitIndex3], radix: 16)!
            AppData.sound = Int(AppData.dataString[splitIndex3...], radix: 16)!
        }
    }
}
