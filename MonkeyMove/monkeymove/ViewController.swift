//
//  ViewController.swift
//  MonkeyMove
//
//  Created by Eitan Mendelowitz on 10/28/14.
//  Copyright (c) 2014 Eitan Mendelowitz. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var xAccelField: UITextField!
    @IBOutlet weak var yAccelField: UITextField!
    @IBOutlet weak var zAccelField: UITextField!
    
    @IBOutlet weak var monkey: UIImageView!
    var frameRate : Float  = 30.0
    var smoothingFactor : CGFloat = 0.5
    var motionManager : CMMotionManager!  // don't forget to hang on to montionManager
    
    var sx :Float = 0
    var sy :Float = 0
    var sz :Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Centering the monkey on the screen -- good if you want it centered on different screens
        monkey.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height/2)
        
        //Creating instance of CoreMotion
        motionManager = CMMotionManager()
        
        // Setting up the update interval : specified in seconds
        motionManager.accelerometerUpdateInterval = 1.0/Double(frameRate)
        
        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
            (data, error) in
            dispatch_async(dispatch_get_main_queue()) { // need to modify view on screen in main thread
                let nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                
                let currentX = self.monkey.center.x
                let currentY = self.monkey.center.y
                //let currentZ = self.monkey.center.z
                
                var smoothing :Float = 0.99
                self.sx = smoothing * self.sx + (1.0-smoothing) * Float(data.userAcceleration.x)
                self.sy = smoothing * self.sy + (1.0-smoothing) * Float(data.userAcceleration.y)
                self.sz = smoothing * self.sz + (1.0-smoothing) * Float(data.userAcceleration.z)
                
                //                let sx = CGFloat(data.userAcceleration.x)
                //               let sy = CGFloat(data.userAcceleration.y)
                //              let sz = CGFloat(data.userAcceleration.z)
                
                //NSString(format:"%.4f", sz)
                self.xAccelField.text = nf.stringFromNumber(self.sx)
                self.yAccelField.text = nf.stringFromNumber(self.sy)
                //self.zAccelField.text = nf.stringFromNumber(self.sz)
                
//                // check if acceleration is 0 -- constant velocity
//                if Float(data.userAcceleration.x)!=0 {
//                    var destX = (CGFloat(data.userAcceleration.x) * CGFloat(self.frameRate) + CGFloat(currentX))
//                } else {
//                    // constant velocity. Do something
//                }
//                if Float(data.userAcceleration.y)!=0{
//                    var destY = (CGFloat(data.userAcceleration.y) * CGFloat(self.frameRate) + CGFloat(currentY))
//                } else {
//                    // constant velocity. Do something
//                }
//                if Float(data.userAcceleration.z)!=0 {
//                    var destZ = (CGFloat(data.userAcceleration.z) * CGFloat(self.frameRate) + CGFloat(currentZ))
//                } else {
//                    // constant velocity. Do something
//                }

                var destX = (CGFloat(data.userAcceleration.x) * CGFloat(self.frameRate) + CGFloat(currentX))
                var destY = (CGFloat(data.userAcceleration.y) * CGFloat(self.frameRate) + CGFloat(currentY))
                //var destZ = (CGFloat(data.userAcceleration.z) * CGFloat(self.frameRate) + CGFloat(currentZ))

                
                if destY < 0 {
                    destY = self.view.bounds.height + destY
                }
                if destX < 0 {
                    destX = self.view.bounds.width + destX
                }
                destX %= self.view.bounds.width
                destY %= self.view.bounds.height
                
                self.monkey.center = CGPointMake(destX, destY)
                //self.monkey.center = CGPointMake(destX, destY, desZ)
                
                //                if (currentX < self.view.bounds.width && currentX > 0) {
                //                  var destX = (CGFloat(data.userAcceleration.y) * CGFloat(self.frameRate) + CGFloat(currentX))
                //                var destY = CGFloat(currentY)
                // Update position
                //              self.monkey.center = CGPointMake(destX, destY)
                //        } else if (currentX > self.view.bounds.width || currentX < 0) {
                //          // Attempt at resetting monkey position to 0 so that it doesn't get stuck
                //        self.monkey.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height/2)
                //  }
                
                
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

