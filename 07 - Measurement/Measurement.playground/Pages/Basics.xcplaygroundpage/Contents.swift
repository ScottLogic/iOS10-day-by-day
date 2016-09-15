//:# The Basics

import Foundation

//: Basic conversion
let milk = Measurement(value: 1, unit: UnitVolume.imperialPints)
milk.converted(to: .liters)

// Let's say we're making a recipe with 5 pints of milk and we need to translate the units into cups, as we're publishing this recipe in the US
(milk * 5).converted(to: .cups)

//: Multipliers aren't the only operators we can use
let kms = Measurement(value: 5, unit: UnitLength.kilometers)
let meters = Measurement(value: 5000, unit: UnitLength.meters)

kms == meters

//: We can also add them
kms + meters


//: No more manual conversion between degrees and
var halfRotation = Measurement(value: 180, unit: UnitAngle.degrees)
halfRotation.convert(to: .radians)

//:## Retrieving the base unit
UnitVolume.baseUnit().symbol
UnitArea.baseUnit().symbol
UnitPower.baseUnit().symbol

//: [Next](@next)
