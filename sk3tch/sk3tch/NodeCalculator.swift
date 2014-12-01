//  NodeInSpace.swift
//  sk3tch
//
//  Created by Jessica Mann on 11/10/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//
//  This class calculates the position of the node in space given acceleration, time, and gyroscope information.
//  The nodes locations are stored elseswhere (make sure it is stored in order, as that will be how we know which ones make a segment!)


import Foundation
import SceneKit

class NodeCalculator  {
    init() {
        
    }
    
    // still need to add in gyroscope information
    // prevNode = previous point
    // time = total time elapsed
    func calculate(frameRate: Float, prevNode: SCNNode, elapsedTime: NSTimeInterval, accelerationX: Float, accelerationY: Float, accelerationZ: Float) -> SCNNode {
        
        //println(accelerationX.stringValue + "," + accelerationY.stringValue + "," + accelerationZ.stringValue)
        
        
        // assuming the user will not be moving very fast when constant velocity
        var defaultVelocity : Float = 0.06
        
        // change in each directions
        var destX : Float
        var destY : Float
        var destZ : Float
        
        // depending on if there is acceleration or if velocity is constant
        var dx = 0.5 * accelerationX * Float(elapsedTime) * Float(elapsedTime)
        destX = dx + prevNode.position.x
        //destX = (accelerationX * frameRate + prevNode.position.x)
        
        var dy = 0.5 * accelerationY * Float(elapsedTime) * Float(elapsedTime)
        destY = dy + prevNode.position.y
        //destY = (accelerationY * frameRate + prevNode.position.y)
            
        var dz = 0.5 * accelerationZ * Float(elapsedTime) * Float(elapsedTime)
        destZ = dz + prevNode.position.z
        //destZ = (accelerationZ * frameRate + prevNode.position.z)
       
        
        var node : SCNNode = SCNNode() // the node
        node.position = SCNVector3(x: destX, y: destY, z: destZ)
        
        // print out segment start & end location
        println("start: " + prevNode.position.stringValue + " end: " + node.position.stringValue)
        //println("time is: " + Float(time).stringValue)
        
        return node
    }
    
}

extension Float {
    var stringValue : String {
        return NSString(format: "%.2f", self)
    }
}


// Extending SCNVector3 to print as string
extension SCNVector3 {
    var stringValue: String {
        var result : String = ""
        result += "("
        result += NSString(format: "%.2f", self.x)
        result += ", "
        result += NSString(format: "%.2f", self.y)
        result += ", "
        result += NSString(format: "%.2f", self.z)
        result += ")"
        return result
    }
}


