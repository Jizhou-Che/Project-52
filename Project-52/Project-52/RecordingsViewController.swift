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
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the table view.
        recordingsTableView.delegate = self
        recordingsTableView.dataSource = self
        recordingsTableView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recordingFiles = try! FileManager.default.contentsOfDirectory(atPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path)
        recordingFiles.sort()
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
        print(try! String(contentsOf: recordingFilePath, encoding: .utf8))
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
}
