//
//  ViewController.swift
//  sk3tch
//
//  Created by Giovanna Diaz on 11/5/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//
// POtentially useful: http://tinyurl.com/k7j4ocg

import UIKit
import CoreMotion
import SceneKit


class ViewController: UIViewController, UIGestureRecognizerDelegate {
    var motionManager : CMMotionManager! = CMMotionManager()
    
    // custom view
    let scene = PrimitiveScene()
    let scnView = SCNView()
    let uiView = UIView()
    
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
    
    //refresh button
    @IBOutlet weak var refreshButton: UIButton!
    
    // Gesture Recongnizer
    var isTapped = false
    var hasCollectedData = false
    @IBOutlet var doubleTap: UITapGestureRecognizer! = UITapGestureRecognizer()
    
    // Dictionary for all the incomming values - Key: Timestamp / Value: [AccelX, AccelY, AccelZ]
    var data: [Double: Array<Double>] = [:]
    
    /*
    * viewDidLoad()
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide the refresh button at start
        self.refreshButton.hidden = true
        
        // Double tap to start & stop the timer
        self.doubleTap.numberOfTapsRequired = 2
        self.doubleTap.delegate = self
        
        // Add the position nodes
        self.shape.points.append(startPositionNode)
        
    }
    
    @IBAction func onTap(recognizer:UITapGestureRecognizer) {
        //let scnView = self.view as SCNView
        
        if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended && !isTapped {
            
            if (!hasCollectedData){
                self.isTapped = true
                self.view.backgroundColor = UIColor(red: CGFloat(180.0/255), green: CGFloat(232.0/255), blue: CGFloat(67.0/255), alpha: CGFloat(1))
                
                self.motionManager.deviceMotionUpdateInterval = 0.01
                
                self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
                    (data, error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        
                        self.data[data.timestamp] = [data.userAcceleration.x, data.userAcceleration.y, data.userAcceleration.x]
                        
                    } // callback
                } // startDeviceMotion
            }
        } else if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended && isTapped{
            
            self.view.backgroundColor = UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(225/255), alpha: CGFloat(1))
            
            //Stop the updates from the acceleromter
            self.motionManager.stopDeviceMotionUpdates()
            
            //unhide the refresh button
            self.refreshButton.hidden = false
            
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
            //let scnView = self.view as SCNView
            //let scene = PrimitiveScene()
            scene.addPoints(shape.points)
            scnView.scene = scene
            scnView.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height);
            
            //println("subviews1: ", self.view.subviews)
            
            
            // camera & light settings
            scnView.backgroundColor = UIColor.blackColor()
            scnView.autoenablesDefaultLighting = true
            scnView.allowsCameraControl = true
            
            self.view.addSubview(scnView)
            
            //println("subviews2: ", self.view.subviews)
            
            let buttonView: AnyObject = self.view.subviews[0] // so the refresh button isn't behind the custom view
            self.view.bringSubviewToFront(buttonView as UIView)
            self.view.setNeedsDisplay()
            
            
            // Test decoding the "Shape"
            /* if let theStroke = Stroke.readFromFile() {
            /*firstName.text = person.firstName
            lastName.text = person.lastName*/
            }*/
        }
    }
    
    // Refresh Button Functionality
    @IBAction func refreshPressedToResetScene(sender: AnyObject) {
        //hide the refresh button
        refreshButton.hidden = true
        
        //Removes all data (deletes underlying storage buffer) and add starting values
        data.removeAll()
        data[0.00] = [0.00, 0.00, 0.00]
        
        // Reset the view - get rid of scenekit
        //let scnView = self.view as UIView
        scene.removePoints()
        //self.view = UIView()
        //self.view.backgroundColor = UIColor.whiteColor()
        scnView.removeFromSuperview()
        self.view.backgroundColor = UIColor.whiteColor()
        
        //println("after removing subview", self.view.subviews)
        
        // Reset the necessary booleans
        hasCollectedData = false
        isTapped = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}