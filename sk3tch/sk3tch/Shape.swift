//
//  Shape.swift
//  sk3tch
//
//  Created by Jessica Mann on 11/10/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//

import Foundation

class Shape : NSObject, NSCoding {
    var strokes = [Stroke]()
    
    required init(coder aDecoder: NSCoder) {
    }

    func encodeWithCoder(aCoder: NSCoder) {
    }
    
    
    
}

class Stroke : NSObject, NSCoding  {
    var points = [Point]()
    
    required init(coder aDecoder: NSCoder) {
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
            //aCoder.encodeArrayOfObjCType(Point, count: points.count, at: 0)
    }
    
    
}

class Point : NSObject, NSCoding {
    var x : Float
    var y : Float
    init(x: Float, y:Float) {
        self.x = x
        self.y = y
    }
    
    required init(coder aDecoder: NSCoder) {
        self.x = aDecoder.decodeFloatForKey("x")
        self.y = aDecoder.decodeFloatForKey("y")
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeFloat(x, forKey: "x")
        aCoder.encodeFloat(x, forKey: "y")
    }

    
}