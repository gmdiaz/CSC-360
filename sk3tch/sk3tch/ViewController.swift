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


class ViewController: UIViewController, UIGestureRecognizerDelegate {
    var motionManager : CMMotionManager! = CMMotionManager()
    
    // Instance of the start node, at coord(0,0,0)
    
    var startNode : SCNNode! = SCNNode() // the node
    var nodeCalc : NodeCalculator! = NodeCalculator()
    
    // Create array of nodes to be saved
    var nodeArray : Stroke!
    
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
    
    // Timer
    var startTime = NSTimeInterval()
    var elapsedTime = NSTimeInterval()
    var timer : NSTimer = NSTimer()
    
    // Gesture Recongnizer
    var isTapped : Boolean = false
    @IBOutlet var singleTap: UITapGestureRecognizer! = UITapGestureRecognizer()
    @IBOutlet var doubleTap: UITapGestureRecognizer! = UITapGestureRecognizer()
    
      /*
    * viewDidLoad()
    * - Takes in the accelerometer information and sends it to instance of NodeInSpace where
    *   it is processed and stored on the phone
    * - Commented Out: Takes in the gyroscope data as well
    */
    override func viewDidLoad(){
        super.viewDidLoad()
        
//        // Single tap to start the timer
        self.singleTap.delegate = self
        self.singleTap.numberOfTapsRequired = 1
//
//        // Double tap to stop the timer
        self.doubleTap.numberOfTapsRequired = 2
        self.doubleTap.delegate = self
        
    } // VDL
    
    @IBAction func onTap(recognizer:UITapGestureRecognizer) {
        if recognizer.numberOfTapsRequired==1 && recognizer.state == .Ended {
            if !isTapped && !timer.valid {
                self.isTapped = true
                let aSelector : Selector = "updateTime"
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                startTime = NSDate.timeIntervalSinceReferenceDate()
                
                // Taking in Device Data
                self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.sA_x = self.smoothing * self.sA_x + (1.0-self.smoothing) * Float(data.userAcceleration.x)
                        self.sA_y = self.smoothing * self.sA_y + (1.0-self.smoothing) * Float(data.userAcceleration.y)
                        self.sA_z = self.smoothing * self.sA_z + (1.0-self.smoothing) * Float(data.userAcceleration.y)
                        
                        var nextNode : SCNNode
                        
                        nextNode = self.nodeCalc.calculate(self.frameRate, prevNode: self.startNode, elapsedTime: self.elapsedTime, accelerationX: self.sA_x, accelerationY: self.sA_y, accelerationZ: self.sA_z)
                        
                        //              self.G_x = Float(data.rotationRate.x)
                        //              self.G_y = Float(data.rotationRate.x)
                        //              self.G_z = Float(data.rotationRate.x)
                        
                        // set the next node (which is the newest node) to be the startNode
                        self.startNode = nextNode
                        
                    }
                }

            }
        } else if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended {
            timer.invalidate()
            self.isTapped = false
        }
    }
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        elapsedTime =  currentTime - startTime
        
        //calculate the minutes in elapsed time.
        //let minutes = UInt8(elapsedTime / 60.0)
        //elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        //let fraction = UInt8(elapsedTime * 100)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
