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
    
    /* Updates Velocity Array */
    func updateVelocity(prevVelocity: Array <Float>, newAccel: Array <Float>, elapsedTime: NSTimeInterval) -> Array<Float> {
        // V1 = A0 * changeTime + V0
        var curVelocityX = newAccel[0] * Float(elapsedTime) + prevVelocity[0]
        var curVelocityY = newAccel[1] * Float(elapsedTime) + prevVelocity[1]
        var curVelocityZ = newAccel[2] * Float(elapsedTime) + prevVelocity[2]

        var newVelocity: [Float] = [curVelocityX, curVelocityY, curVelocityZ]
        
        return newVelocity
    }
    
    // Calculate the new position
    func calculatePosition(prevPosition: SCNNode, prevVelocity: Array<Float>,
        newVelocity: Array <Float>, elapsedTime: NSTimeInterval) -> SCNNode {
        
            var curPositionX = ((prevVelocity[0] + newVelocity[0]) * 0.5) * Float(elapsedTime) + prevPosition.position.x
            var curPositionY = ((prevVelocity[1] + newVelocity[1]) * 0.5) * Float(elapsedTime) + prevPosition.position.y
            var curPositionZ = ((prevVelocity[2] + newVelocity[2]) * 0.5) * Float(elapsedTime) + prevPosition.position.z
            
        // assuming the user will not be moving very fast when constant velocity
//        var defaultVelocity : Float = 0.06
        
        // P1 = V0 * changeTime + P0
     /*
        var curPositionX = 0.50 * (prevVelocity[0] * Float(elapsedTime) + prevPosition.position.x)
        var curPositionY = 0.50 * (prevVelocity[1] * Float(elapsedTime) + prevPosition.position.y)
        var curPositionZ = 0.50 * (prevVelocity[2] * Float(elapsedTime) + prevPosition.position.z)
*/
        var node : SCNNode = SCNNode() // the node
        node.position = SCNVector3(x: curPositionX, y: curPositionY, z: curPositionZ)

        
        // print out segment start & end location
        println("start: " + prevPosition.position.stringValue + " end: " + node.position.stringValue)
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


