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
    var startPositionNode : SCNNode! = SCNNode() // the starting position node
    
    var nodeCalc : NodeCalculator! = NodeCalculator()
    
    // Instance of Shape for saving
    var shape = Stroke()
    
    // For Smothing the data : sA_x = smoothedAccel_x  | Gx_Roll = smoothedGryo_x
    var smoothing :Float = 0.99
    var sA_x :Float = 0
    var sA_y :Float = 0
    var sA_z :Float = 0
    
    // Variables used for getting accelerometer data
    var frameRate : Float  = 30.0
    
    // Timer
    var oldTime = -1.0
    
    // Gesture Recongnizer
    var isTapped = false
    var hasCollectedData = false
    @IBOutlet var doubleTap: UITapGestureRecognizer! = UITapGestureRecognizer()
    
    /*
    * viewDidLoad()
    * - Takes in the accelerometer information and sends it to instance of NodeInSpace where
    *   it is processed and stored on the phone
    * - Commented Out: Takes in the gyroscope data as well
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Double tap to start & stop the timer
        self.doubleTap.numberOfTapsRequired = 2
        self.doubleTap.delegate = self
        
        self.shape.points.append(startPositionNode)

    } // VDL
    
    @IBAction func onTap(recognizer:UITapGestureRecognizer) {
        if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended && !isTapped {
            
            if (!hasCollectedData){
                // The scren was tapped
                self.isTapped = true
                
                // change background color
                self.view.backgroundColor = UIColor(red: CGFloat(180.0/255), green: CGFloat(232.0/255), blue: CGFloat(67.0/255), alpha: CGFloat(1))
                
                
                // Taking in Device Data
                self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        // Timer Stuff
                        var elapsedTime = 0.0
                        if self.oldTime > 0 {
                            elapsedTime = data.timestamp - self.oldTime
                        }
                        self.oldTime = data.timestamp

                        // Get in the Accel
                        self.sA_x = self.smoothing * self.sA_x + (1.0-self.smoothing) * Float(data.userAcceleration.x)
                        self.sA_y = self.smoothing * self.sA_y + (1.0-self.smoothing) * Float(data.userAcceleration.y)
                        self.sA_z = self.smoothing * self.sA_z + (1.0-self.smoothing) * Float(data.userAcceleration.z)
                        
                       if (self.sA_x < 0.0002 && self.sA_x > -0.0002) {
                            self.sA_x = 0.00
                        }
                        
                        if (self.sA_y < 0.0002 && self.sA_y > -0.0002) {
                            self.sA_y = 0.00
                        }
                        
                        if (self.sA_z < 0.0002 && self.sA_z > -0.0002) {
                            self.sA_z = 0.00
                        }
                        /* Using Roll / Pitch / Yaw */
                        var G_x = Float(data.attitude.roll)
                        var G_y = Float(data.attitude.pitch)
                        var G_z = Float(data.attitude.yaw)
                        
                        /* Quaternion */
                        var RotationX = Float(data.attitude.quaternion.x)
                        var RotationY = Float(data.attitude.quaternion.y)
                        var RotationZ = Float(data.attitude.quaternion.z)
                        
                        /* UPDATE THE POSITION Passing in...
                        framerate / prevAccel */
                        var nextNode : SCNNode
                        nextNode = self.nodeCalc.calculatePosition(self.startPositionNode,                            currentAccel:[self.sA_x, self.sA_y, self.sA_z],
                            elapsedTime: elapsedTime)

                        
                        //add the nextNode the SCNNode Array
                        self.shape.points.append(nextNode)
                        
                        // set the next node (which is the newest node) to be the startPositionNode
                        self.startPositionNode = nextNode
                        
                    } // callback
                } // startDeviceMotion

            }
        } else if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended && isTapped{
            println("The screen was tapped twice - timer ended")
            // Reset hasCollectedData so you don't start a new session
            self.hasCollectedData = true
            
            //Stop the updates from the acceleromter to get out of callback(?)
            self.motionManager.stopDeviceMotionUpdates()
            
            // Change Boolean
            self.isTapped = false
            
            //Encode the SCNNOde "Shape"
            self.shape.saveToFile()
            
            // EVERYTHING TO DO WITH THE 3D RENDERING SCENE
            // set scene to be custom scene
            let scnView = self.view as SCNView
            let scene = PrimitiveScene()
            scene.addPoints(shape.points)
            scnView.scene = scene
            
            // camera & light settings
            scnView.backgroundColor = UIColor.blackColor()
            scnView.autoenablesDefaultLighting = true
            scnView.allowsCameraControl = true
            /***************************/
            
            
            // Test decoding the "Shape"
            /* if let theStroke = Stroke.readFromFile() {
                /*firstName.text = person.firstName
                lastName.text = person.lastName*/
            }*/
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
