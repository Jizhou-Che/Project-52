//
//  HumidityViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/6.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class HumidityViewController: UIViewController {
    // Outlets.
    @IBOutlet weak var graph: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    
    // Properties.
    var timer = Timer()
    let displayInterval = 0.4
    let pointSpacingRatio = 5
    let divideRatio = 70
    var currentRatio = 0
    var isFirstPoint = true
    var shiftGraph = false
    var lastPointX: Double?
    var lastPointY: Double?
    
    // Actions.
    @IBAction func toggle_display(_ sender: UIButton) {
        if sender.title(for: .normal) == "Start" {
            sender.setTitle("Stop", for: .normal)
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: displayInterval, target: self, selector: #selector(display), userInfo: nil, repeats: true)
        } else {
            sender.setTitle("Start", for: .normal)
            timer.invalidate()
        }
    }
    
    // Methods.
    @objc func display() {
        valueLabel.text = "Humidity: " + String(AppData.humidity)
        if shiftGraph {
            // Draw new line and new point.
            let pointX = Double(divideRatio) / 100 * Double(graph.bounds.size.width)
            let pointY = Double((100 - Double(AppData.humidity)) / 100) * Double(graph.bounds.size.height)
            CATransaction.begin()
            AppData.drawLine(graph: graph, startX: lastPointX!, startY: lastPointY!, endX: pointX + Double(graph.bounds.size.width) / Double(100 / pointSpacingRatio), endY: pointY, color: UIColor.blue.cgColor, width: 3)
            AppData.drawPoint(graph: graph, positionX: pointX + Double(graph.bounds.size.width) / Double(100 / pointSpacingRatio), positionY: pointY, color: UIColor.red.cgColor, size: 5)
            CATransaction.commit()
            lastPointX = pointX
            lastPointY = pointY
            // Shift the display area to the left.
            CATransaction.begin()
            graph.layer.sublayers?.forEach {
                $0.transform = CATransform3DTranslate($0.transform, -graph.bounds.size.width / CGFloat(100 / pointSpacingRatio), 0.0, 0.0)
            }
            CATransaction.commit()
        } else {
            if isFirstPoint {
                currentRatio -= pointSpacingRatio
            }
            currentRatio += pointSpacingRatio
            // Draw new point and new connection.
            let pointX = Double(currentRatio) / 100 * Double(graph.bounds.size.width)
            let pointY = Double((100 - Double(AppData.humidity)) / 100) * Double(graph.bounds.size.height)
            if isFirstPoint {
                isFirstPoint = false
            } else {
                AppData.drawLine(graph: graph, startX: lastPointX!, startY: lastPointY!, endX: pointX, endY: pointY, color: UIColor.blue.cgColor, width: 3)
            }
            AppData.drawPoint(graph: graph, positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5)
            lastPointX = pointX
            lastPointY = pointY
            // Check for division boundary.
            if currentRatio == divideRatio {
                shiftGraph = true
            }
        }
        // Remove layers that go out of boundaries.
        graph.layer.sublayers?.forEach {
            if $0.frame.origin.x < -graph.bounds.size.width {
                $0.removeFromSuperlayer()
            }
        }
    }
}
