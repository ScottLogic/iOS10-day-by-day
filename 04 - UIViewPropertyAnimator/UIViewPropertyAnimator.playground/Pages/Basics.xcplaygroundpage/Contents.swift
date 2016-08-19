//:## Getting Started
//: ---
import UIKit
import PlaygroundSupport

// Container for our animating view
let containerView = NinjaContainerView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

let ninja = containerView.ninja

// Show the container view in the Assistant Editor
PlaygroundPage.current.liveView = containerView

//: Now we've set up our view, let's animate it with a simple animation
UIViewPropertyAnimator(duration: 1, curve: .easeInOut) {
    containerView.moveNinjaToBottomRight()
}.startAnimation()

/*:
 - note:
 The above is very similar to the pre-iOS 10 view animation mechanism:
 ```
UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: {
        ninja.center = {
            let x = (containerView.frame.maxX - ninja.frame.width / 2)
            let y = (containerView.frame.maxY - ninja.frame.height / 2)
            return CGPoint(x: x, y: y)
        }()
    }
)
 ```
 */
//: [Next](@next)
