//
//  AppData.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/19.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

public class AppData {
    // Properties.
    static var dataString = String("0000000000000000")
    static var temperature = Int()
    static var humidity = Int()
    static var light = Int()
    static var sound = Int()
    static var microphone = Float()
    
    // Methods.
    static func drawPoint(graph: UIView, positionX: Double, positionY: Double, color: CGColor, size: CGFloat, speed: Float) {
        // Create path.
        let path = UIBezierPath(arcCenter: CGPoint(x: positionX, y: positionY), radius: size, startAngle: 0 * CGFloat.pi / 180, endAngle: 360 * CGFloat.pi / 180, clockwise: true)
        // Create a layer with the path.
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = color
        layer.transform = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
        layer.speed = speed
        // Add the layer to the graph.
        graph.layer.addSublayer(layer)
    }
    
    static func drawLine(graph: UIView, startX: Double, startY: Double, endX: Double, endY: Double, color: CGColor, width: CGFloat, speed: Float) {
        // Create path.
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        // Create a layer with the path.
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = width
        layer.zPosition = -0.1
        layer.transform = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
        layer.speed = speed
        // Add the layer to the graph.
        graph.layer.addSublayer(layer)
    }
}
