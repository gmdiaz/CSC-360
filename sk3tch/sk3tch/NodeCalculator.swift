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

    var startVelocityArray: [Float] = [0.00, 0.00, 0.00]
    
    init() {
    }
    
    // Calculate the new position
    func calculatePosition(prevPosition: SCNNode,
        newAccel: Array <Float>,
        elapsedTime: NSTimeInterval) -> SCNNode {
        
            // Find the current velocity
            var curVelocityX = newAccel[0] * Float(elapsedTime) + self.startVelocityArray[0]
            var curVelocityY = newAccel[1] * Float(elapsedTime) + self.startVelocityArray[1]
            var curVelocityZ = newAccel[2] * Float(elapsedTime) + self.startVelocityArray[2]
            
            // Smooth our values even more
            if (curVelocityX < 0.0003 && curVelocityX > -0.0002) {
                self.startVelocityArray[0] = 0.00
            } else {
                self.startVelocityArray[0] = curVelocityX
            }
            
            if (curVelocityY < 0.0003 && curVelocityY > -0.0002) {
                self.startVelocityArray[1] = 0.00
            } else {
                self.startVelocityArray[1] = curVelocityY
            }
            
            if (curVelocityZ < 0.0003 && curVelocityZ > -0.0002) {
                self.startVelocityArray[2] = 0.00
            } else {
                self.startVelocityArray[2] = curVelocityZ
            }
    
            // Find the current position
            var curPositionX = ((curVelocityX) * 0.5) * Float(elapsedTime) + prevPosition.position.x
            var curPositionY = ((curVelocityY) * 0.5) * Float(elapsedTime) + prevPosition.position.y
            var curPositionZ = ((curVelocityZ) * 0.5) * Float(elapsedTime) + prevPosition.position.z
            
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


