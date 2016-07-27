//
//  GameStartViewController.swift
//  Battleship
//
//  Created by Sam Burnstone on 14/07/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit

class GameStartViewController: UIViewController {
    
    var onButtonTap: ((Void) -> Void)?
    
    @IBAction func startGame(_ sender: AnyObject) {
        onButtonTap?()
    }
}
