//
//  NodeInSpace.swift
//  sk3tch
//
//  Created by Jessica Mann on 11/10/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//
//  This class calculates the position of the node in space given acceleration, time, and gyroscope information.
//  The nodes locations are stored elsewhere (make sure it is stored in order, as that will be how we know which ones make a segment!)


import Foundation
import SceneKit

class NodeInSpace  {
    
    var x : Float
    var y : Float
    var z : Float
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    
    // still need to add in gyroscope information
    // prevNode = previous point
    // time = total time elapsed
    func calculate(frameRate: Float, prevNode: SCNNode, time: Float, accelerationX: Float, accelerationY: Float, accelerationZ: Float) -> SCNNode {
        
        // assuming the user will not be moving very fast when constant velocity
        var defaultVelocity : Float = 0.06
        
        // change in each directions
        var destX : Float
        var destY : Float
        var destZ : Float
        
        // depending on if there is acceleration or if velocity is constant
        if accelerationX != 0 {
            destX = (accelerationX * frameRate + prevNode.position.x)
        } else {
            var dx = time * defaultVelocity
            destX = prevNode.position.x + dx
        }
        if accelerationY != 0 {
            destY = (accelerationY * frameRate + prevNode.position.y)
        } else {
            var dy = time * defaultVelocity
            destY = prevNode.position.y + dy
        }
        if accelerationZ != 0 {
            destZ = (accelerationZ * frameRate + prevNode.position.z)
        } else {
            var dz = time * defaultVelocity
            destZ = prevNode.position.z + dz

        }
        
        var node : SCNNode = SCNNode() // the node
        node.position = SCNVector3(x: destX, y: destY, z: destZ)
        
        // print out segment start & end location
        
        print("start: " + prevNode.position.stringValue + " end: " + node.position.stringValue)
        
        return node
    }
    
}

// Extending SCNVector3 to print as string
extension SCNVector3 {
    var stringValue: String {
        var result : String = ""
        result += NSString(format: "%.2f", self.x)
        result += NSString(format: "%.2f", self.y)
        result += NSString(format: "%.2f", self.z)
        return result
    }
}





