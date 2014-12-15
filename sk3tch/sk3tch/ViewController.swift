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
    
    // custom subview
    var customScene = PrimitiveScene()    // the custom scene for the subview
    var scnView = SCNView()        // the subview to render the scene in
    
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
        
        // set the frame size of the subview that will hold the custom scene
        self.scnView.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height);
        
        // Add the position nodes
        self.shape.points.append(startPositionNode)
    }
    
    @IBAction func onTap(recognizer:UITapGestureRecognizer) {
        
        if recognizer.numberOfTapsRequired==2 && recognizer.state == .Ended && !isTapped {
            
            if (!hasCollectedData){
                //println("After clearing, expect 1 point in array: ",self.shape.points.count)
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
            println("How many points we got in shape: ",shape.points.count)
            
            //Encode the SCNNOde "Shape"
            self.shape.saveToFile()
            
            // EVERYTHING TO DO WITH THE 3D RENDERING SCENE
            // add points to the scene to draw
            customScene.addPoints(shape.points)
            println("How many points we got in scene: ",customScene.points.count)
            scnView.scene = customScene
            
            // camera & light settings for custom scene
            scnView.backgroundColor = UIColor.blackColor()
            scnView.autoenablesDefaultLighting = true
            scnView.allowsCameraControl = true
            
            // add custom scene as subview to view
            self.view.addSubview(scnView)
            
            let buttonView: UIView = self.view.subviews[0] as UIView // so the refresh button isn't behind the custom view
            self.view.bringSubviewToFront(buttonView)
            self.view.setNeedsDisplay()
            
            /* Test decoding the "Shape"
            var theMessage = [SCNNode]()
            if let theStroke = Stroke.readFromFile() {
            theMessage = theStroke.points
            }
            
            println(theMessage)*/
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
        scnView.removeFromSuperview() // take out the custom view
        
        // reset the shape & scene
        //shape = Stroke()
        //customScene = PrimitiveScene()
        //scnView = SCNView()
        //scnView.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height);
        shape.clearPoints()
        customScene.removeNodes()
        
        // reset the scene of the subview to be nothing
        scnView.scene = nil
        
        // reset the initial node & add it into the new shape's points array
        shape.points.removeAll(keepCapacity: false)
        startPositionNode = SCNNode()
        shape.points.append(startPositionNode)
        
        // Reset the necessary booleans
        hasCollectedData = false
        isTapped = false
        
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}