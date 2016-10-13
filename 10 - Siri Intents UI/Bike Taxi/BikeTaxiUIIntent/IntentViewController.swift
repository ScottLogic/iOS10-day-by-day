//
//  IntentViewController.swift
//  BikeTaxiUIIntent
//
//  Created by Sam Burnstone on 11/10/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import IntentsUI

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configure(with interaction: INInteraction!, context: INUIHostedViewContext, completion: ((CGSize) -> Void)!) {
        // Do configuration here, including preparing views and calculating a desired size for presentation.
        if let completion = completion {
            completion(self.desiredSize)
        }
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
