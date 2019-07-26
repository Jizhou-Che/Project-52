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
    var recorderTextField: UITextField!
    var participantTextField: UITextField!
    var locationTextField: UITextField!
    var notesTextField: UITextField!
    var recordingFileName: String!
    var notes: [[String]]!
    var sensorInformation: String!
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the navigation item.
        navigationItem.title = "Save"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveRecording))
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
        recorderTextField = UITextField()
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
        participantTextField = UITextField()
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
        locationTextField = UITextField()
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
        notesTextField = UITextField()
        notesTextField.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width * 0.5, height: 40)
        notesTextField.center = CGPoint(x: view.safeAreaLayoutGuide.layoutFrame.width * 0.65, y: 230)
        notesTextField.borderStyle = .roundedRect
        saveScrollView.addSubview(notesTextField)
        // Set content size of scroll view.
        saveScrollView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 1400)
    }
    
    @objc func saveRecording() {
        // Create new file.
        let recordingFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(recordingFileName + ".csv")
        if FileManager.default.fileExists(atPath: recordingFilePath.path) {
            try? FileManager.default.removeItem(at: recordingFilePath)
        }
        FileManager.default.createFile(atPath: recordingFilePath.path, contents: nil, attributes: nil)
        // Record to the new file.
        let metadataString = ["Recorder", "\"" + (recorderTextField.text!) + "\"", "", "", "", ""].joined(separator: ",") + "\n" + ["Participant", "\"" + (participantTextField.text!) + "\"", "", "", "", ""].joined(separator: ",") + "\n" + ["Location", "\"" + (locationTextField.text!) + "\"", "", "", "", ""].joined(separator: ",") + "\n" + ["Notes", "\"" + (notesTextField.text!) + "\"", "", "", "", ""].joined(separator: ",") + "\n"
        if let recordingFileHandle = try? FileHandle(forWritingTo: recordingFilePath) {
            // Write metadata.
            recordingFileHandle.seekToEndOfFile()
            recordingFileHandle.write(metadataString.data(using: .utf8)!)
            // Write sensor information.
            recordingFileHandle.write(sensorInformation.data(using: .utf8)!)
            // Concatenate the temporary file.
            let tempFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(recordingFileName + "_temp.csv")
            if let tempFileHandle = try? FileHandle(forReadingFrom: tempFilePath) {
                recordingFileHandle.write(tempFileHandle.readDataToEndOfFile())
            } else {
                print("Cannot open temporary file.")
            }
            // Write notes.
            recordingFileHandle.write("Notes,,,,,\n".data(using: .utf8)!)
            for contentRow in notes {
                let noteString = contentRow.joined(separator: ",") + "\n"
                recordingFileHandle.write(noteString.data(using: .utf8)!)
            }
            // Close file.
            recordingFileHandle.closeFile()
        } else {
            print("Cannot open recording file.")
        }
        navigationController?.popToViewController((navigationController?.viewControllers.first)!, animated: true)
    }
}
