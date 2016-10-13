//: [Previous](@previous)

import Foundation

//: We can use `MeasurementFormatter` to be locale-aware

let newcastleToLondon = Measurement(value: 248, unit: UnitLength.miles)

let formatter = MeasurementFormatter()
formatter.locale = Locale(identifier: "fr")
formatter.string(from: newcastleToLondon)

formatter.locale = Locale(identifier: "en_GB")
formatter.string(from: newcastleToLondon)

//: [Next](@next)
