//
//  SaveViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/27.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController {
    // Properties.
    var doneButton: UIBarButtonItem!
    let recorderTextField = UITextField()
    let participantTextField = UITextField()
    let locationTextField = UITextField()
    let notesTextField = UITextField()
    var recordingFilePath: URL!
    var recordingFileContent: [[String]] = []
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set title of view controller.
        navigationItem.title = "Save"
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveRecording))
        navigationItem.rightBarButtonItem = doneButton
        // Load save scroll view.
        let saveScrollView = UIScrollView()
        saveScrollView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        saveScrollView.backgroundColor = UIColor.white
        view.addSubview(saveScrollView)
        // Load labels and text fields.
        // Recorder.
        let recorderLabel = UILabel()
        recorderLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.3, height: 40)
        recorderLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.25, y: 50)
        recorderLabel.adjustsFontSizeToFitWidth = true
        recorderLabel.textAlignment = .natural
        recorderLabel.text = "Recorder:"
        saveScrollView.addSubview(recorderLabel)
        recorderTextField.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 40)
        recorderTextField.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.65, y: 50)
        recorderTextField.borderStyle = .roundedRect
        saveScrollView.addSubview(recorderTextField)
        // Participant.
        let participantLabel = UILabel()
        participantLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.3, height: 40)
        participantLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.25, y: 110)
        participantLabel.adjustsFontSizeToFitWidth = true
        participantLabel.textAlignment = .natural
        participantLabel.text = "Participant:"
        saveScrollView.addSubview(participantLabel)
        participantTextField.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 40)
        participantTextField.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.65, y: 110)
        participantTextField.borderStyle = .roundedRect
        saveScrollView.addSubview(participantTextField)
        // Location.
        let locationLabel = UILabel()
        locationLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.3, height: 40)
        locationLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.25, y: 170)
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.textAlignment = .natural
        locationLabel.text = "Location:"
        saveScrollView.addSubview(locationLabel)
        locationTextField.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 40)
        locationTextField.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.65, y: 170)
        locationTextField.borderStyle = .roundedRect
        saveScrollView.addSubview(locationTextField)
        // Notes.
        let notesLabel = UILabel()
        notesLabel.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.3, height: 40)
        notesLabel.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.25, y: 230)
        notesLabel.adjustsFontSizeToFitWidth = true
        notesLabel.textAlignment = .natural
        notesLabel.text = "Notes:"
        saveScrollView.addSubview(notesLabel)
        notesTextField.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 40)
        notesTextField.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.65, y: 230)
        notesTextField.borderStyle = .roundedRect
        saveScrollView.addSubview(notesTextField)
        // Set content size of scroll view.
        saveScrollView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 1400)
    }
    
    @objc func saveRecording() {
        recordingFileContent.insert([recorderTextField.text!, "", "", "", "", "", ""], at: 0)
        recordingFileContent.insert([participantTextField.text!, "", "", "", "", "", ""], at: 1)
        recordingFileContent.insert([locationTextField.text!, "", "", "", "", "", ""], at: 2)
        recordingFileContent.insert([notesTextField.text!, "", "", "", "", "", ""], at: 3)
        if FileManager.default.fileExists(atPath: recordingFilePath.path) {
            try? FileManager.default.removeItem(at: recordingFilePath)
        }
        FileManager.default.createFile(atPath: recordingFilePath.path, contents: nil, attributes: nil)
        for row in recordingFileContent {
            let rowString = row.joined(separator: ",") + "\n"
            if let recordingFileHandle = try? FileHandle(forWritingTo: recordingFilePath) {
                recordingFileHandle.seekToEndOfFile()
                recordingFileHandle.write(rowString.data(using: .utf8)!)
                recordingFileHandle.closeFile()
            } else {
                print("Cannot open file.")
            }
        }
        navigationController?.popToViewController((navigationController?.viewControllers.first)!, animated: true)
    }
}
