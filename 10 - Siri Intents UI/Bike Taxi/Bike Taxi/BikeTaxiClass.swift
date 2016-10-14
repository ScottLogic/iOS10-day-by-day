//
//  BikeTaxiClass.swift
//  Bike Taxi
//
//  Created by Sam Burnstone on 13/10/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//
enum BikeTaxiClass: String, CustomStringConvertible {
    case premier
    case basic
    
    var description: String {
        return self.rawValue.capitalized
    }
}
