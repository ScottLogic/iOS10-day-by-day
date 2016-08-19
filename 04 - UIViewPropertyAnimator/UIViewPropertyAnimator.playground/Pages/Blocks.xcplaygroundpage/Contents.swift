//: [Previous](@previous)
//:## Animation and Completion Blocks
//: ---
import UIKit
import PlaygroundSupport

// Container for our animating view
let containerView = NinjaContainerView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

let ninja = containerView.ninja

// Show the container view in the Assistant Editor
PlaygroundPage.current.liveView = containerView

// Now we've set up our view, let's animate it with a simple animation
let animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)

// Add our first animation block
animator.addAnimations {
    containerView.moveNinjaToBottomRight()
}

// Now here goes our second
animator.addAnimations {
    ninja.alpha = 0
}

// We can also add multiple completion blocks
animator.addCompletion {
    _ in
    print("Animation completed")
}

animator.addCompletion {
    position in
    switch position {
    case .end: print("Completion handler called at end of animation")
    case .current: print("Completion handler called mid-way through animation")
    case .start: print("Completion handler called  at start of animation")
    }
}

animator.startAnimation()
//: [Next](@next)
