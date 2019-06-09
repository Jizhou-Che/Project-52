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
    
    var recordingSession: AVAudioSession!
    var soundRecorder: AVAudioRecorder!
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var timer: Timer?
    let displayInterval = 0.05
    var isFirstRecording = true
    let lineSpacingRatio = 1
    let divideRatio = 70
    var currentRatio = 0
    var shiftGraph = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove files.
        do {
            try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("recording_0.m4a"))
            try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("recording_1.m4a"))
            try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("recording_2.m4a"))
        } catch {
            // Error in removing files.
        }
        // Check for recording permission.
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        // Prepare for the first recording.
                        do {
                            self.soundRecorder = try AVAudioRecorder(url: self.documentDirectory.appendingPathComponent("recording_0.m4a"), settings: [
                                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                AVSampleRateKey: 44100,
                                AVNumberOfChannelsKey: 1,
                                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                            ])
                            self.soundRecorder.delegate = self
                            self.soundRecorder.prepareToRecord()
                        } catch {
                            // Error in creating sound recorder.
                        }
                    } else {
                        self.recordingSessionFail()
                    }
                }
            }
        } catch {
            self.recordingSessionFail()
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
    
    func recordingSessionFail() {
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
        if isFirstRecording {
            isFirstRecording = false
            soundRecorder.record()
        } else {
            // Stop previous recorder.
            soundRecorder.stop()
            // Manage names of recording files.
            var recordingFilePath: URL
            if !FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent("recording_1.m4a").path) {
                recordingFilePath = documentDirectory.appendingPathComponent("recording_1.m4a")
            } else {
                if FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent("recording_2.m4a").path){
                    do {
                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("recording_0.m4a"))
                        try FileManager.default.moveItem(at: documentDirectory.appendingPathComponent("recording_1.m4a"), to: documentDirectory.appendingPathComponent("recording_0.m4a"))
                        try FileManager.default.moveItem(at: documentDirectory.appendingPathComponent("recording_2.m4a"), to: documentDirectory.appendingPathComponent("recording_1.m4a"))
                    } catch {
                        // Error in removing or renaming of file.
                    }
                }
                recordingFilePath = documentDirectory.appendingPathComponent("recording_2.m4a")
            }
            print(recordingFilePath)
            // Record a piece of audio.
            do {
                soundRecorder = try AVAudioRecorder(url: recordingFilePath, settings: [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ])
                soundRecorder.delegate = self
                soundRecorder.record()
            } catch {
                // Error in creating sound recorder.
            }
            // Get a sample value from recording_0.m4a and plot it to the graph.
            if FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent("recording_2.m4a").path){
                do {
                    // Get a sample value from recording file.
                    let recordingFile = try AVAudioFile(forReading: documentDirectory.appendingPathComponent("recording_0.m4a"))
                    let audioBufferFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: recordingFile.fileFormat.sampleRate, channels: 1, interleaved: false)!
                    let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioBufferFormat, frameCapacity: AVAudioFrameCount(44100 * displayInterval))!
                    try recordingFile.read(into: audioBuffer)
                    let bufferArray = Array(UnsafeBufferPointer(start: audioBuffer.floatChannelData?[0], count: Int(audioBuffer.frameLength)))
                    var sum = Float(0)
                    for i in 0...Int(audioBuffer.frameLength - 1) {
                        sum += abs(bufferArray[i])
                    }
                    let sample = sum / Float(audioBuffer.frameLength) * 500
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
                } catch {
                    // Error in loading recording file.
                }
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
