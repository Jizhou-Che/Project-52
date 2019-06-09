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
    let displayInterval = 0.1
    var isFirstRecording = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for recording permission.
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
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
                    /*
                    if !allowed {
                        self.recordingSessionFail()
                    }
                    */
                }
            }
        } catch {
            self.recordingSessionFail()
        }
    }
    
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
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
