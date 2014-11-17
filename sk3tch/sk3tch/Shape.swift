//
//  Shape.swift
//  sk3tch
//
//  Created by Jessica Mann on 11/10/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//
import SceneKit
import Foundation

/*class Shape : NSObject, NSCoding {
    var strokes = [Stroke]()
    
    required init(coder aDecoder: NSCoder) {
    }

    func encodeWithCoder(aCoder: NSCoder) {
    }
}*/

class Stroke : NSObject, NSCoding  {
    var points = [SCNNode]()
    // Reference: http://stackoverflow.com/questions/25311098/archive-array-of-optional-structs-with-nscoding-in-swift
    
    required init(coder aDecoder: NSCoder) {
        self.points = aDecoder.decodeObjectForKey("pointArray") as [SCNNode]
        //self.points = aDecoder.decodeArrayOfObjCType(SCNNode, count: points.count, at: 0)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        //aCoder.encodeObject(runSamples.bridgeToObjectiveC(), forKey: "runSamples")
        //aCoder.encodeArrayOfObjCType(SCNNode, count: points.count, at: 0)
        aCoder.encodeObject(points, forKey: "pointArray")
    }

    func saveToFile() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        // save the archived data to a file
        // the data could also be put in userdefaults or a plist (which ever is appropriated)
        let documentsDirectory : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let filePath = documentsDirectory.stringByAppendingPathComponent("stroke.txt")
        data.writeToFile(filePath, atomically: true)
    }

    class func readFromFile() -> Stroke? {
        let documentsDirectory : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let filePath = documentsDirectory.stringByAppendingPathComponent("stroke.txt")
        if let data = NSData(contentsOfFile: filePath) {
            return (NSKeyedUnarchiver.unarchiveObjectWithData(data) as Stroke)
        }
        return nil
    }

}
/*
class Point : NSObject, NSCoding {
    var x : Float
    var y : Float
    var z : Float
    
    init(x: Float, y:Float, z:Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    required init(coder aDecoder: NSCoder) {
        self.x = aDecoder.decodeFloatForKey("x")
        self.y = aDecoder.decodeFloatForKey("y")
        self.z = aDecoder.decodeFloatForKey("z")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeFloat(x, forKey: "x")
        aCoder.encodeFloat(x, forKey: "y")
        aCoder.encodeFloat(x, forKey: "z")
    }
}*/