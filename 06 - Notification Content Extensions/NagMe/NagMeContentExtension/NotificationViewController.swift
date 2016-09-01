//
//  NotificationViewController.swift
//  NagMeContentExtension
//
//  Created by Samuel Burnstone on 01/09/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        label.text = "Reminder: \(notification.request.content.body)"
        speakerLabel.shake()
    }

}

extension UIView {
    
    // Very slightly modified version of sample code found in stack overflow post http://stackoverflow.com/a/34778432
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
