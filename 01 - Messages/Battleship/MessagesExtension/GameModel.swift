//
//  GameModel.swift
//  Battleship
//
//  Created by Samuel Burnstone on 18/07/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import Foundation
import Messages

struct GameModel {
    /// The cell locations of the ships
    let shipLocations: [Int]
    /// Whether the game has been completed or is still in progress
    var isComplete: Bool
}

// Encoding
extension GameModel {
    func encode() -> URL {
        let baseURL = "www.shinobicontrols.com/battleship"
        
        guard var components = URLComponents(string: baseURL) else {
            fatalError("Invalid base url")
        }
        
        var items = [URLQueryItem]()
        
        // Location
        let locationItems = shipLocations.map {
            location in
            URLQueryItem(name: "Ship_Location", value: String(location))
        }
        
        items.append(contentsOf: locationItems)
        
        // Game Complete
        let complete = isComplete ? "1" : "0"
        
        let completeItem = URLQueryItem(name: "Is_Complete", value: complete)
        items.append(completeItem)
        
        components.queryItems = items
        
        guard let url = components.url else {
            fatalError("Invalid URL components")
        }
        
        return url
    }
}

// Decoding from conversation
extension GameModel {
    init(from url: URL) {
        // Parse the url
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let componentItems = components.queryItems else {
                fatalError("Invalid message url")
        }
        
        // Naïvely retrieve the battleship cell location from the URL
        shipLocations = componentItems.filter({ $0.name == "Ship_Location" }).map({ Int($0.value!)! })
        
        // Even more naïvely retrieve game completion stat
        let completeQueryItem = componentItems.filter({ $0.name == "Is_Complete" }).first!
        isComplete = completeQueryItem.value! == "1"
    }

}
