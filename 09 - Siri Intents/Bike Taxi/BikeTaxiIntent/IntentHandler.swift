//
//  IntentHandler.swift
//  BikeTaxiIntent
//
//  Created by Sam Burnstone on 06/10/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import Intents

enum BikeTaxiClass: String, CustomStringConvertible {
    case premier
    case basic
    
    var description: String {
        let characters = self.rawValue.characters
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
}

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

//MARK:- Resolving

extension IntentHandler {
    
    // At our fictional company, we only allow one passenger (it's hard to fit more on a bike!)
    @objc(resolvePartySizeForRequestRide:withCompletion:)
    func resolvePartySize(forRequestRide intent: INRequestRideIntent, with completion: @escaping (INIntegerResolutionResult) -> Void) {
        
        let result: INIntegerResolutionResult
        
        if let partySize = intent.partySize{
            if partySize == 1 {
                // We can offer a ride to this one person
                result = INIntegerResolutionResult.success(with: 1)
            }
            else {
                // Sorry... we don't support giving rides to more than 1 person
                result = INIntegerResolutionResult.unsupported()
            }
        }
        else {
             result = INIntegerResolutionResult.confirmationRequired(with: 1)
        }
        
        completion(result)
    }
    
    // We have two classes of rides: premier and basic
    @objc(resolveRideOptionNameForRequestRide:withCompletion:)
    func resolveRideOptionName(forRequestRide intent: INRequestRideIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
       
        if let rideName = intent.rideOptionName?.spokenPhrase?.lowercased(),
            let taxiClass = BikeTaxiClass(rawValue: rideName) {
            
            print("Ride class requested: \(rideName)")
            
            let speakableString = INSpeakableString(identifier: "", spokenPhrase: taxiClass.description, pronunciationHint: taxiClass.description)
            let result = INSpeakableStringResolutionResult.success(with: speakableString)
            completion(result)
            return
        }
    
        let premier = BikeTaxiClass.premier.description
        let premierSpeakableString = INSpeakableString(identifier: "", spokenPhrase: premier, pronunciationHint: premier)
        
        let basic = BikeTaxiClass.basic.description
        let basicSpeakableString = INSpeakableString(identifier: "", spokenPhrase: basic, pronunciationHint: basic)
        
        let result = INSpeakableStringResolutionResult.disambiguation(with: [premierSpeakableString, basicSpeakableString])
        
        completion(result)
    }
}
