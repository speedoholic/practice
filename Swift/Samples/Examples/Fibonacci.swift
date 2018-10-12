//
//  Fibonacci.swift
//  Samples
//
//  Created by Kushal Ashok on 7/26/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation


func getFib(_ position: Int) -> Int {
    
    if position == 0 || position == 1 {
        return position
    }
    
    var first = 0
    var second = 1
    var fib = 1
    
    for _ in 2...position {
        fib = first + second
        first = second
        second = fib
    }
    return fib
}

func getFibUsingRecursive(_ position: Int) -> Int {
    if position == 0 || position == 1 {
        return position
    }
    return getFib(position - 1) + getFib(position - 2)
}




func testFibonacci() {
    print(getFib(9)) // Should be 34
    print(getFibUsingRecursive(11)) // Should be 89
    print(getFibUsingRecursive(0)) // Should be 0
}
