//: [Previous](@previous)
//:## Scrubbable Animations
//: ---
import UIKit
import PlaygroundSupport

// Container for our animating view
let containerView = NinjaContainerView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

let ninja = containerView.ninja

// Show the container view in the Assistant Editor
PlaygroundPage.current.liveView = containerView

//: We need a way to receive 'value changed' events from the scrubber
class ScrubReceiver: NSObject {
    
    var onValueChange: ((Float) -> ())?

    func performValueChangedHandler(slider: UISlider) {
        onValueChange?(slider.value)
    }
}

//: Now for the interesting bit. Not how when we scrub, it doesn't follow the 'easeIn' timing curve. See WWDC video for explanation as to relationship between `fractionComplete` and `time`.
let animator = UIViewPropertyAnimator(duration: 5, curve: .easeIn)

// Add our first animation block
animator.addAnimations {
    containerView.moveNinjaToBottomRight()
}

let scrubber = UISlider(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: 50))
containerView.addSubview(scrubber)

let eventListener = EventListener()
eventListener.eventFired = {
    animator.fractionComplete = CGFloat(scrubber.value)
}

scrubber.addTarget(eventListener, action: #selector(EventListener.handleEvent), for: .valueChanged)

//: [Next](@next)
