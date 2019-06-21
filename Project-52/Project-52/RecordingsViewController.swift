//
//  RecordingsViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/6/20.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class RecordingsViewController: UIViewController {
    // Outlets.
    @IBOutlet weak var recordingsTableView: UITableView!
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Adjust layout.
        recordingsTableView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
    }
}
