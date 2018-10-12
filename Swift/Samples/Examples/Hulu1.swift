//// [1,3,5,7]
//// 3, 1
//// 2, 1
//// 8, 4
//// 0, 0
//// [2,A,3,3,3,3,3,3]
//// target = 3 result = 0
//
//var inserPosition:Int?
//var sortedArray = [1,2,3,3,3,3,5,5,5,5]
//
////Binary -> divide into 2 parts
//func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
//    var lowerBound = 0
//    var upperBound = a.count
//    while lowerBound < upperBound {
//        let midIndex = lowerBound + (upperBound - lowerBound) / 2
//        //On the right
//        if a[midIndex] < key {
//            if midIndex == (a.count - 1) {
//                return midIndex + 1
//            }
//            lowerBound = midIndex
//        }
//        //On left
//        else if a[midIndex] > key {
//            if mideIndex == 0 {
//                return 0
//            }
//            upperBound = midIndex
//        }
//        //Equal - Continue go left
//        else {
//            upperBound = midIndex
//        }
//    }
//    if lowerBound == upperBound {
//        return midIndex - 1
//    }
//    return nil
//}
//
//// LRU cache
//// Least recent use cache
//// [5, 1, 2, 3]
//// [3, 5, 1, 2]
//
//
////protocol -> LRU Cache Object to be used
//init(capacity)
//put(key, value)
//get(key) -> value
//
//
////Implementation
//
//var capacity = 0
//var count = 0 {
//    didSet {
//        //check and set isFull
//    }
//}
//var isFull = false
//
//func init(capacity) {
//    self.capacity = capacity
//}
//
////O(n)
//put(_ key:Int, value:String, objectAlreadyFound: Node?) {
//
//    var newRoot: Node?
//
//    if let objectFound = objectAlreadyFound {
//        newRoot = objectFound
//    }
//    else if let object = search( _ key:Int) { //O(n)
//        newRoot = object
//    } else {
//        if self.count == self.capacity {
//            //flush the last node
//        }
//        newRoot = Node(Int, Value)
//    }
//    self.insertroot(newRoot)  // func to insert this node at the root
//}
//
//
////O(n)
//get(_ key:Int) -> String? {
//    if let foundObject = self.find(key) { //O(n)
//        put(_ key:key, value:foundObject.Value, objectAlreadyFound: foundObject)
//        return foundObject.value
//    } else {
//        return nil
//    }
//}
//
//func search(_ key:Int) -> Node? {
//    return //searched node
//}
//
//
////Protocol -> LRU Cache
//func isCacheFull() {} //Remove the last item in the list
//func useObject(_ node: Node) {} // We need to move the object to the root of the list
//
//
//// key int, val string
//// Array -> O(1) -> Directly use index -> remove the object - >> index for all elements after that one will change
//Class Cache {
//
//}
//
//
//Class Node {
//    value: String
//    link: Node?
//
//    func replace(_ node: Node) {
//
//    }
//}
//
//
//
//
//
