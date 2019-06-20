//
//  GeneralViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/19.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {
    // Properties.
    var timer = Timer()
    let displayInterval = 0.5
    var temperatureIsOn = Bool()
    var temperatureSampleInterval = Int()
    var humidityIsOn = Bool()
    var humiditySampleInterval = Int()
    var lightIsOn = Bool()
    var lightSampleRate = Int()
    var soundIsOn = Bool()
    var soundSampleRate = Int()
    var timeisFixed = Bool()
    var timePeriod = Int()
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the timer.
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: displayInterval, target: self, selector: #selector(displayData), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func displayData() {
        print("Temperature: " + String(AppData.temperature))
        print("Humidity: " + String(AppData.humidity))
        print("Light: " + String(AppData.light))
        print("Sound: " + String(AppData.sound))
    }
}
