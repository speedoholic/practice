//
//  Protocols.swift
//  Samples
//
//  Created by Kushal Ashok on 7/25/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation


protocol Drawable {
    
}

extension Drawable {
    func draw() {
        print("default implementation")
    }
}

struct Point: Drawable {
    func draw() {
        print("Point")
    }
}

struct Line: Drawable {
    func draw() {
        print("Line")
    }
}

func testDrawableProtocol() {
    let arrayOfDrawables: [Drawable] = [Point(),Line()]
    _ = arrayOfDrawables.map {$0.draw()}
}
