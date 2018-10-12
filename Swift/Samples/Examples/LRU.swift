import Foundation


/*
 
 Storyboard - > Constraints - Autolayout
 
 viewA.height = viewB.height.multiplier(0.5)
 equalTo
 Ratio
 
 Conflicting constraints -> Red
 Warning constraints -> Yellow
 Keep adding constraints -> Blue
 
 View Debugger -> Controller -> View -> CustomView
 
 Visual output -> renders -> size classes (different devices)
 Coding -> error handling -> SuperView -> Follow my coded constraints
 Custom Navigation Bar -> BaseController
 Avoid storyboard conflicts -> XML
 Reusable Componenets -> .xib -> Class
 
 Mix match -> code and storyboard -> run time errors
 
 Crash logs -> Testflight / Hockeyapp -.> Pugongying
 .IPA, .dSym (memory addreses -> variables)
 
 //run loop
 
 Runloop
 
 Swift -> Objective -C "Dynamic" Dispatch -> static or ""
 -> Figure out at compile time -> which definition of function to be used
 
 
 
 viewDidDisappear
 viewDidLoad
 viewDidAppear
 viewWillAppear
 init
 loadView
 viewWillDisappear
 
 
 
 Feedback:
 1) your coding style, you introduced unneccesary global variables, you need encapusulate them in the function instead.
 2) One problem should be a Bread-First-Search, but you used Depth-First-Search
 
 */




/**
 Design and implement a data structure for Least Recently Used (LRU) cache. It should support the following operations: get and set.
 
 get(key) - Get the value (will always be positive) of the key if the key exists in the cache, otherwise return -1.
 set(key, value) - Set or insert the value if the key is not already present. When the cache reached its capacity, it should invalidate the least recently used item before inserting a new item.
 **/

/**class LRUCache {
 
 public LRUCache(int capacity) {
 }
 
 public int get(int key) {
 return -1;
 }
 
 public void set(int key, int value) {
 }
 };**/


class LRUItem {
    var key = 0
    var value = 0
    
    init(_ key: Int, value: Int) {
        self.key = key
        self.value = value
    }
    
    func itemDetails() -> String {
        return "Item key: \(key), value: \(value)"
    }
}

class LRUCache {
    
    var capacity = 0
    var itemsArray = [LRUItem]()
    
    init(_ capacity: Int) {
        self.capacity = capacity
        print("Cache has a cappacity of \(capacity) now")
    }
    
    func get(_ key: Int) -> Int {
        //Return value if key exists
        if let itemFound = getItem(key) {
            return itemFound.value
        }
        //Else return -1
        print("item with key: \(key) not found")
        return -1
    }
    
    func getItem(_ key: Int) -> LRUItem? {
        for (index,item) in itemsArray.enumerated() {
            if item.key == key {
                itemsArray.remove(at: index)
                itemsArray.insert(item, at: 0)
                print("Item with key: \(item.key) has been used with value: \(item.value)")
                return item
            }
        }
        return nil
    }
    
    func set(_ key: Int, value: Int) {
        //Check if key already present
        if let item = getItem(key) {
            print("existing key found for \(item.itemDetails())")
            item.value = value
        }
            //If not present, check capacity
        else {
            //If capacity is full, remove the LRU item
            if itemsArray.count == capacity, let lastItem = itemsArray.last {
                print("Removed the last \(lastItem.itemDetails())")
                itemsArray.removeLast()
            }
            //set the value for given key
            let newItem = LRUItem.init(key, value: value)
            itemsArray.append(newItem)
            print("Added new \(newItem.itemDetails())")
        }
    }
    
}

func test() {
    let cache = LRUCache.init(10)
    for i in 0...11 {
        if i % 2 == 0 {
            let _ = cache.get(i-1)
        }
        cache.set(i, value: i)
    }
}
