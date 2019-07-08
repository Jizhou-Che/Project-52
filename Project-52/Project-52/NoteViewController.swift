//
//  NoteViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/7/7.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    // Properties.
    var timestamp = Int()
    let noteTextField = UITextField()
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load note navigation bar.
        navigationItem.title = "Note"
        let stopButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopNote))
        navigationItem.leftBarButtonItem = stopButton
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneNote))
        navigationItem.rightBarButtonItem = doneButton
        // Load note scroll view.
        let noteScrollView = UIScrollView()
        noteScrollView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        noteScrollView.backgroundColor = UIColor.white
        view.addSubview(noteScrollView)
        // Load user interface.
        let timeLabel = UILabel()
        timeLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 80)
        timeLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, y: 100)
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textAlignment = .center
        timeLabel.text = "Time: " + String(format: "%02i:%02i:%02i.%02i", timestamp / 360000, timestamp % 360000 / 6000, timestamp % 6000 / 100, timestamp % 100)
        noteScrollView.addSubview(timeLabel)
        let noteLabel = UILabel()
        noteLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.3, height: 40)
        noteLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.25, y: 200)
        noteLabel.adjustsFontSizeToFitWidth = true
        noteLabel.textAlignment = .natural
        noteLabel.text = "Note:"
        noteScrollView.addSubview(noteLabel)
        noteTextField.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, height: 40)
        noteTextField.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.6, y: 200)
        noteTextField.borderStyle = .roundedRect
        noteScrollView.addSubview(noteTextField)
    }
    
    @objc func stopNote() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneNote() {
        // Take note.
        dismiss(animated: true, completion: nil)
    }
}
