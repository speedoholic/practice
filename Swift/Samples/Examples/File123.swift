//
//  File123.swift
//  Samples
//
//  Created by Kushal Ashok on 10/11/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation


func getLengthofLongestSubstring(_ input:String) -> Int {
    
    var longestUniqueString = ""
    var uniqueString = ""
    
    //O(n*n)
    for character in input {
        if uniqueString.isEmpty {
            uniqueString += String(character)
        } else {
            var isMatchFound = false
            for existingCharacter in uniqueString {
                if existingCharacter == character {
                    isMatchFound = true
                    break
                }
            }
            if isMatchFound {
                uniqueString = ""
            } else {
                uniqueString += String(character)
            }
        }
        
        if uniqueString.count > longestUniqueString.count {
            longestUniqueString = uniqueString
        }
    }
    return longestUniqueString.count
}


