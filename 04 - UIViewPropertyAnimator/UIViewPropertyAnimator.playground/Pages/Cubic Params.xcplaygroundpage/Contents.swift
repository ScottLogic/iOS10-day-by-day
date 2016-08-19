//: [Previous](@previous)
//:## Animation using Cubic Timing Function
//: ---
import UIKit
import PlaygroundSupport

// Container for our animating view
let containerView = NinjaContainerView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

let ninja = containerView.ninja

// Show the container view in the Assistant Editor
PlaygroundPage.current.liveView = containerView

//: Create our own bezier curve
let bezierParams = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.05, y: 0.95),
                                                   controlPoint2: CGPoint(x: 0.15, y: 0.95))

let animator = UIViewPropertyAnimator(duration: 4, timingParameters:bezierParams)

// Add our first animation block
animator.addAnimations ({
    containerView.moveNinjaToBottomRight()
}, delayFactor: 0.25)

animator.startAnimation()

//: [Next](@next)
