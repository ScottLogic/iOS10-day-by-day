//
//  EmojificateCommand.swift
//  Emojificator_Extension
//
//  Created by Samuel Burnstone on 10/08/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import Foundation
import XcodeKit

class EmojificateCommand: NSObject, XCSourceEditorCommand {
    
    let asciiToEmojiMap = [
        ":)" : "😀",
        ";)" : "😉",
        ":(" : "☹️"]
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (Error?) -> Void) {
        let lines = invocation.buffer.lines
        
        for (index, line) in lines.enumerated() {
            if let line = line as? String,
                replaceableItemsExist(in: line) {
                lines[index] = replaceASCIIWithEmoji(in: line)
            }
        }
        
        // Command must perform completion to signify it has completed
        completionHandler(nil)
    }
}

extension EmojificateCommand {
    
    /// Returns whether the string contains an item that can be converted into emoji
    func replaceableItemsExist(in string: String) -> Bool {
        for asciiItem in asciiToEmojiMap.keys {
            if string.contains(asciiItem) {
                return true
            }
        }
        return false
    }
    
    /// Replaces any ASCII items with their emoji counterparts and returns the newly 'emojified' string
    func replaceASCIIWithEmoji(in string: String) -> String {
        var line = string
        for asciiItem in asciiToEmojiMap.keys {
            line = line.replacingOccurrences(of: asciiItem, with: asciiToEmojiMap[asciiItem]!)
        }
        return line
    }
}
