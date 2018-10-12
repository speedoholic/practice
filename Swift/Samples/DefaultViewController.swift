//
//  DefaultViewController.swift
//  Samples
//
//  Created by Kushal Ashok on 8/2/18.
//  Copyright © 2018 speed. All rights reserved.
//

import UIKit

class DefaultViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func executeButtonTapped(_ sender: Any) {
        let result = getLengthofLongestSubstring("bbbb")
        print(result)
    }
    
}

