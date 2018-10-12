//
//  TwoSums.swift
//  Samples
//
//  Created by Kushal Ashok on 7/31/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation

class Solution {
    
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        for (index1,firstNum) in nums.enumerated() {
            for (index2,secondNum) in nums.enumerated() where index1 != index2 && target == firstNum + secondNum {
                return [index1,index2]
            }
        }
        return [0,0]
        
//        var dict = [Int: Int]()
//        
//        for i in 0..<nums.count {
//            if let target = dict[nums[i]] {
//                return [target, i]
//            } else {
//                dict[target - nums[i]] = i
//            }
//        }
//        
//        return [0]
    }
}

func testTwoSums() {
    let solution = Solution()
    let inputArray = [-1,-2,-3,-4,-5]
    let target = -8
    let indices = solution.twoSum(inputArray, target)
    print("Solution for input \(inputArray) and target \(target) is \(indices)")
}
