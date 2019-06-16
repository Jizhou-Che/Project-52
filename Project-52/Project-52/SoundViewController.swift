//
//  SoundViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/8.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController, AVAudioRecorderDelegate {
    // Properties.
    @IBOutlet weak var graph: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    var audioSession: AVAudioSession!
    var audioEngine: AVAudioEngine!
    var audioBuffer: Array<Float>?
    var timer: Timer?
    let displayInterval = 0.05
    let lineSpacingRatio = 1
    let divideRatio = 70
    var currentRatio = 0
    var shiftGraph = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for recording permission.
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.audioEngine = AVAudioEngine()
                        let inputNode = self.audioEngine.inputNode
                        let bufferSize = 4410
                        let bus = 0
                        inputNode.installTap(onBus: bus, bufferSize: UInt32(bufferSize), format: inputNode.inputFormat(forBus: bus)) { buffer, time in
                            DispatchQueue.main.async {
                                self.audioBuffer = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count: Int(buffer.frameLength)))
                            }
                        }
                        self.audioEngine.prepare()
                        try! self.audioEngine.start()
                        self.startButton.isEnabled = true
                    } else {
                        self.audioSessionFail()
                    }
                }
            }
        } catch {
            self.audioSessionFail()
        }
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func audioSessionFail() {
        let alert = UIAlertController(title: "Oh shit!", message: "Your microphone cannot be accessed!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Fine", style: UIAlertAction.Style.destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { _ in
            self.navigationController?.popViewController(animated: false)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        self.present(alert, animated: true)
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
        layer.transform = CATransform3DMakeTranslation(0.0, 0.0, 0.0)
        // Add the CAShapeLayer to the graph.
        graph.layer.addSublayer(layer)
    }
    
    @objc func display() {
        // Get a sample from the audio buffer.
        var sum = Float(0)
        for i in audioBuffer ?? [0.0] {
            sum += abs(i)
        }
        let sample = sum / Float(audioBuffer?.count ?? 1) * 500
        // Draw the graph.
        if shiftGraph {
            // Draw new line.
            let lineX = Double(divideRatio) / 100 * Double(graph.bounds.size.width)
            CATransaction.begin()
            drawLine(startX: lineX, startY: Double((100 - sample) / 2) / 100 * Double(graph.bounds.size.height), endX: lineX, endY: Double((100 + sample) / 2) / 100 * Double(graph.bounds.size.height), color: UIColor.blue.cgColor, width: 2)
            CATransaction.commit()
            // Shift the display area to the left.
            CATransaction.begin()
            graph.layer.sublayers?.forEach {
                $0.transform = CATransform3DTranslate($0.transform, -graph.bounds.size.width / CGFloat(100 / lineSpacingRatio), 0.0, 0.0)
            }
            CATransaction.commit()
        } else {
            currentRatio += lineSpacingRatio
            // Draw new line.
            let lineX = Double(currentRatio) / 100 * Double(graph.bounds.size.width)
            drawLine(startX: lineX, startY: Double((100 - sample) / 2) / 100 * Double(graph.bounds.size.height), endX: lineX, endY: Double((100 + sample) / 2) / 100 * Double(graph.bounds.size.height), color: UIColor.blue.cgColor, width: 2)
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
    @IBAction func toggle_display(_ sender: UIButton) {
        if sender.title(for: .normal) == "Start" {
            sender.setTitle("Stop", for: .normal)
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: displayInterval, target: self, selector: #selector(display), userInfo: nil, repeats: true)
        }else{
            sender.setTitle("Start", for: .normal)
            timer?.invalidate()
        }
    }
}
