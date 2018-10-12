//
//  NavigateToTimer.swift
//  Samples
//
//  Created by Kushal Ashok on 8/2/18.
//  Copyright © 2018 speed. All rights reserved.
//

import UIKit

func testTimerKVO() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    var oldViewController = appDelegate.window?.rootViewController
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    appDelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "TimerViewController")
    appDelegate.window?.makeKeyAndVisible()
    oldViewController?.removeFromParentViewController()
    oldViewController = nil
}
