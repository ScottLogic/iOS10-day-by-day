//: [Previous](@previous)
//:## Reversible Animations
//: ---
import UIKit
import PlaygroundSupport

// Container for our animating view
let containerView = NinjaContainerView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

let ninja = containerView.ninja

// Show the container view in the Assistant Editor
PlaygroundPage.current.liveView = containerView

let animationDuration: TimeInterval = 3.0

let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut)

//: Give the appearance of our ninja leaping from one side of the screen to the other using keyframe animations.

animator.addAnimations {
    UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [.calculationModeCubic], animations: {
        UIView.addKeyframe(withRelativeStartTime: 0,  relativeDuration: 0.5) {
            ninja.center = containerView.center
        }
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
            containerView.moveNinjaToBottomRight()
        }
    })
}

//: Add a button to allow our ninja's jump to be reversed
let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 30)))
button.setTitle("Reverse", for: .normal)
button.setTitleColor(.black, for: .normal)
button.setTitleColor(.gray, for: .highlighted)
let listener = EventListener()
listener.eventFired = {
    animator.isReversed = true
}

button.addTarget(listener, action: #selector(EventListener.handleEvent), for: .touchUpInside)
containerView.addSubview(button)

animator.startAnimation()

//: [Next](@next)
