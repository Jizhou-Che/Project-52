//
//  ReviewViewController.swift
//  Project-52
//
//  Created by Jizhou Che on 2019/7/12.
//  Copyright © 2019 UNNC. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    // Properties.
    var recordingFileName: String!
    var recordingFilePath: URL!
    
    // Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the navigation item.
        navigationItem.title = recordingFileName
        let exportButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportRecording))
        navigationItem.rightBarButtonItem = exportButton
        // Load review scroll view.
        let reviewScrollView = UIScrollView()
        reviewScrollView.frame = CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        reviewScrollView.backgroundColor = .white
        view.addSubview(reviewScrollView)
    }
    
    @objc func exportRecording() {
        let exportActivityViewController = UIActivityViewController(activityItems: [recordingFilePath!], applicationActivities: [])
        present(exportActivityViewController, animated: true, completion: nil)
    }
}
