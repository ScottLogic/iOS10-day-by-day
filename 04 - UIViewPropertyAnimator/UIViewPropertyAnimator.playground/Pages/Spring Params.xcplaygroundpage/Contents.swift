//: [Previous](@previous)
//:## Spring Animations
//: ---
import UIKit
import PlaygroundSupport

// Container for our animating view
let containerView = NinjaContainerView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

let ninja = containerView.ninja

// Show the container view in the Assistant Editor
PlaygroundPage.current.liveView = containerView

//: Create our spring-like behaviour
let springParams = UISpringTimingParameters(dampingRatio: 0.3, initialVelocity: CGVector(dx: 10, dy: 0))

let animator = UIViewPropertyAnimator(duration: 4, timingParameters:springParams)

// Add our first animation block
animator.addAnimations ({
    containerView.moveNinjaToBottomRight()
    }, delayFactor: 0.25)

animator.startAnimation()

//: [Next](@next)
