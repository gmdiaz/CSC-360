//  NodeCalculator.swift
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
    
    // Starting arrays
    var startVelocityArray: [Double] = [0.00, 0.00, 0.00]
    var startAccelArray: [Double] = [0.00, 0.00, 0.00]
    
    // Timer
    var oldTime = -1.0
    var smoothing = 0.99
    init() {
    }
    
    func calculatePosition(prevPosition: SCNNode,
        currentAccel: Array <Double>,
        totalTime: NSTimeInterval) -> SCNNode {
            var curVelocity: [Double] = [0.00, 0.00, 0.00]
            var curPosition: [Double] = [0.00, 0.00, 0.00]
            
            // Timer Stuff
            var elapsedTime = 0.0
            
            if self.oldTime > 0 {
                elapsedTime = totalTime - self.oldTime
            }
            self.oldTime = totalTime
            
            /*****************************************/
            /* We would use this chunk of code if the values that
                came in from the Accelerometer were GREAT */
            /*****************************************/
            
            // Iterate through x y and z values
            /*for i in 0...2 {
            //Smooth & Minimize Values around 0
            self.startAccelArray[i] = self.smoothing * self.startAccelArray[i] + (1.0-self.smoothing) * (currentAccel[i])
            
            if (self.startAccelArray[i] < 0.0002 && self.startAccelArray[i] > -0.0002) {
            self.startAccelArray[i] = 0.00
            }
            
            curVelocity[i] = self.startAccelArray[i] * (elapsedTime) + self.startVelocityArray[i]
            }*/
            
            /*****************************************/
            /* We would use this chunk of code if the values that
                came in from the Accelerometer were not LITERALLY HORRIBLE */
            /*****************************************/
            /*
            for i in 0...2 {
                //Smooth & Minimize Values around 0
                self.startAccelArray[i] = self.smoothing * self.startAccelArray[i] + (1.0-self.smoothing) * (currentAccel[i])
                testSmoothed[i] = self.startAccelArray[i]
            }
            
            // Limiting the Data to just 1 Dimension
            if ( abs(self.startAccelArray[0]) > abs(self.startAccelArray[1]) && abs(self.startAccelArray[0]) > abs(self.startAccelArray[2]) ) {
                self.startAccelArray[1] = 0.00
                self.startAccelArray[2] = 0.00
            }
            
            if ( abs(self.startAccelArray[1]) > abs(self.startAccelArray[0]) && abs(self.startAccelArray[1]) > abs(self.startAccelArray[2]) ) {
                self.startAccelArray[0] = 0.00
                self.startAccelArray[2] = 0.00
            }
            
            if ( abs(self.startAccelArray[2]) > abs(self.startAccelArray[1]) && abs(self.startAccelArray[2]) > abs(self.startAccelArray[0]) ) {
                self.startAccelArray[0] = 0.00
                self.startAccelArray[1] = 0.00
            }
            
            for i in 0...2 {
                if ( self.startAccelArray[i] < 0 ) {
                    self.startAccelArray[i] = (-0.05)
                } else if (self.startAccelArray[i] > 0 ) {
                    self.startAccelArray[i] = 0.05
                }
                
                curVelocity[i] = self.startAccelArray[i] * (elapsedTime) + self.startVelocityArray[i]
            }*/
            
            /*****************************************/
            /* We are using this chunk of code beacuse it
                at least returns a fun shape, and not just a stick...
                sticks are no fun. */
            /*****************************************/
            for i in 0...2 {
                //Smooth & Minimize Values around 0
                self.startAccelArray[i] = self.smoothing * self.startAccelArray[i] + (1.0-self.smoothing) * (currentAccel[i])
                
                curVelocity[i] = self.startAccelArray[i] * (elapsedTime) + self.startVelocityArray[i]

            }
            
            // Find the current position
            curPosition[0] = (self.startVelocityArray[0] + curVelocity[0]) * 0.5 * (elapsedTime) + Double(prevPosition.position.x)
            curPosition[1] = (self.startVelocityArray[1] + curVelocity[1]) * 0.5 * (elapsedTime) + Double(prevPosition.position.y)
            curPosition[2] = (self.startVelocityArray[2] + curVelocity[2]) * 0.5 * (elapsedTime) + Double(prevPosition.position.z)
            
            // Smooth velocity values
            for j in 0...2 {
                if ((curVelocity[j] < 0.0002 && curVelocity[j] > -0.0002)) {
                    self.startVelocityArray[j] = 0.00
                } else {
                    self.startVelocityArray[j] = curVelocity[j]
                }
            }
            
            /*print("Velocity:  ")
            print(self.startVelocityArray)
            print("   Acceleration: ")*/
            print(self.startAccelArray)
            println()
            
            var node : SCNNode = SCNNode() // the node

            /* We are plotting Acceleration so that we get a fun squiggle */
            node.position = SCNVector3(x: Float(self.startAccelArray[0]), y: Float(self.startAccelArray[1]), z: Float(self.startAccelArray[2]))

            /* Use this chunk of code when Apple updates their accelerometer hardware in the year 2053 */
            /* node.position = SCNVector3(x: Float(curPosition[0]), y: Float(curPosition[1]), z: Float(curPosition[2]))*/
            
            // print out segment start & end location
            //println("start: " + prevPosition.position.stringValue + " end: " + node.position.stringValue)
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

