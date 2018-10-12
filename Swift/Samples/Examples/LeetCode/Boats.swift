//
//  Boats.swift
//  Samples
//
//  Created by Kushal Ashok on 8/5/18.
//  Copyright © 2018 speed. All rights reserved.
//

import UIKit

//The i-th person has weight people[i], and each boat can carry a maximum weight of limit.
//
//Each boat carries at most 2 people at the same time, provided the sum of the weight of those people is at most limit.
//
//Return the minimum number of boats to carry every given person.  (It is guaranteed each person can be carried by a boat.)
//
//
//
//Example 1:
//
//Input: people = [1,2], limit = 3
//Output: 1
//Explanation: 1 boat (1, 2)
//Example 2:
//
//Input: people = [3,2,2,1], limit = 3
//Output: 3
//Explanation: 3 boats (1, 2), (2) and (3)
//Example 3:
//
//Input: people = [3,5,3,4], limit = 5
//Output: 4
//Explanation: 4 boats (3), (3), (4), (5)
//Note:
//
//1 <= people.length <= 50000
//1 <= people[i] <= limit <= 30000


func testBoats() {
//    let people = [3,2,2,1]
//    let limit = 3
//    let result = numRescueBoats(people, limit)
//    print("\(people) need \(result) boats when the limit on each boat is \(limit)")
}

//func numRescueBoats(_ people: [Int], _ limit: Int) -> Int {
//    var numberOfBoats = people.count
//    let sortedPeople = people.sorted()
//
//    var dictOfBoats = [Int:Int]()
//    for i in 0..<numberOfBoats {
//        dictOfBoats[i] = sortedPeople[i]
//    }
//
//    for key in dictOfBoats.keys {
//        guard let existingWeight = dictOfBoats[key] else {continue}
//        let remainingWeight = limit - existingWeight
//        dictOfBoats.filter({ (key,value) -> Bool in
//            <#code#>
//        })
//    }
//
//
//    return numberOfBoats
//}

