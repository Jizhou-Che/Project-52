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
    @IBOutlet weak var generalToolBar: UIToolbar!
    
    // Properties.
    var temperatureIsOn = Bool()
    var temperatureSampleInterval = Int()
    var humidityIsOn = Bool()
    var humiditySampleInterval = Int()
    var lightIsOn = Bool()
    var lightSampleRate = Int()
    var soundIsOn = Bool()
    var soundSampleRate = Int()
    var microphoneIsOn = Bool()
    var microphoneSampleRate = Int()
    var timeisFixed = Bool()
    var timePeriod = Int()
    var lightGraph = UIView()
    var lightTimer = Timer()
    var lightDisplayInterval = Double()
    var lightPointSpacingRatio = 5
    var lightDivideRatio = 70
    var lightCurrentRatio = 0
    var lightIsFirstPoint = true
    var lightShiftGraph = false
    var lightLastPointX: Double?
    var lightLastPointY: Double?
    var startButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startRecording))
    var stopButton = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(stopRecording))
    var discardButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(discardRecording))
    var saveButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(saveRecording))
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adjust layout.
        generalScrollView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height * 0.9)
        generalScrollView.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: view.safeAreaLayoutGuide.layoutFrame.height * 0.45)
        generalToolBar.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height * 0.1)
        generalToolBar.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: view.safeAreaLayoutGuide.layoutFrame.height * 0.95)
        // Load items in tool bar.
        generalToolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), startButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)], animated: true)
        // Load graphs for available sensors.
        if lightIsOn {
            // Load graph.
            lightGraph.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.9, height: view.safeAreaLayoutGuide.layoutFrame.width * 0.675)
            lightGraph.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 10 + lightGraph.frame.height * 0.5)
            lightGraph.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            lightGraph.clipsToBounds = true
            generalScrollView.addSubview(lightGraph)
            // Set display interval.
            lightDisplayInterval = 1 / Double(lightSampleRate)
        }
        // Set content size of scroll view.
        generalScrollView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 1400)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Invalidate all timers.
        if isMovingFromParent {
            lightTimer.invalidate()
        }
    }
    
    @objc func startRecording() {
        if lightIsOn {
            lightTimer.invalidate()
            lightTimer = Timer.scheduledTimer(timeInterval: lightDisplayInterval, target: self, selector: #selector(displayLight), userInfo: nil, repeats: true)
        }
        generalToolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), stopButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)], animated: true)
        /*
        print("Temperature: " + String(AppData.temperature))
        print("Humidity: " + String(AppData.humidity))
        print("Light: " + String(AppData.light))
        print("Sound: " + String(AppData.sound))
        */
    }
    
    @objc func stopRecording() {
        if lightIsOn {
            lightTimer.invalidate()
        }
        generalToolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), discardButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), startButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), saveButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)], animated: true)
    }
    
    @objc func discardRecording() {
        generalToolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil), startButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)], animated: true)
    }
    
    @objc func saveRecording() {
        //
    }
    
    @objc func displayLight() {
        if lightShiftGraph {
            // Draw new line and new point.
            let pointX = Double(lightDivideRatio) / 100 * Double(lightGraph.frame.width)
            let pointY = Double((100 - Double(AppData.light) * 100 / 1023) / 100) * Double(lightGraph.frame.height)
            CATransaction.begin()
            AppData.drawLine(graph: lightGraph, startX: lightLastPointX!, startY: lightLastPointY!, endX: pointX + Double(lightGraph.frame.width) / Double(100 / lightPointSpacingRatio), endY: pointY, color: UIColor.blue.cgColor, width: 3)
            AppData.drawPoint(graph: lightGraph, positionX: pointX + Double(lightGraph.frame.width) / Double(100 / lightPointSpacingRatio), positionY: pointY, color: UIColor.red.cgColor, size: 5)
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
                AppData.drawLine(graph: lightGraph, startX: lightLastPointX!, startY: lightLastPointY!, endX: pointX, endY: pointY, color: UIColor.blue.cgColor, width: 3)
            }
            AppData.drawPoint(graph: lightGraph, positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5)
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
}
