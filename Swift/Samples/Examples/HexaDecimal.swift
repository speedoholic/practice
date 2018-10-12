//
//  Hexadecimal.swift
//  Samples
//
//  Created by Kushal Ashok on 7/17/18.
//  Copyright © 2018 speed. All rights reserved.
//

import Foundation

enum HexaDecimal: Int {
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
}

func getHex(_ integer: Int) -> String? {
    guard integer < 16 else {return nil}
    if (integer < 10 && integer >= 0) {
        return String(describing: integer)
    } else {
        let bigInteger = integer - 10
        if let hexValue = HexaDecimal(rawValue:bigInteger) {
            switch hexValue {
            case .A:
                return "A"
            case .B:
                return "B"
            case .C:
                return "C"
            case .D:
                return "D"
            case .E:
                return "E"
            case .F:
                return "F"
            }
        }
    }
    return nil
}

func getHexValue(_ number: Int) -> String {
    var hexString = ""
    var num = number
    while num > 0 {
        let remainder = num % 16
        if let newHex = getHex(remainder) {
            hexString = newHex + hexString
        }
        num = num / 16
    }
    return hexString
}


func testHexValue() {
    let hexValue = getHexValue(31)
    print(hexValue)
}
