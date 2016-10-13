//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Sam Burnstone on 14/07/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    override func willBecomeActive(with conversation: MSConversation) {
        configureChildViewController(for: presentationStyle, with: conversation)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        guard let conversation = self.activeConversation else { return }
        configureChildViewController(for: presentationStyle, with: conversation)
    }
}

extension MessagesViewController {
    fileprivate func configureChildViewController(for presentationStyle: MSMessagesAppPresentationStyle,
                                              with conversation: MSConversation) {
        // Remove any existing child view controllers
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        // Now let's create our new one
        let childViewController: UIViewController
        
        switch presentationStyle {
        case .compact:
            childViewController = createGameStartViewController()
        case .expanded:
            if let message = conversation.selectedMessage,
                let url = message.url {
                let model = GameModel(from: url)
                childViewController = createShipDestroyViewController(with: conversation, model: model)
            }
            else {
                childViewController = createShipLocationViewController(with: conversation)
            }
        }
        
        // Add controller
        addChildViewController(childViewController)
        childViewController.view.frame = view.bounds
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        
        childViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        childViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        childViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        childViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        childViewController.didMove(toParentViewController: self)
    }
    
    fileprivate func createShipLocationViewController(with conversation: MSConversation) -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ShipLocationViewController") as? ShipLocationViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        controller.onLocationSelectionComplete = {
            [unowned self]
            model, snapshot in
            
            let session = MSSession()
            let caption = "$\(conversation.localParticipantIdentifier) placed their ships! Can you find them?"
            
            self.insertMessageWith(caption: caption, model, session, snapshot, in: conversation)
            
            self.dismiss()
        }
        
        return controller
    }
    
    fileprivate func createShipDestroyViewController(with conversation: MSConversation, model: GameModel) -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ShipDestroyViewController") as? ShipDestroyViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        controller.model = model
        controller.onGameCompletion = {
            [unowned self]
            model, playerWon, snapshot in
            
            if let message = conversation.selectedMessage,
                let session = message.session {
                let player = "$\(conversation.localParticipantIdentifier)"
                let caption = playerWon ? "\(player) destroyed all the ships!" : "\(player) lost!"
                
                self.insertMessageWith(caption: caption, model, session, snapshot, in: conversation)
            }
            
            self.dismiss()
        }
        
        return controller
    }
    
    fileprivate func createGameStartViewController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "GameStartViewController") as? GameStartViewController else {
            fatalError("Cannot instantiate view controller")
        }
        
        controller.onButtonTap = {
            [unowned self] in
            self.requestPresentationStyle(.expanded)
        }
        
        return controller
    }
}

extension MessagesViewController {
    /// Constructs a message and inserts it into the conversation
    func insertMessageWith(caption: String,
                           _ model: GameModel,
                           _ session: MSSession,
                           _ image: UIImage,
                           in conversation: MSConversation) {
        let message = MSMessage(session: session)
        let template = MSMessageTemplateLayout()
        template.image = image
        template.caption = caption
        message.layout = template
        message.url = model.encode()
        
        // Now we've constructed the message, insert it into the conversation
        conversation.insert(message)
    }
}
