//
//  BirthdayCell.swift
//  NotifiyMe
//
//  Created by Samuel Burnstone on 25/08/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet private weak var toggleReminderButton: UIButton!
    
    var onButtonSelection: (() -> ())?
    
    @IBAction private func remindButtonTapped(_ sender: AnyObject) {
        onButtonSelection?()
    }
    
    func showReminderOnIcon() {
        toggleReminderButton.setTitle("🔊", for: .normal)
    }

    func showReminderOffIcon() {
        toggleReminderButton.setTitle("🔇", for: .normal)
    }
}
