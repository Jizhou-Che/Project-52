//
//  RecordingsViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/20.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class RecordingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets.
    @IBOutlet weak var recordingsTableView: UITableView!
    
    // Properties.
    var recordingFiles: [String] = []
    var gestureRecognizer: UILongPressGestureRecognizer!
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the table view.
        recordingsTableView.delegate = self
        recordingsTableView.dataSource = self
        recordingsTableView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        // Say hello to Jony!
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(helloJony))
        gestureRecognizer.minimumPressDuration = 7
        navigationController?.navigationBar.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Remove temporary files if any.
        recordingFiles = try! FileManager.default.contentsOfDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path)
        for recordingFile in recordingFiles {
            if recordingFile.contains("_temp") {
                let recordingFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(recordingFile)
                if FileManager.default.fileExists(atPath: recordingFilePath.path) {
                    try! FileManager.default.removeItem(at: recordingFilePath)
                }
            }
        }
        // Sort the data source.
        recordingFiles = try! FileManager.default.contentsOfDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path)
        recordingFiles.sort()
        // Reload table view data source.
        recordingsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordingFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = recordingFiles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recordingFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(recordingFiles[indexPath.row])
        let reviewViewController = ReviewViewController()
        reviewViewController.recordingFileName = recordingFiles[indexPath.row]
        reviewViewController.recordingFilePath = recordingFilePath
        navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! FileManager.default.removeItem(at: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(recordingFiles[indexPath.row]))
            recordingFiles.remove(at: indexPath.row)
            recordingsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func helloJony() {
        switch gestureRecognizer.state {
        case .began:
            navigationItem.title = "Jony"
        case .ended:
            navigationItem.title = title
        default:
            break
        }
    }
}
