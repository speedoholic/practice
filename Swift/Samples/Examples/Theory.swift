//
////
////  File.swift
////
////
////  Created by Kushal Ashok on 7/25/18.
////
//
//import Foundation
//
//// MARK: - ByteDance
//
//
//
////kvo vs notifications
////https://medium.com/@piyush.dez/kvo-or-notificationcenter-9536f7a14989
//
////gcd vs nsoperationqueue
//let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//    // Process Response
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            // Update User Interface
//        })
//})
//
////Is array in swift a struct? What is difference between struct and class?
////In Swift structs and classes give you both value and reference-based constructs for your objects. Structs are preferred for objects designed for data storage like Array. Structs also help remove memory issues when passing objects in a multithreaded environment. Classes, unlike structs, support inheritance and are used more for containing logic like UIViewController. Most standard library data objects in Swift, like String, Array, Dictionary, Int, Float, Boolean, are all structs, therefore value objects. The mutability of var versus let is why in Swift there are no mutable and non-mutable versions of collections like Objective C’s NSArray and NSMutableArray.
//
////Is nsmutablearray thread safe?
////In general, immutable classes like NSArray are thread-safe, while their mutable variants like NSMutableArray are not. In fact, it's fine to use them from different threads, as long as access is serialized within a queue
//
////How to ensure thread safety?
//
////How does atomic keyword work?
////The atomic version has to take a lock(Lock is achieved by using *@synchronized* keyword) in order to guarantee thread safety, and also is bumping the ref count on the object (and the autorelease count to balance it) so that the object is guaranteed to exist for the caller, otherwise there is a potential race condition if another thread is setting the value, causing the ref count to drop to 0.
//
////How does arc work?
//
////What is SSL certiciate, how does it work?
//
////How to make sql query faster?
//
////What is the role of index in database?
//
////Q: What will be printed in following Obj-c Code
////- (void)foo {
////
////    __weak NSArray *array;
////
////    for (int i = 0; i < 1; i++) {
////
////        array = [NSArray arrayWithObjects:@YES, nil];
////
////    }
////    NSLog(@"%@", array);
////}
////Answer: 1 will be printed in console
////@YES is a short form of [NSNumber numberWithBool:YES]
////
////&
////
////@NO is a short form of [NSNumber numberWithBool:NO]
////
////and if we write
////
////if(@NO)
////some statement;
////the above if statement will execute since the above statement will be
////
////if([NSNumber numberWithBool:NO] != nil)
////and it's not equal to nil so it will be true and thus will pass.
////
////Whereas YES and NO are simply BOOL's and they are defined as-
////
////#define YES             (BOOL)1
////
////#define NO              (BOOL)0
////YES & NO is same as true & false, 1 & 0 respectively and you can use 1 & 0 instead of YES & NO, but as far as readability is concerned YES & NO will(should) be definitely preferred.
//
//
//// MARK: - HULU
//
///*
// 
// import Foundation
// 
// for _ in 1...5 {
// print("Hello, World!")
// }
// 
// 
// /*
// 
// Storyboard - > Constraints - Autolayout
// 
// viewA.height = viewB.height.multiplier(0.5)
// equalTo
// Ratio
// 
// Conflicting constraints -> Red
// Warning constraints -> Yellow
// Keep adding constraints -> Blue
// 
// View Debugger -> Controller -> View -> CustomView
// 
// Visual output -> renders -> size classes (different devices)
// Coding -> error handling -> SuperView -> Follow my coded constraints
// Custom Navigation Bar -> BaseController
// Avoid storyboard conflicts -> XML
// Reusable Componenets -> .xib -> Class
// 
// Mix match -> code and storyboard -> run time errors
// 
// Crash logs -> Testflight / Hockeyapp -.> Pugongying
// .IPA, .dSym (memory addreses -> variables)
// 
// //run loop
// 
// Runloop
// 
// Swift -> Objective -C "Dynamic" Dispatch -> static or ""
// -> Figure out at compile time -> which definition of function to be used
// 
// 
// 
// pixels -> X
// 
// 
// Controller -> View -> size class 1
// 
// 
// 
// init
// loadView
// viewDidLoad
// viewWillAppear
// viewDidAppear
// viewWillDisappear
// viewDidDisappear
// 
// 
// let viewController = NewViewController()
// let view = viewController.view //viewDidLoad
// 
// */
// 
// /**
// Design and implement a data structure for Least Recently Used (LRU) cache. It should support the following operations: get and set.
// 
// get(key) - Get the value (will always be positive) of the key if the key exists in the cache, otherwise return -1.
// set(key, value) - Set or insert the value if the key is not already present. When the cache reached its capacity, it should invalidate the least recently used item before inserting a new item.
// **/
// 
// */
//
//
