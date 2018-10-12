//
//  MoveZerosToEnd.swift
//  Samples
//
//  Created by Kushal Ashok on 8/2/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation

func testMoveZerosToEnd() {
    var output = [Int]()
    let inputArray: [Int] = [1,0,3,0,5,7,0,9]
    //Required Output: [1,3,5,7,9,0,0,0]
    
    //Detect Zero
    var remainingElements = [Int]()
    let zerosInArray = inputArray.filter { (item) -> Bool in
        if item > 0 {
            remainingElements.append(item)
            return false
        } else {
            return true
        }
    }
    output = remainingElements + zerosInArray
    print(output)
}
