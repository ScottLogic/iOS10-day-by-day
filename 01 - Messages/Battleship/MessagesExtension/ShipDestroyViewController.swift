//
//  ShipDestroyViewController.swift
//  Battleship
//
//  Created by Samuel Burnstone on 18/07/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit

class ShipDestroyViewController: UIViewController {
    @IBOutlet weak var gameBoard: GameBoardView!
    @IBOutlet weak var attemptsLabel: UILabel!
    @IBOutlet weak var shipsLabel: UILabel!
    
    var model: GameModel!
    
    var onGameCompletion: ((model: GameModel, playerWon: Bool, snapshot: UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if model.isComplete {
            let alert = UIAlertController(title: "Game Complete!", message: "The game's already finished!", preferredStyle: .alert)
            present(alert, animated: true)
            gameBoard.isHidden = true
            attemptsLabel.isHidden = true
            shipsLabel.isHidden = true
            return
        }
        
        updateLabels()
        
        gameBoard.onCellSelection = {
            [unowned self]
            cellLocation in
            
            if self.model.shipLocations.contains(cellLocation) {
                self.gameBoard.alterCell(at: cellLocation, applying: .selectedGreen)
            }
            else {
                self.gameBoard.alterCell(at: cellLocation, applying: .selectedRed)
            }
            
            self.updateLabels()
            self.checkGameCompletion()
        }
    }
}

extension ShipDestroyViewController {
    func updateLabels() {
        shipsLabel.text = "Hit: \(shipsHitCount())/\(GameConstants.totalShipCount)" 
        
        let livesRemaining = GameConstants.incorrectAttemptsAllowed - incorrectAttemptsCount()
        attemptsLabel.text = "Lives: \(livesRemaining)/\(GameConstants.incorrectAttemptsAllowed)"
    }
}

// Kick to main screen when game complete
extension ShipDestroyViewController {
    func checkGameCompletion() {
        let snapshot = UIImage.snapshot(from: gameBoard)
        
        if incorrectAttemptsCount() >= GameConstants.incorrectAttemptsAllowed {
            model.isComplete = true
            onGameCompletion?(model: model, playerWon: false, snapshot: snapshot)
        }
        else if shipsHitCount() == GameConstants.totalShipCount {
            model.isComplete = true
            onGameCompletion?(model: model, playerWon: true, snapshot: snapshot)
        }
    }
    
    func incorrectAttemptsCount() -> Int {
        return gameBoard.selectedCells.filter { !model.shipLocations.contains($0) }.count
    }
    
    func shipsHitCount() -> Int {
        return gameBoard.selectedCells.filter { model.shipLocations.contains($0) }.count
    }
}
