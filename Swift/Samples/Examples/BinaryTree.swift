// Top view of a binary tree is the set of nodes visible when the tree is viewed from the top. Given a binary tree, print the top view of it. The output nodes can be printed in any order. Expected time complexity is O(n)

// A node x is there in output if x is the topmost node at its horizontal distance. Horizontal distance of left child of a node x is equal to horizontal distance of x minus 1, and that of right child is horizontal distance of x plus 1.

//         1(0)
//     /           \
//    2(-1)        3(1)
//   /     \      /     \
//  4(-2)   5(0) 6(0)   7(2)
// Top view of the above binary tree is
// 4 2 1 3 7

//         1(0)
//       /   \
//     2       3
//       \
//         4
//           \
//             5
//              \
//                6
// Top view of the above binary tree is
// 2 1 3 6

import Foundation

class bTreeNode {
    var value: Int
    var left: bTreeNode?
    var right: bTreeNode?
    var horizontalDistance = 0
    
    init(_ value: Int) {
        self.value = value
    }
    
    
    /// It will calculate the horizontal distance of the node
    ///
    /// - Parameter parentNode: The parent node of target node
    /// - Returns: horizontal distance
    func getHorizontalDistance(_ parentNode: bTreeNode?) -> Int {
        guard let parent = parentNode else {return 0}
        if let leftNode = parent.left, leftNode.value == self.value {
            self.horizontalDistance = parent.horizontalDistance - 1
            return self.horizontalDistance
        } else {
            self.horizontalDistance = parent.horizontalDistance + 1
            return self.horizontalDistance
        }
    }
    
}



class BTree {
    var rootNode: bTreeNode
    var topViewOutput = [Int]()
    var setOfHorizontalDistance = Set<Int>()
    var queue = [bTreeNode]()
    
    init(_ value: Int) {
        rootNode = bTreeNode.init(value)
        topViewOutput.append(value)
        setOfHorizontalDistance.insert(0)
    }
    
    func getTopView() -> [Int] {
        queue.append(rootNode)
        calculateHozForNode(rootNode)
        return topViewOutput
    }
    
    //TODO: Traverse the tree level wise
    func calculateHozForNode(_ node: bTreeNode) {
        //Retreieve
        if let leftNode = node.left {
            let leftHoz = leftNode.getHorizontalDistance(node)
            print("Hoz for left \(leftNode.value) is \(leftHoz)")
            self.checkHoz(leftHoz,value: leftNode.value)
            queue.append(leftNode)
        }
        if let rightNode = node.right {
            let rightHoz = rightNode.getHorizontalDistance(node)
            print("Hoz for right \(rightNode.value) is \(rightHoz)")
            self.checkHoz(rightHoz,value: rightNode.value)
            queue.append(rightNode)
        }
    }
    
    func checkHoz(_ hoz: Int, value: Int) {
        //Check
        if setOfHorizontalDistance.contains(hoz) {
            return //Skip this node
        } else {
            setOfHorizontalDistance.insert(hoz)
            topViewOutput.append(value)
        }
    }
}


func testNewTree() {
    let newTree = BTree.init(1)
    newTree.rootNode.left = bTreeNode.init(2)
    newTree.rootNode.right = bTreeNode.init(3)
    newTree.rootNode.left?.right = bTreeNode.init(4)
    newTree.rootNode.left?.right?.right = bTreeNode.init(5)
    newTree.rootNode.left?.right?.right?.right = bTreeNode.init(6)
    
    print(newTree.getTopView())
}



