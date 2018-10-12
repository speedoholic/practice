//
//  CapGemini.swift
//  Samples
//
//  Created by Kushal Ashok on 8/6/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation


//Given an array of integers, return indices of the two numbers such that they add up to a specific target.
//
//You may assume that each input would have exactly one solution, and you may not use the same element twice.
//
//Consider the time complexity and space complexity.
//
//Example:
//
//Given nums = [2, 7, 11, 15], target = 9,
//
//Because nums[0] + nums[1] = 2 + 7 = 9,
//return [0, 1].
///**
// * Complexity Time: O(n*n), Space: O(1)
// */
//class Solution {
//    public int[] twoSum(int[] nums, int target) {
//    for (index1,firstNum) in nums.enumerated() {
//    for(index2,secondNum) in nums.enumerated() where index1 != index2 && target == firstNum + secondNum {
//    return [index1, index2]
//    }
//    }
//    return [0,0]
//    }
//}
//
///**
// * Complexity Time: O(n), Space: O(n)
// */
//class Solution2 {
//    public int[] twoSum(int[] nums, int target) {
//    var dictionary = [Int:Int]()
//    for i in 0..<nums.count {
//    if let value = dict[nums[i]] {
//    retun [value,i]
//    } else {
//    dictionary[target - nums[i]] = i
//    }
//    }
//    return [0,0]
//    }
//}

//Invert a binary tree.
//
//Example:
//
//Input:
//
//4
///   \
//2     7
/// \   / \
//1   3 6   9
//Output:
//
//4
///   \
//7     2
/// \   / \
//9   6 3   1


/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */
//class Solution {
//
//    public TreeNode invertTree(TreeNode root) {
//    invert(root)
//    }
//
//    func invert(_ node: TreeNode) {
//        switch node {
//        case .empty:
//            return .empty
//        case .leaf(let value):
//            return .leaf(valiue)
//        case .node(let value, let left, let right):
//            node = TreeNode(val)
//            node.left = invert(node.right)
//            node.right = invert(node.left)
//            return node
//        }
//    }
//}

struct sadf {
    var items = [Int]()
    mutating func add(x: Int) {
        items.append(x)
    }
}

func testCap() {
    
}
