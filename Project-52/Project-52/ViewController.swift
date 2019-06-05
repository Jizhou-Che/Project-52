//
//  ViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/5.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Properties.
    @IBOutlet weak var graph: UIView!
    @IBOutlet weak var inputX: UITextField!
    @IBOutlet weak var inputY: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Actions.
    @IBAction func display(_ sender: UIButton) {
        // Check inputs.
        if Double(inputX.text ?? "") == nil || Double(inputY.text ?? "") == nil {
            let alert = UIAlertController(title: "Oh shit!", message: "Your inputs are invalid!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Fine.", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            // Calculate actual position of point.
            let pointX = round(Double(inputX.text ?? "")! / 100 * Double(self.graph.bounds.size.width))
            let pointY = round(Double(inputY.text ?? "")! / 100 * Double(self.graph.bounds.size.height))
            // Create path.
            let path = UIBezierPath()
            path.move(to: CGPoint(x: pointX, y: pointY))
            path.addLine(to: CGPoint(x: pointX + 10, y: pointY))
            // Create a CAShapeLayer that uses that UIBezierPath.
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.blue.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 10
            // Add the CAShapeLayer to the graph.
            graph.layer.addSublayer(shapeLayer)
        }
    }
}
