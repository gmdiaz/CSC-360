//
//  Shape.swift
//  sk3tch
//
//  Created by Jessica Mann on 11/10/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//
import SceneKit
import Foundation

class Stroke : NSObject, NSCoding  {
    // Reference: http://stackoverflow.com/questions/25311098/archive-array-of-optional-structs-with-nscoding-in-swift

    var points = [SCNNode]()
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.points = aDecoder.decodeObjectForKey("pointArray") as [SCNNode]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
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

    func clearPoints() {
        self.points = [SCNNode]()
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
