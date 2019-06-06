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
        // Add the CAShapeLayer to the graph.
        graph.layer.addSublayer(layer)
    }
    
    @objc func display() {
        // Clear the display area.
        graph.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        // Calculate actual position of point.
        let pointX = Double(value / 100) * Double(graph.bounds.size.width)
        let pointY = Double(value / 100) * Double(graph.bounds.size.width)
        drawPoint(positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5)
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
            timer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(display), userInfo: nil, repeats: true)
        }else{
            sender.setTitle("Start", for: .normal)
            timer?.invalidate()
        }
    }
}
