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

class ViewController: UIViewController {

    // Instance of NodeInSpace
    var theNode = NodeInSpace()
    
    // Timer
    var timer = NSTimer()

    // Variables used for getting accelerometer data
    var frameRate : Float  = 30.0
    var motionManager : CMMotionManager!
    
    // For Smothing the data
    // sA_x = smoothedAccel_x  | sGx_Roll = smoothedGryo_x
    var smoothing :Float = 0.99
    var sA_x :Float = 0
    var sA_y :Float = 0
    var sA_z :Float = 0
    
    var G_x :Float = 0
    var G_y :Float = 0
    var G_z :Float = 0
    
    
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
    
        // Taking in Device Data
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
            (data, error) in
            dispatch_async(dispatch_get_main_queue()) {

                self.sA_x = self.smoothing * self.sA_x + (1.0-self.smoothing) * Float(data.userAcceleration.x)
                self.sA_y = self.smoothing * self.sA_y + (1.0-self.smoothing) * Float(data.userAcceleration.y)
                self.sA_z = self.smoothing * self.sA_z + (1.0-self.smoothing) * Float(data.userAcceleration.y)
                
                prevNode = theNode(self.frameRate, prevNode, time, self.sA_x, self.sA_y, self.sA_z)
                
//                self.G_x = Float(data.rotationRate.x)
//                self.G_y = Float(data.rotationRate.x)
//                self.G_z = Float(data.rotationRate.x)
            
            }
        }
        
    } // VDL

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

