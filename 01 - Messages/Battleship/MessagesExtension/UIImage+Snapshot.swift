//
//  UIImage+Snapshot.swift
//  Battleship
//
//  Created by Samuel Burnstone on 18/07/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit

extension UIImage {
    /// Create an image represenation of the given view
    class func snapshot(from view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return snapshot!
    }
}
