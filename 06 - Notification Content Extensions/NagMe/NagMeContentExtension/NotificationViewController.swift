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
    
    func didReceive(_ response: UNNotificationResponse,
                    completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        if response.actionIdentifier == Identifiers.cancelAction {
            let request = response.notification.request
            
            let identifiers = [request.identifier]
            
            // Remove future notifications that have been scheduled
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            
            // Remove any notifications that have already been delivered so we're not cluttering up the user's notification center
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
            
            // Visual feedback that notification has been cancelled
            speakerLabel.text = "🔇"
            speakerLabel.cancelShake()
            
            completion(.doNotDismiss)
        }
        else {
            completion(.dismiss)
        }
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
    
    func cancelShake() {
        layer.removeAnimation(forKey: "shake")
    }
}
