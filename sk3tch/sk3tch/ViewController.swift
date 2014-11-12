//
//  ViewController.swift
//  sk3tch
//
//  Created by Giovanna Diaz on 11/5/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//
//
// TO DO:
// - Need to add in gesture recognizer for tapping on screen (signify starting and ending of drawing)
//

import UIKit
import CoreMotion
import SceneKit

class ViewController: UIViewController {

    var motionManager : CMMotionManager!
   
    // Timer
    var timer = NSTimer()

    // Instance of the start node, at coord(0,0,0)
    var startNode : SCNNode = SCNNode() // the node

    // For Smothing the data
    // sA_x = smoothedAccel_x  | Gx_Roll = smoothedGryo_x
    var smoothing :Float = 0.99
    var sA_x :Float = 0
    var sA_y :Float = 0
    var sA_z :Float = 0
    
    var G_x :Float = 0
    var G_y :Float = 0
    var G_z :Float = 0
    
    // Variables used for getting accelerometer data
    var frameRate : Float  = 30.0
    
    func setup() {
        startNode.position = SCNVector3(x: 0, y: 0, z: 0)
    }
    
    /*
    * viewDidLoad()
    * - Takes in the accelerometer information and sends it to instance of NodeInSpace where
    *   it is processed and stored on the phone
    * - Commented Out: Takes in the gyroscope data as well
    *
    *
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // Taking in Device Data
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
            (data, error) in
            dispatch_async(dispatch_get_main_queue()) {

                self.sA_x = self.smoothing * self.sA_x + (1.0-self.smoothing) * Float(data.userAcceleration.x)
                self.sA_y = self.smoothing * self.sA_y + (1.0-self.smoothing) * Float(data.userAcceleration.y)
                self.sA_z = self.smoothing * self.sA_z + (1.0-self.smoothing) * Float(data.userAcceleration.y)
                
                // get the next node
                var nextNode : SCNNode = NodeInSpace.calculate(frameRate: frameRate, prevNode: startNode, time: 0.5, accelerationX: sA_x, accelerationY: sA_y, accelerationZ: sA_z)
                
//                self.G_x = Float(data.rotationRate.x)
//                self.G_y = Float(data.rotationRate.x)
//                self.G_z = Float(data.rotationRate.x)
                
                // set the next node (which is the newest node) to be the startNode
                self.startNode = nextNode
            
            }
        }
        
    } // VDL

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

