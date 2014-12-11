//
//  ViewController.swift
//  sk3tch
//
//  Created by Giovanna Diaz on 11/5/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.

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
    
    // Gesture Recongnizer
    var isTapped = false
    var hasCollectedData = false
    @IBOutlet var doubleTap: UITapGestureRecognizer! = UITapGestureRecognizer()
    
    // Dictionary for all the incomming values - Key: Timestamp / Value: [AccelX, AccelY, AccelZ]
    var data: [Double: Array<Float>] = [0.00: [0.00, 0.00, 0.00] ]
    
    /*
    * viewDidLoad()
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Double tap to start & stop the timer
        self.doubleTap.numberOfTapsRequired = 2
        self.doubleTap.delegate = self
        
        // Add the position nodes
        self.shape.points.append(startPositionNode)

    }
    
    @IBAction func onTap(recognizer:UITapGestureRecognizer) {
        if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended && !isTapped {
            
            if (!hasCollectedData){
                self.isTapped = true
                self.view.backgroundColor = UIColor(red: CGFloat(180.0/255), green: CGFloat(232.0/255), blue: CGFloat(67.0/255), alpha: CGFloat(1))
                
                self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        // Get the Overall time
                        var timeStamp = data.timestamp

                        // Get in and Smooth the Accel
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

                        // Add all the data to data dictionary
                        self.data[timeStamp] = [self.sA_x, self.sA_y, self.sA_z]
                        
                    } // callback
                } // startDeviceMotion

            }
        } else if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended && isTapped{
            //Stop the updates from the acceleromter
            self.motionManager.stopDeviceMotionUpdates()
            
            // Reset hasCollectedData so you don't start a new session & Change Boolean for tap
            self.hasCollectedData = true
            self.isTapped = false
            
            // Sort Dictionary by Key (timestamp) : eliminates negative time stamp issue
            let sortedDataKeys = Array(self.data.keys).sorted(<)
            
            // CREATE THE POSITION
            // Loop through Dictionary via sortedDataKeys and send values off 
            // --> Returns next position node to append to the shape
            for time in sortedDataKeys {
                if let accelerationArray = data[time] {
                    
                    /* UPDATE THE POSITION Passing in: prevAccel, Elapsed Time */
                    var nextNode : SCNNode
                    nextNode = self.nodeCalc.calculatePosition(self.startPositionNode,
                        currentAccel:accelerationArray, totalTime: time)
                    
                    //add the nextNode the SCNNode Array
                    self.shape.points.append(nextNode)
                    
                    // set the next node (which is the newest node) to be the startPositionNode
                    self.startPositionNode = nextNode

                }
            }
            
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
