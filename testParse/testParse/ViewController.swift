//
//  ViewController.swift
//  testParse
//
//  Created by Giovanna Diaz on 11/19/14.
//  Copyright (c) 2014 Giovanna Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    var person = PFObject(className:"Person")
    var sliderVal = PFObject(className:"Slider")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setFirstName(sender: UITextField) {
        person["firstName"] = sender.text
        savePerson()
    }
    
    @IBAction func setLastName(sender: UITextField) {
        person["lastName"] = sender.text
        savePerson()
    }
    
    func savePerson(){
        person.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success) {
                NSLog("all done")
            } else {
                // handle error
            }
        }
    }
    
    func saveSlider() {
        sliderVal.saveInBackgroundWithBlock { (success, error) -> Void in
            if(success) {
                NSLog("all done")
            } else {
                // handle error
            }
        }
    }

}

