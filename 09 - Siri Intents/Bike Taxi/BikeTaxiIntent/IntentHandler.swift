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

//MARK:- Handling
extension IntentHandler: INRequestRideIntentHandling {
    
    func handle(requestRide intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        
        // Our fictional company has unlimited numbers of drivers, all called John Appleseed, so we'll always be able to get to the user.
        let responseCode = INRequestRideIntentResponseCode.success
        
        let response = INRequestRideIntentResponse(code: responseCode,
                                                   userActivity: nil)
        
        // Set up the driver info
        let driverHandle = INPersonHandle(value: "john@biketaxis.com", type: .emailAddress)
        var personComponents = PersonNameComponents()
        personComponents.familyName = "Appleseed"
        personComponents.givenName = "John"
        
        let formatter = PersonNameComponentsFormatter()
        
        let driver = INRideDriver(personHandle: driverHandle,
                                  nameComponents: personComponents,
                                  displayName: formatter.string(from: personComponents),
                                  image: nil,
                                  contactIdentifier: nil,
                                  customIdentifier: nil)
        
        let vehicle = INRideVehicle()
        vehicle.manufacturer = "Super Bike"
        // Hardcode the location to be center of Newcastle, UK
        vehicle.location = CLLocation(latitude: 54.978252,
                                      longitude: -1.6177800000000389)
        
        // The important part - combining all the above information
        let status = INRideStatus()
        status.driver = driver
        status.vehicle = vehicle
        status.phase = .confirmed
        status.pickupLocation = intent.pickupLocation
        status.dropOffLocation = intent.dropOffLocation
        
        response.rideStatus = status
        
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

extension IntentHandler {
    
    @objc(resolvePickupLocationForRequestRide:withCompletion:)
    func resolvePickupLocation(forRequestRide intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        completion(placemarkResolutionResult(for: intent.pickupLocation))
    }
    
    @objc(resolveDropOffLocationForRequestRide:withCompletion:) func resolveDropOffLocation(forRequestRide intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        completion(placemarkResolutionResult(for: intent.dropOffLocation))
    }
    
    private func placemarkResolutionResult(for placemark: CLPlacemark?) -> INPlacemarkResolutionResult {
        guard let placemark = placemark else {
            return INPlacemarkResolutionResult.needsValue()
        }
        
        let result: INPlacemarkResolutionResult
        
        if placemark.isoCountryCode == "GB" {
            result = INPlacemarkResolutionResult.success(with: placemark)
        }
        else {
            result = INPlacemarkResolutionResult.unsupported()
        }
        
        return result
    }
}

//MARK:- Confirming
extension IntentHandler {
    @objc(confirmRequestRide:completion:)
    func confirm(requestRide intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        // Verify network connection to our state-of-the-art ride booking service is available
        
        // Let's say it is
        let responseCode = INRequestRideIntentResponseCode.ready
        let response = INRequestRideIntentResponse(code: responseCode, userActivity: nil)
        
        // Move on to the handling stage
        completion(response)
    }
}
