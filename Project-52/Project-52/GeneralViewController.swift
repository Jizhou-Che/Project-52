//
//  GeneralViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/19.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {
    // Outlets.
    @IBOutlet weak var generalScrollView: UIScrollView!
    @IBOutlet weak var generalInformationView: UIView!
    @IBOutlet weak var generalToolBar: UIToolbar!
    
    // Properties.
    var temperatureIsOn = Bool()
    var temperatureSampleInterval = Int()
    var humidityIsOn = Bool()
    var humiditySampleInterval = Int()
    var lightIsOn = Bool()
    var lightSampleInterval = Int()
    var soundIsOn = Bool()
    var soundSampleInterval = Int()
    var microphoneIsOn = Bool()
    var microphoneSampleInterval = Int()
    var timeisFixed = Bool()
    var timePeriod = Int()
    var lastElementY = CGFloat(0)
    var temperatureGraph = UIView()
    var temperaturePointSpacingRatio = 5
    var temperatureDivideRatio = 70
    var temperatureCurrentRatio = 0
    var temperatureIsFirstPoint = true
    var temperatureShiftGraph = false
    var temperatureLastPointX: Double?
    var temperatureLastPointY: Double?
    var temperatureLabel = UILabel()
    var humidityGraph = UIView()
    var humidityPointSpacingRatio = 5
    var humidityDivideRatio = 70
    var humidityCurrentRatio = 0
    var humidityIsFirstPoint = true
    var humidityShiftGraph = false
    var humidityLastPointX: Double?
    var humidityLastPointY: Double?
    var humidityLabel = UILabel()
    var lightGraph = UIView()
    var lightPointSpacingRatio = 5
    var lightDivideRatio = 70
    var lightCurrentRatio = 0
    var lightIsFirstPoint = true
    var lightShiftGraph = false
    var lightLastPointX: Double?
    var lightLastPointY: Double?
    var lightLabel = UILabel()
    var soundGraph = UIView()
    var soundPointSpacingRatio = 5
    var soundDivideRatio = 70
    var soundCurrentRatio = 0
    var soundIsFirstPoint = true
    var soundShiftGraph = false
    var soundLastPointX: Double?
    var soundLastPointY: Double?
    var soundLabel = UILabel()
    var generalTimer = Timer()
    var generalTimeLabel = UILabel()
    var generalTime = Int(0)
    var generalTimeString = String("00:00:00.00")
    var startButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startRecording))
    var stopButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(stopRecording))
    var discardButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(discardRecording))
    var saveButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(saveRecording))
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adjust layout.
        generalScrollView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height * 0.85)
        generalScrollView.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: view.safeAreaLayoutGuide.layoutFrame.height * 0.425)
        generalInformationView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height * 0.05)
        generalInformationView.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: view.safeAreaLayoutGuide.layoutFrame.height * 0.875)
        generalTimeLabel.frame = CGRect(x: 0, y: 0, width: generalInformationView.frame.width * 0.6, height: generalInformationView.frame.height * 0.8)
        generalTimeLabel.center = CGPoint(x: generalInformationView.center.x, y: generalInformationView.center.y)
        generalTimeLabel.adjustsFontSizeToFitWidth = true
        generalTimeLabel.textAlignment = .center
        generalTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: generalInformationView.frame.height * 0.6, weight: .regular)
        generalTimeLabel.text = generalTimeString
        view.addSubview(generalTimeLabel)
        generalToolBar.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height * 0.1)
        generalToolBar.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: view.safeAreaLayoutGuide.layoutFrame.height * 0.95)
        // Load items in tool bar.
        generalToolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), startButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)], animated: true)
        // Load graphs for available sensors.
        if temperatureIsOn {
            // Load graph.
            temperatureGraph.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.9, height: view.safeAreaLayoutGuide.layoutFrame.width * 0.675)
            temperatureGraph.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: lastElementY + temperatureGraph.frame.height * 0.5 + 10)
            temperatureGraph.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            temperatureGraph.clipsToBounds = true
            generalScrollView.addSubview(temperatureGraph)
            // Update position of last element.
            lastElementY = temperatureGraph.frame.maxY
            // Load label.
            temperatureLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.8, height: 50)
            temperatureLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: lastElementY + temperatureLabel.frame.height * 0.5)
            temperatureLabel.adjustsFontSizeToFitWidth = true
            temperatureLabel.textAlignment = .center
            temperatureLabel.text = "Temperature: --."
            generalScrollView.addSubview(temperatureLabel)
            // Update position of last element.
            lastElementY = temperatureLabel.frame.maxY
        }
        if humidityIsOn {
            // Load graph.
            humidityGraph.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.9, height: view.safeAreaLayoutGuide.layoutFrame.width * 0.675)
            humidityGraph.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: lastElementY + humidityGraph.frame.height * 0.5 + 10)
            humidityGraph.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            humidityGraph.clipsToBounds = true
            generalScrollView.addSubview(humidityGraph)
            // Update position of last element.
            lastElementY = humidityGraph.frame.maxY
            // Load label.
            humidityLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.8, height: 50)
            humidityLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: lastElementY + humidityLabel.frame.height * 0.5)
            humidityLabel.adjustsFontSizeToFitWidth = true
            humidityLabel.textAlignment = .center
            humidityLabel.text = "Humidity: --."
            generalScrollView.addSubview(humidityLabel)
            // Update position of last element.
            lastElementY = humidityLabel.frame.maxY
        }
        if lightIsOn {
            // Load graph.
            lightGraph.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.9, height: view.safeAreaLayoutGuide.layoutFrame.width * 0.675)
            lightGraph.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: lastElementY + lightGraph.frame.height * 0.5 + 10)
            lightGraph.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            lightGraph.clipsToBounds = true
            generalScrollView.addSubview(lightGraph)
            // Update position of last element.
            lastElementY = lightGraph.frame.maxY
            // Load label.
            lightLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.8, height: 50)
            lightLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: lastElementY + lightLabel.frame.height * 0.5)
            lightLabel.adjustsFontSizeToFitWidth = true
            lightLabel.textAlignment = .center
            lightLabel.text = "Light: --."
            generalScrollView.addSubview(lightLabel)
            // Update position of last element.
            lastElementY = lightLabel.frame.maxY
        }
        if soundIsOn {
            // Load graph.
            soundGraph.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.9, height: view.safeAreaLayoutGuide.layoutFrame.width * 0.675)
            soundGraph.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: lastElementY + soundGraph.frame.height * 0.5 + 10)
            soundGraph.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            soundGraph.clipsToBounds = true
            generalScrollView.addSubview(soundGraph)
            // Update position of last element.
            lastElementY = soundGraph.frame.maxY
            // Load label.
            soundLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.8, height: 50)
            soundLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: lastElementY + soundLabel.frame.height * 0.5)
            soundLabel.adjustsFontSizeToFitWidth = true
            soundLabel.textAlignment = .center
            soundLabel.text = "Sound: --."
            generalScrollView.addSubview(soundLabel)
            // Update position of last element.
            lastElementY = soundLabel.frame.maxY
        }
        if microphoneIsOn {
            //
        }
        // Set content size of scroll view.
        generalScrollView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: lastElementY)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent {
            // Invalidate timer.
            generalTimer.invalidate()
        }
    }
    
    @objc func startRecording() {
        generalTimer.invalidate()
        generalTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(setGeneralTime), userInfo: nil, repeats: true)
        RunLoop.current.add(generalTimer, forMode: .common)
        generalToolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), stopButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)], animated: true)
    }
    
    @objc func stopRecording() {
        generalTimer.invalidate()
        generalToolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), discardButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), startButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), saveButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)], animated: true)
    }
    
    @objc func discardRecording() {
        // Reset timer.
        generalTime = 0
        generalTimeLabel.text = "00:00:00.00"
        // Clear all graphs.
        temperatureGraph.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        temperatureCurrentRatio = 0
        temperatureIsFirstPoint = true
        temperatureShiftGraph = false
        humidityGraph.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        humidityCurrentRatio = 0
        humidityIsFirstPoint = true
        humidityShiftGraph = false
        lightGraph.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        lightCurrentRatio = 0
        lightIsFirstPoint = true
        lightShiftGraph = false
        soundGraph.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        soundCurrentRatio = 0
        soundIsFirstPoint = true
        soundShiftGraph = false
        // Reset all labels.
        temperatureLabel.text = "Temperature: --."
        humidityLabel.text = "Humidity: --."
        lightLabel.text = "Light: --."
        soundLabel.text = "Sound: --."
        // Set tool bar items.
        startButton.isEnabled = true
        generalToolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), startButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)], animated: true)
    }
    
    @objc func saveRecording() {
        //
    }
    
    @objc func setGeneralTime() {
        generalTime += 1
        generalTimeString = String(format: "%02i:%02i:%02i.%02i", generalTime / 360000, generalTime % 360000 / 6000, generalTime % 6000 / 100, generalTime % 100)
        generalTimeLabel.text = generalTimeString
        if generalTime % temperatureSampleInterval == 0 {
            displayTemperature()
        }
        if generalTime % humiditySampleInterval == 0 {
            displayHumidity()
        }
        if generalTime % lightSampleInterval == 0 {
            displayLight()
        }
        if generalTime % soundSampleInterval == 0 {
            displaySound()
        }
        if timeisFixed {
            if generalTime == timePeriod {
                stopRecording()
                startButton.isEnabled = false
            }
        }
    }
    
    @objc func displayTemperature() {
        // Modify label text.
        temperatureLabel.text = "Temperature: " + String(Int(AppData.temperature)) + "."
        if temperatureShiftGraph {
            // Draw new line and new point.
            let pointX = Double(temperatureDivideRatio) / 100 * Double(temperatureGraph.frame.width)
            let pointY = Double((100 - Double(AppData.temperature)) / 100) * Double(temperatureGraph.frame.height)
            CATransaction.begin()
            AppData.drawLine(graph: temperatureGraph, startX: temperatureLastPointX!, startY: temperatureLastPointY!, endX: pointX + Double(temperatureGraph.frame.width) / Double(100 / temperaturePointSpacingRatio), endY: pointY, color: UIColor.blue.cgColor, width: 3, speed: 1.0 + 4.0 / Float(temperatureSampleInterval))
            AppData.drawPoint(graph: temperatureGraph, positionX: pointX + Double(temperatureGraph.frame.width) / Double(100 / temperaturePointSpacingRatio), positionY: pointY, color: UIColor.red.cgColor, size: 5, speed: 1.0 + 4.0 / Float(temperatureSampleInterval))
            CATransaction.commit()
            temperatureLastPointX = pointX
            temperatureLastPointY = pointY
            // Shift the display area to the left.
            CATransaction.begin()
            temperatureGraph.layer.sublayers?.forEach {
                $0.transform = CATransform3DTranslate($0.transform, -temperatureGraph.frame.width / CGFloat(100 / temperaturePointSpacingRatio), 0.0, 0.0)
            }
            CATransaction.commit()
        } else {
            if temperatureIsFirstPoint {
                temperatureCurrentRatio -= temperaturePointSpacingRatio
            }
            temperatureCurrentRatio += temperaturePointSpacingRatio
            // Draw new point and new connection.
            let pointX = Double(temperatureCurrentRatio) / 100 * Double(temperatureGraph.frame.width)
            let pointY = Double((100 - Double(AppData.temperature)) / 100) * Double(temperatureGraph.frame.height)
            if temperatureIsFirstPoint {
                temperatureIsFirstPoint = false
            } else {
                AppData.drawLine(graph: temperatureGraph, startX: temperatureLastPointX!, startY: temperatureLastPointY!, endX: pointX, endY: pointY, color: UIColor.blue.cgColor, width: 3, speed: 1.0 + 4.0 / Float(temperatureSampleInterval))
            }
            AppData.drawPoint(graph: temperatureGraph, positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5, speed: 1.0 + 4.0 / Float(temperatureSampleInterval))
            temperatureLastPointX = pointX
            temperatureLastPointY = pointY
            // Check for division boundary.
            if temperatureCurrentRatio == temperatureDivideRatio {
                temperatureShiftGraph = true
            }
        }
        // Remove layers that go out of boundaries.
        temperatureGraph.layer.sublayers?.forEach {
            if $0.frame.origin.x < -temperatureGraph.frame.width {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    @objc func displayHumidity() {
        // Modify label text.
        humidityLabel.text = "Humidity: " + String(Int(AppData.humidity)) + "."
        if humidityShiftGraph {
            // Draw new line and new point.
            let pointX = Double(humidityDivideRatio) / 100 * Double(humidityGraph.frame.width)
            let pointY = Double((100 - Double(AppData.humidity)) / 100) * Double(humidityGraph.frame.height)
            CATransaction.begin()
            AppData.drawLine(graph: humidityGraph, startX: humidityLastPointX!, startY: humidityLastPointY!, endX: pointX + Double(humidityGraph.frame.width) / Double(100 / humidityPointSpacingRatio), endY: pointY, color: UIColor.blue.cgColor, width: 3, speed: 1.0 + 4.0 / Float(humiditySampleInterval))
            AppData.drawPoint(graph: humidityGraph, positionX: pointX + Double(humidityGraph.frame.width) / Double(100 / humidityPointSpacingRatio), positionY: pointY, color: UIColor.red.cgColor, size: 5, speed: 1.0 + 4.0 / Float(humiditySampleInterval))
            CATransaction.commit()
            humidityLastPointX = pointX
            humidityLastPointY = pointY
            // Shift the display area to the left.
            CATransaction.begin()
            humidityGraph.layer.sublayers?.forEach {
                $0.transform = CATransform3DTranslate($0.transform, -humidityGraph.frame.width / CGFloat(100 / humidityPointSpacingRatio), 0.0, 0.0)
            }
            CATransaction.commit()
        } else {
            if humidityIsFirstPoint {
                humidityCurrentRatio -= humidityPointSpacingRatio
            }
            humidityCurrentRatio += humidityPointSpacingRatio
            // Draw new point and new connection.
            let pointX = Double(humidityCurrentRatio) / 100 * Double(humidityGraph.frame.width)
            let pointY = Double((100 - Double(AppData.humidity)) / 100) * Double(humidityGraph.frame.height)
            if humidityIsFirstPoint {
                humidityIsFirstPoint = false
            } else {
                AppData.drawLine(graph: humidityGraph, startX: humidityLastPointX!, startY: humidityLastPointY!, endX: pointX, endY: pointY, color: UIColor.blue.cgColor, width: 3, speed: 1.0 + 4.0 / Float(humiditySampleInterval))
            }
            AppData.drawPoint(graph: humidityGraph, positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5, speed: 1.0 + 4.0 / Float(humiditySampleInterval))
            humidityLastPointX = pointX
            humidityLastPointY = pointY
            // Check for division boundary.
            if humidityCurrentRatio == humidityDivideRatio {
                humidityShiftGraph = true
            }
        }
        // Remove layers that go out of boundaries.
        humidityGraph.layer.sublayers?.forEach {
            if $0.frame.origin.x < -humidityGraph.frame.width {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    @objc func displayLight() {
        // Modify label text.
        lightLabel.text = "Light: " + String(Int(AppData.light)) + "."
        if lightShiftGraph {
            // Draw new line and new point.
            let pointX = Double(lightDivideRatio) / 100 * Double(lightGraph.frame.width)
            let pointY = Double((100 - Double(AppData.light) * 100 / 1023) / 100) * Double(lightGraph.frame.height)
            CATransaction.begin()
            AppData.drawLine(graph: lightGraph, startX: lightLastPointX!, startY: lightLastPointY!, endX: pointX + Double(lightGraph.frame.width) / Double(100 / lightPointSpacingRatio), endY: pointY, color: UIColor.blue.cgColor, width: 3, speed: 1.0 + 4.0 / Float(lightSampleInterval))
            AppData.drawPoint(graph: lightGraph, positionX: pointX + Double(lightGraph.frame.width) / Double(100 / lightPointSpacingRatio), positionY: pointY, color: UIColor.red.cgColor, size: 5, speed: 1.0 + 4.0 / Float(lightSampleInterval))
            CATransaction.commit()
            lightLastPointX = pointX
            lightLastPointY = pointY
            // Shift the display area to the left.
            CATransaction.begin()
            lightGraph.layer.sublayers?.forEach {
                $0.transform = CATransform3DTranslate($0.transform, -lightGraph.frame.width / CGFloat(100 / lightPointSpacingRatio), 0.0, 0.0)
            }
            CATransaction.commit()
        } else {
            if lightIsFirstPoint {
                lightCurrentRatio -= lightPointSpacingRatio
            }
            lightCurrentRatio += lightPointSpacingRatio
            // Draw new point and new connection.
            let pointX = Double(lightCurrentRatio) / 100 * Double(lightGraph.frame.width)
            let pointY = Double((100 - Double(AppData.light) * 100 / 1023) / 100) * Double(lightGraph.frame.height)
            if lightIsFirstPoint {
                lightIsFirstPoint = false
            } else {
                AppData.drawLine(graph: lightGraph, startX: lightLastPointX!, startY: lightLastPointY!, endX: pointX, endY: pointY, color: UIColor.blue.cgColor, width: 3, speed: 1.0 + 4.0 / Float(lightSampleInterval))
            }
            AppData.drawPoint(graph: lightGraph, positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5, speed: 1.0 + 4.0 / Float(lightSampleInterval))
            lightLastPointX = pointX
            lightLastPointY = pointY
            // Check for division boundary.
            if lightCurrentRatio == lightDivideRatio {
                lightShiftGraph = true
            }
        }
        // Remove layers that go out of boundaries.
        lightGraph.layer.sublayers?.forEach {
            if $0.frame.origin.x < -lightGraph.frame.width {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    @objc func displaySound() {
        // Modify label text.
        soundLabel.text = "Sound: " + String(Int(AppData.sound)) + "."
        if soundShiftGraph {
            // Draw new line and new point.
            let pointX = Double(soundDivideRatio) / 100 * Double(soundGraph.frame.width)
            let pointY = Double((100 - Double(AppData.sound) * 100 / 1023) / 100) * Double(soundGraph.frame.height)
            CATransaction.begin()
            AppData.drawLine(graph: soundGraph, startX: soundLastPointX!, startY: soundLastPointY!, endX: pointX + Double(soundGraph.frame.width) / Double(100 / soundPointSpacingRatio), endY: pointY, color: UIColor.blue.cgColor, width: 3, speed: 1.0 + 4.0 / Float(soundSampleInterval))
            AppData.drawPoint(graph: soundGraph, positionX: pointX + Double(soundGraph.frame.width) / Double(100 / soundPointSpacingRatio), positionY: pointY, color: UIColor.red.cgColor, size: 5, speed: 1.0 + 4.0 / Float(soundSampleInterval))
            CATransaction.commit()
            soundLastPointX = pointX
            soundLastPointY = pointY
            // Shift the display area to the left.
            CATransaction.begin()
            soundGraph.layer.sublayers?.forEach {
                $0.transform = CATransform3DTranslate($0.transform, -soundGraph.frame.width / CGFloat(100 / soundPointSpacingRatio), 0.0, 0.0)
            }
            CATransaction.commit()
        } else {
            if soundIsFirstPoint {
                soundCurrentRatio -= soundPointSpacingRatio
            }
            soundCurrentRatio += soundPointSpacingRatio
            // Draw new point and new connection.
            let pointX = Double(soundCurrentRatio) / 100 * Double(soundGraph.frame.width)
            let pointY = Double((100 - Double(AppData.sound) * 100 / 1023) / 100) * Double(soundGraph.frame.height)
            if soundIsFirstPoint {
                soundIsFirstPoint = false
            } else {
                AppData.drawLine(graph: soundGraph, startX: soundLastPointX!, startY: soundLastPointY!, endX: pointX, endY: pointY, color: UIColor.blue.cgColor, width: 3, speed: 1.0 + 4.0 / Float(soundSampleInterval))
            }
            AppData.drawPoint(graph: soundGraph, positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5, speed: 1.0 + 4.0 / Float(soundSampleInterval))
            soundLastPointX = pointX
            soundLastPointY = pointY
            // Check for division boundary.
            if soundCurrentRatio == soundDivideRatio {
                soundShiftGraph = true
            }
        }
        // Remove layers that go out of boundaries.
        soundGraph.layer.sublayers?.forEach {
            if $0.frame.origin.x < -soundGraph.frame.width {
                $0.removeFromSuperlayer()
            }
        }
    }
}
