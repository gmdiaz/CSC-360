//
//  ViewController.swift
//  imageStay
//  Made with minor modifications from : http://nshipster.com/cmdevicemotion/
//
//  Created by Giovanna Diaz on 10/28/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var giovannaImage: UIImageView!
    
    var motionManager : CMMotionManager!  // don't forget to hang on to montionManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create local motionManager
        motionManager = CMMotionManager()
        
        
        if motionManager.deviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                (data, error)in
                
                let rotation = atan2(data.gravity.x, data.gravity.y) - M_PI
                self.giovannaImage.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

