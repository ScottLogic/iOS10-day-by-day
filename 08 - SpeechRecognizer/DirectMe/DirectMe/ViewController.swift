//
//  ViewController.swift
//  DirectMe
//
//  Created by Samuel Burnstone on 27/09/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Instruction: String {
        case left
        case right
        case up
        case down
    }

    let transcriber = SpeechTranscriber()
    let ninja = UIImageView(image: #imageLiteral(resourceName: "Ninja"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Position ninja
        ninja.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        ninja.center = view.center
        view.addSubview(ninja)
    
        // Set up closure executed when final transcription is available to us
        transcriber.onTranscriptionCompletion = {
            [unowned self]
            transcription in
            
            // Parse the string into individual Instructions
            let instructions = transcription.components(separatedBy: " ").flatMap {
                return Instruction(rawValue: $0)
            }
            
            if instructions.count == 0 {
                return
            }
            
            // So we can see the individual instructions more clearly, we'll animate each one.
            let individualInstructionAnimationDuration = 0.5
            let totalAnimationDuration = Double(instructions.count) * individualInstructionAnimationDuration
            let relativeIndividualDuration = 1 / Double(instructions.count)
            
            UIView.animateKeyframes(withDuration: totalAnimationDuration, delay: 0, options: [], animations: {
                for (index, instruction) in instructions.enumerated() {
                    
                    UIView.addKeyframe(withRelativeStartTime: relativeIndividualDuration * Double(index),
                                       relativeDuration: relativeIndividualDuration) {
                        self.moveNinja(for: instruction)
                        self.view.layoutIfNeeded()
                    }
                }
            })
        }
    }
    
    @IBAction func directionsButtonPressed(_ sender: UIButton) {
        if !transcriber.isTranscribing {
            // Not currently listening for directions, so let's start!
            transcriber.start()
            // Update button appearance
            sender.setTitle("End Recording", for: .normal)
            sender.backgroundColor = .red
        }
        else {
            // Already listening, so let's stop the recording
            transcriber.stop()
            // Update button appearance
            sender.setTitle("Record Directions", for: .normal)
            sender.backgroundColor = .green
        }
    }
}

extension ViewController {
    
    /// Moves the ninja character based on the given instruction.
    func moveNinja(for instruction: Instruction) {
        let movement: CGVector
        
        // The distance to move in any direction
        let distance = 100
        
        switch instruction {
        case .left:
            movement = CGVector(dx: -distance, dy: 0)
        case .right:
            movement = CGVector(dx: distance, dy: 0)
        case .down:
            movement = CGVector(dx: 0, dy: distance)
        case .up:
            movement = CGVector(dx: 0, dy: -distance)
        }
        
        self.ninja.center.x += movement.dx
        self.ninja.center.y += movement.dy
    }
}

extension UIButton {
    
    func setReadyToRecordState() {
        setTitle("Record Directions", for: .normal)
        backgroundColor = .green
    }
    
    func setIsRecordingState() {
        setTitle("End Recording", for: .normal)
        backgroundColor = .red
    }
}
