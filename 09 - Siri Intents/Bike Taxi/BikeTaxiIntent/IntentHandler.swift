//
//  IntentHandler.swift
//  BikeTaxiIntent
//
//  Created by Sam Burnstone on 06/10/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
}

extension IntentHandler: INRequestRideIntentHandling {
    
    func handle(requestRide intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        print("Handling bike taxi request!")
        
        let responseCode = INRequestRideIntentResponseCode.failureRequiringAppLaunchNoServiceInArea
        
        let response = INRequestRideIntentResponse(code: responseCode,
                                                   userActivity: nil)
        
        completion(response)
    }
}

