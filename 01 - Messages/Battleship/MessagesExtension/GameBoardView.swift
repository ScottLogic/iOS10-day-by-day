//
//  GameBoardView.swift
//  Battleship
//
//  Created by Samuel Burnstone on 18/07/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit

/// A quick and dirty way of displaying a grid of 3x3 cells
class GameBoardView: UICollectionView {
    
    enum CellStyle {
        case selectedGreen
        case selectedRed
        case deselected
    }
    
    private var cellStyles = Array(repeating: CellStyle.deselected, count: 9)
    
    var onCellSelection: ((cellLocation: Int) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "GameCell")
        
        dataSource = self
        delegate = self
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Hack to prevent collection view from being positioned incorrectly... only occurs on ShipDestroyViewController
        // when present modally.
        contentOffset = CGPoint(x: 0, y: 0)
    }
}

// Cell Styling
extension GameBoardView {
    /// Resets the game board to 'empty' style i.e. where no cells are selected
    func reset() {
        cellStyles = Array(repeating: .deselected, count: 9)
        reloadData()
        layoutIfNeeded()
    }
    
    /// The number of selected cells (green and red)
    var selectedCells: [Int] {
        var cells = [Int]()
        
        for (index, selected) in cellStyles.enumerated() where selected == .selectedGreen || selected == .selectedRed {
            cells.append(index)
        }
        
        return cells
    }
    
    /// Toggles the appearance of a cell between deselected and 'selectedGreen' styles
    func toggleCellStyle(at cellIndex: Int) {
        let style: CellStyle = cellStyles[cellIndex] == .selectedGreen ? .deselected : .selectedGreen
        alterCell(at: cellIndex, applying: style)
    }
    
    /// Alters the appearance of the cell at the given index by applying style to it
    func alterCell(at index: Int, applying selectionStyle: CellStyle) {
        cellStyles[index] = selectionStyle
        let path = IndexPath(row: index, section: 0)

        let cell = cellForItem(at: path)!
        decorate(cell, for: selectionStyle)
    }
    
    private func decorate(_ cell: UICollectionViewCell, for style: CellStyle) {
        switch style {
        case .selectedGreen:
            cell.backgroundColor = .green()
        case .selectedRed:
            cell.backgroundColor = .red()
        case .deselected:
            cell.backgroundColor = UIColor(red:0.33, green:0.43, blue:0.54, alpha:1.00)
        }
    }
}

// DataSource
extension GameBoardView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath)
        
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.black().withAlphaComponent(0.5).cgColor
        
        decorate(cell, for: cellStyles[indexPath.row])
        
        return cell
    }
}

// Delegate
extension GameBoardView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRow: CGFloat = 3
        let perimeterLength = floor(superview!.bounds.width / cellsPerRow)
        
        return CGSize(width: perimeterLength, height: perimeterLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onCellSelection?(cellLocation: indexPath.row)
    }
}

