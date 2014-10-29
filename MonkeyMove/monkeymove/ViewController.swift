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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Centering the monkey on the screen -- good if you want it centered on different screens
        monkey.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height/2)
        
        
        //Creating instance of CoreMotion
        motionManager = CMMotionManager()
        
        // Setting up the update interval : specified in seconds
        motionManager.accelerometerUpdateInterval = 5.0 /*/Double(frameRate)*/

        self.motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
            (data, error) in
            dispatch_async(dispatch_get_main_queue()) { // need to modify view on screen in main thread
                let nf = NSNumberFormatter()
                nf.numberStyle = .DecimalStyle
                
                let currentX = self.monkey.center.x
                let currentY = self.monkey.center.y
                
                // My attempt at smoothing the data... it could be better
                let sx = CGFloat(data.userAcceleration.x) * self.smoothingFactor * (1.0 - self.smoothingFactor)
                let sy = CGFloat(data.userAcceleration.y) * self.smoothingFactor * (1.0 - self.smoothingFactor)
                let sz = CGFloat(data.userAcceleration.z) * self.smoothingFactor * (1.0 - self.smoothingFactor)
                
                //NSString(format:"%.4f", sz)
                self.xAccelField.text = nf.stringFromNumber(sx)
                self.yAccelField.text = nf.stringFromNumber(sy)
                self.zAccelField.text = nf.stringFromNumber(sz)
                
                if (currentX < self.view.bounds.width && currentX > 0) {
                    var destX = (CGFloat(data.userAcceleration.y) * CGFloat(self.frameRate) + CGFloat(currentX))
                    var destY = CGFloat(currentY)
                    // Update position
                    self.monkey.center = CGPointMake(destX, destY)
                } else if (currentX > self.view.bounds.width || currentX < 0) {
                    // Attempt at resetting monkey position to 0 so that it doesn't get stuck
                    self.monkey.center = CGPointMake(self.view.bounds.width/2, self.view.bounds.height/2)
                }
                
                
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

