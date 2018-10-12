//
//  BinarySearch.swift
//  Samples
//
//  Created by Kushal Ashok on 7/25/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation


//TODO: Find the position to insert so that array remains sorted
var insertPosition:Int?
var sortedArray = [1,2,3,3,3,3,5,5,5,5]

//Binary -> divide into 2 parts

func binarySearchInteger(_ array: [Int], value: Int) -> Int? {
    var lowerBound = 0
    var upperBound = array.count
    while lowerBound < upperBound {
        let midIndex = (upperBound - lowerBound) / 2
        if array[midIndex] == value {
            return midIndex
        } else if array[midIndex] < value {
            upperBound = midIndex
        } else {
            lowerBound = midIndex
        }
    }
    return nil
}


func binarySearchUdacity(_ array: [Int], value: Int) -> Int? {
    
    var lowIndex = 0
    var highIndex = array.count - 1
    
    while lowIndex <= highIndex {
        let midIndex = (lowIndex + highIndex) / 2
        if array[midIndex] == value {
            return midIndex
        } else if array[midIndex] < value {
            lowIndex = midIndex + 1
        } else {
            highIndex = midIndex - 1
        }
    }
    return nil
}

func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
    var lowerBound = 0
    var upperBound = a.count
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if a[midIndex] == key {
            return midIndex
        } else if a[midIndex] < key {
            lowerBound = midIndex + 1
        } else {
            upperBound = midIndex
        }
    }
    return nil
}

func binarySearch<T: Comparable>(_ array: [T], target: T) -> Int? {
    var lowerBound = 0
    var upperBound = array.count
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if array[midIndex] == target {
            return midIndex
        } else if array[midIndex] < target {
            lowerBound = midIndex + 1
        } else {
            upperBound = midIndex
        }
    }
    return nil
}





func binarySearch( _ a:[Int], target: Int) -> Int? {
    var lowerBound = 0
    var upperBound = a.count
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if a[midIndex] == target {
            return midIndex
        } else if a[midIndex] < target {
            lowerBound = midIndex + 1
        } else {
            upperBound = midIndex
        }
    }
    return nil
}

func testSearch() {
    guard let result = binarySearch([1,2,3], target: 2) else {return}
    let output = String(describing:result)
    print(output)
}

