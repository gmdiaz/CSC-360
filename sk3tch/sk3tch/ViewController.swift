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
    
//    // the frame
//    var origin : CGPoint = CGPoint() // the origin of the frame rectangle, (0,0)
//    var size : CGSize = CGSize(width: CGFloat(10), height: CGFloat(10)) // needs to redo the point size (width, height)
//    var frameRect : CGRect = CGRect(origin: origin, size: size) // the frame, should be the entire phone screen

    
    //
    // Test Text
    //
    
    // Instance of the start node, at coord(0,0,0)
    var startNode : SCNNode! = SCNNode() // the node
    var nodeCalc : NodeCalculator! = NodeCalculator()
    
    // Instance of Shape for saving
    var shape = Stroke()
    
    // For Smothing the data : sA_x = smoothedAccel_x  | Gx_Roll = smoothedGryo_x
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
    var isTapped = false
    @IBOutlet var singleTap: UITapGestureRecognizer! = UITapGestureRecognizer()
    @IBOutlet var doubleTap: UITapGestureRecognizer! = UITapGestureRecognizer()
    
    /*
    * viewDidLoad()
    * - Takes in the accelerometer information and sends it to instance of NodeInSpace where
    *   it is processed and stored on the phone
    * - Commented Out: Takes in the gyroscope data as well
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        
//        let scnView = self.view as SCNView
//        let scene = PrimitiveScene()
//        scnView.scene = scene
//        
//        scnView.backgroundColor = UIColor.blackColor()
//        scnView.autoenablesDefaultLighting = true
//        scnView.allowsCameraControl = true

        
        // Single tap to start the timer
        self.singleTap.delegate = self
        self.singleTap.numberOfTapsRequired = 1

        // Double tap to stop the timer
        self.doubleTap.numberOfTapsRequired = 2
        self.doubleTap.delegate = self
        
        self.shape.points.append(startNode)

    } // VDL
    
    @IBAction func onTap(recognizer:UITapGestureRecognizer) {
        if recognizer.numberOfTapsRequired==1 && recognizer.state == .Ended {
            if !isTapped && !timer.valid {
                // The scren was tapped
                self.isTapped = true
                
                // Timer
                let aSelector : Selector = "updateTime"
                timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
                startTime = NSDate.timeIntervalSinceReferenceDate()
                
                if timer.valid {
                    println("The screen was tapped once - timer started")
                } else {
                    println("shit happened")
                }
                
                // Taking in Device Data
                self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.sA_x = self.smoothing * self.sA_x + (1.0-self.smoothing) * Float(data.userAcceleration.x)
                        self.sA_y = self.smoothing * self.sA_y + (1.0-self.smoothing) * Float(data.userAcceleration.y)
                        self.sA_z = self.smoothing * self.sA_z + (1.0-self.smoothing) * Float(data.userAcceleration.z)
                        
                        
                        var nextNode : SCNNode
                        
                        nextNode = self.nodeCalc.calculate(self.frameRate, prevNode: self.startNode, elapsedTime: self.elapsedTime, accelerationX: self.sA_x, accelerationY: self.sA_y, accelerationZ: self.sA_z)
                        
                        //              self.G_x = Float(data.rotationRate.x)
                        //              self.G_y = Float(data.rotationRate.x)
                        //              self.G_z = Float(data.rotationRate.x)
                        
                        //add the nextNode the SCNNode Array
                        self.shape.points.append(nextNode)
                        
                        // set the next node (which is the newest node) to be the startNode
                        self.startNode = nextNode
                        
                    } // callback
                } // startDeviceMotion

            }
        } else if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended {
            println("The screen was tapped twice - timer ended")
            //Stop the updates from the acceleromtere to get out of callback(?)
            self.motionManager.stopDeviceMotionUpdates()

            // Stop the timer
            timer.invalidate()
            
            // Change Boolean
            self.isTapped = false
            
            //Encode the SCNNOde "Shape"
            self.shape.saveToFile()
            
            
            // set scene to be custom scene
            let scnView = self.view as SCNView
            let scene = PrimitiveScene()
            scene.addPoints(shape.points)
            scnView.scene = scene
            
            scnView.backgroundColor = UIColor.blackColor()
            scnView.autoenablesDefaultLighting = true
            scnView.allowsCameraControl = true

            
            
/*
            // Test decoding the "Shape"
            if let theStroke = Stroke.readFromFile() {
                /*firstName.text = person.firstName
                lastName.text = person.lastName*/
            }*/
        }
    }
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        self.elapsedTime =  currentTime - startTime
        
        //calculate the minutes in elapsed time.
        //let minutes = UInt8(elapsedTime / 60.0)
        //elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        self.elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        //let fraction = UInt8(elapsedTime * 100)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
