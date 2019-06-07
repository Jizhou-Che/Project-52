//
//  HumidityViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/6.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class HumidityViewController: UIViewController {
    // Properties.
    @IBOutlet weak var graph: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var value = Float(50)
    var timer: Timer?
    let pointSpacingRatio = 5
    let divideRatio = 70
    var currentRatio = 0
    var isFirstPoint = true
    var shiftGraph = false
    var lastPointX: Double?
    var lastPointY: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func drawPoint(positionX: Double, positionY: Double, color: CGColor, size: CGFloat) {
        // Create path.
        let path = UIBezierPath(arcCenter: CGPoint(x: positionX, y: positionY), radius: size, startAngle: 0 * CGFloat.pi / 180, endAngle: 360 * CGFloat.pi / 180, clockwise: true)
        // Create a CAShapeLayer that uses that UIBezierPath.
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = color
        layer.transform = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
        // Add the CAShapeLayer to the graph.
        graph.layer.addSublayer(layer)
    }
    
    func drawLine(startX: Double, startY: Double, endX: Double, endY: Double, color: CGColor, width: CGFloat) {
        // Create path.
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        // Create a CAShapeLayer that uses that UIBezierPath.
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = width
        layer.zPosition = -0.1
        layer.transform = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
        // Add the CAShapeLayer to the graph.
        graph.layer.addSublayer(layer)
    }
    
    @objc func display() {
        if shiftGraph {
            // Draw new line and new point.
            let pointX = Double(divideRatio) / 100 * Double(graph.bounds.size.width)
            let pointY = Double((100 - value) / 100) * Double(graph.bounds.size.width)
            CATransaction.begin()
            drawLine(startX: lastPointX!, startY: lastPointY!, endX: pointX + Double(graph.bounds.size.width) / Double(100 / pointSpacingRatio), endY: pointY, color: UIColor.blue.cgColor, width: 3)
            drawPoint(positionX: pointX + Double(graph.bounds.size.width) / Double(100 / pointSpacingRatio), positionY: pointY, color: UIColor.red.cgColor, size: 5)
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
            let pointY = Double((100 - value) / 100) * Double(graph.bounds.size.width)
            if isFirstPoint {
                isFirstPoint = false
            } else {
                drawLine(startX: lastPointX!, startY: lastPointY!, endX: pointX, endY: pointY, color: UIColor.blue.cgColor, width: 3)
            }
            drawPoint(positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5)
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
    
    // Actions.
    @IBAction func set_value(_ sender: UISlider) {
        value = sender.value
        valueLabel.text = "Value: " + String(value)
    }
    
    @IBAction func toggle_display(_ sender: UIButton) {
        if sender.title(for: .normal) == "Start" {
            sender.setTitle("Stop", for: .normal)
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(display), userInfo: nil, repeats: true)
        }else{
            sender.setTitle("Start", for: .normal)
            timer?.invalidate()
        }
    }
}
