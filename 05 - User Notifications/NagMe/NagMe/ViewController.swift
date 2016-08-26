//
//  BirthdayTableViewController.swift
//  NagMe
//
//  Created by Samuel Burnstone on 25/08/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit
import UserNotifications

class NagMeTableViewController: UITableViewController {
    
    typealias Task = String
    
    let tasks: [Task] = [
        "Wash Up",
        "Walk Dog",
        "Exercise"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        
        // Reload the tableview when the app is reloaded... want to update the icon states in case the user has cancelled a notification
        NotificationCenter.default.addObserver(tableView, selector: #selector(UITableView.reloadData), name: NSNotification.Name.UIApplicationDidBecomeActive, object:nil)
    }
}

// MARK:- DataSource
extension NagMeTableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        
        let task = tasks[indexPath.row]
        
        cell.nameLabel.text = task
        
        // Set the cell's icon to indicate whether notification exists or not
        retrieveNotification(for: task) {
            request in
            request != nil ? cell.showReminderOnIcon() : cell.showReminderOffIcon()
        }
        
        // Closure invoked when button tapped
        cell.onButtonSelection = {
            [unowned self] in
            self.toggleReminder(for: task)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    /// Returns the cell displaying the given task, if exists
    func cell(for task: Task) -> TaskCell? {
        let index = tasks.index(of: task)!
        let path = IndexPath(row: index, section: 0)
        return tableView.cellForRow(at: path) as? TaskCell
    }
}

// MARK:- Delegate
extension NagMeTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK:- Notification Retrieval
extension NagMeTableViewController {
    
    /// If a notification is scheduled for the given task, it's turned off and vice versa.
    func toggleReminder(for task: Task) {
        
        retrieveNotification(for: task) {
            request in
            guard request != nil else {
                // Notification doesn't exist, therefore schedule it
                self.createReminderNotification(for: task)
                return
            }
            
            // Remove notification
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task])
            
            // Now we've muted the notification, let's set the cell's icon to reflect that.
            if let cell = self.cell(for: task) {
                cell.showReminderOffIcon()
            }
        }
    }
    
    /// Creates a notification for the given task, repeated every minute.
    func createReminderNotification(for task: Task) {
        // Configure our notification's content
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "\(task)!!" // Important to include this, otherwise notification won't display
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = Identifiers.reminderCategory
        
        // We want the notification to nag us every 60 seconds (the minimum time-interval Apple allows us to repeat at)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        // Simply use the task name as our identifier. This means we have a single notification per task... any other notifications created with same identifier will overwrite the existing notification.
        let identifier = "\(task)"
        
        // Construct the request with the above components
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {
            error in
            if let error = error {
                print("Problem adding notification: \(error.localizedDescription)")
            }
            else {
                // Set icon
                DispatchQueue.main.async {
                    if let cell = self.cell(for: task) {
                        cell.showReminderOnIcon()
                    }
                }
            }
        }
    }
    
    /// Attempts to find the notification scheduled for the given task name.
    func retrieveNotification(for task: Task, completion: @escaping (UNNotificationRequest?) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests {
            requests in
            // The pending requests are fetched on a background thread, so need to ensure we access our properties and UI elements on main thread
            DispatchQueue.main.async {
                let request = requests.filter { $0.identifier == task }.first
                completion(request)
            }
        }
    }
}
