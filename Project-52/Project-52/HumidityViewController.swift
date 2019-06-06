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
    @IBOutlet weak var inputX: UITextField!
    @IBOutlet weak var inputY: UITextField!
    
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
    
    // Actions.
    @IBAction func display(_ sender: UIButton) {
        // Clear the display area.
        self.graph.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        // Check inputs.
        if Double(inputX.text ?? "") == nil || Double(inputY.text ?? "") == nil {
            let alert = UIAlertController(title: "Oh shit!", message: "Your inputs are invalid!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Fine.", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            // Calculate actual position of point.
            let pointX = round(Double(inputX.text ?? "")! / 100 * Double(self.graph.bounds.size.width))
            let pointY = round(Double(inputY.text ?? "")! / 100 * Double(self.graph.bounds.size.height))
            drawPoint(positionX: pointX, positionY: pointY, color: UIColor.red.cgColor, size: 5)
        }
    }
}
