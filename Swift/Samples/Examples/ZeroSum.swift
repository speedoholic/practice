//
//  ZeroSum.swift
//  Samples
//
//  Created by Kushal Ashok on 7/25/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation

struct Triplet: Hashable {
    var first = 0
    var second = 0
    var third = 0
    public static func == (lhs: Triplet, rhs: Triplet) -> Bool {
        if lhs.first == rhs.first && lhs.second == rhs.second && lhs.third == rhs.third {
            return true
        } else {
            return false
        }
    }
}

func getUniqueTripletsWithSumZero(_ array: [Int]) -> Set<Triplet> {
    var setOfTuples = Set<Triplet>()
    for (index,item) in array.enumerated() {
        let first = item
        for (index1,item1) in array.enumerated() {
            if index1 != index {
                let second = item1
                for (index2,item2) in array.enumerated() {
                    if index2 != index1 && index2 != index {
                        let third = item2
                        if first + second + third == 0 {
                            let triplet = Triplet(first: first, second: second, third: third)
                            setOfTuples.insert(triplet)
                        }
                    }
                }
            }
        }
    }
    return setOfTuples
}

func testSumZero() {
    let array = [-1, 0, 1, 2, -1, -4]
    print(getUniqueTripletsWithSumZero(array))
}

