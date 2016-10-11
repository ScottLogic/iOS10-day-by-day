//
//  ViewController.swift
//  Bike Taxi
//
//  Created by Sam Burnstone on 06/10/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        INPreferences.requestSiriAuthorization {
            status in
            if status == .authorized {
                print("Wonderful!")
            }
            else {
                print("Hmmm... This demo app is going to pretty useless if you don't enable Siri. Fancy changing your mind?")
            }
        }
    }
}

