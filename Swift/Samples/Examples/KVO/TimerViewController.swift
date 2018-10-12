//
//  TimerViewController.swift
//  Samples
//
//  Created by Kushal Ashok on 7/17/18.
//  Copyright © 2018 speed. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet var timeLabel: UILabel!
    
    // MARK: - For Key Value Observing demo
    
    @objc let configurationManager = ConfigurationManager(withConfiguration: Configuration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver(self, forKeyPath: #keyPath(configurationManager.configuration.updatedAt), options: [.old, .new, .initial], context: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Key-Value Observing
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(configurationManager.configuration.updatedAt) {
            // Update Time Label
            timeLabel.text = configurationManager.updatedAt
        }
    }
    
    // MARK: - Deinitialization
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(configurationManager.configuration.updatedAt))
    }
    
    // MARK: - Actions
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        configurationManager.updateConfiguration()
    }

}



