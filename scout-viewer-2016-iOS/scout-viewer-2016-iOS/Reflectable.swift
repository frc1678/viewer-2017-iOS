//
//  Reflectable.swift
//  scout-viewer-2016-iOS
//
//  Created by Bryton Moeller on 11/25/16.
//  Copyright © 2016 Citrus Circuits. All rights reserved.
//

import Foundation
//The Dream, Never Forget
protocol Reflectable {
    func properties() -> [String]
}

extension Reflectable
{
    func properties() -> [String] {
        var s = [String]()
        let ch = Mirror(reflecting: self).children
        var i = 0
        for c in ch
        {
            i += 1
            //print(c.label)
            if let name = c.label {
                s.append(name)
            }
        }
        return s
    }
    func propertyForKey(_ path:String) -> AnyObject? {
        for c in Mirror(reflecting: self).children
        {
            if c.label == path {
                //print(c.label)
                // print(c.value)
                return c.value as? AnyObject
            }
        }
        return nil
    }
}
