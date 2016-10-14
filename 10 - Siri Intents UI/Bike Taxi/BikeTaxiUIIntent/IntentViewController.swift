//
//  IntentViewController.swift
//  BikeTaxiUIIntent
//
//  Created by Sam Burnstone on 11/10/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import IntentsUI

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var pickUpLocationLabel: UILabel!
    @IBOutlet weak var dropOffLocationLabel: UILabel!
    
    @IBOutlet weak var bikeTypeLabel: UILabel!
    
    @IBOutlet weak var rideImageView: UIImageView!
    
    // MARK: - INUIHostedViewControlling
    
    func configure(with interaction: INInteraction!, context: INUIHostedViewContext, completion: ((CGSize) -> Void)!) {
        
        let intent = interaction.intent as! INRequestRideIntent
        let rideName = intent.rideOptionName?.spokenPhrase
        let pickUpLocation = intent.pickupLocation
        let dropOffLocation = intent.dropOffLocation
        let bikeTaxiClass = BikeTaxiClass(rawValue: rideName!.lowercased())!
        
        // Configure the image type
        
        /*
            Image credits:
            Premier: CanamPhotos (https://flic.kr/p/6GBAcY)
            Basic: Doug Shaw (https://flic.kr/p/cHJRUJ)
         */
        rideImageView.image = bikeTaxiClass == .basic ? #imageLiteral(resourceName: "basic") : #imageLiteral(resourceName: "premier")
        
        // Set the pick-up and drop-off points
        pickUpLocationLabel.text = pickUpLocation?.name ?? ""
        dropOffLocationLabel.text = dropOffLocation?.name ?? ""
        
        bikeTypeLabel.text = "Vehicle Type: \(bikeTaxiClass)"
        
        if let completion = completion {
            completion(self.desiredSize)
        }
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
}

extension IntentViewController: INUIHostedViewSiriProviding {
    var displaysMap: Bool { return true }
}
