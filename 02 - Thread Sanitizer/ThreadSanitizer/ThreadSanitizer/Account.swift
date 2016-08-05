//
//  Account.swift
//  ThreadSanitizer
//
//  Created by Samuel Burnstone on 04/08/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import Foundation

class Account {
    private var _balance: Int = 0
    var balance: Int {
        return queue.sync {
            return _balance
        }
    }
    
    /// Serial queue to moderate access to `balance` property
    private let queue = DispatchQueue(label: "com.shinobicontrols.balance-moderator")
    
    /// Withdraws $100 from the account
    func withdraw(amount: Int, onSuccess: () -> ()) {
        queue.async {
            let newBalance = self._balance - amount

            if newBalance < 0 {
                print("You don't have enough money to withdraw \(amount)")
                return
            }
            
            // Some bogus processing to force a race condition when `deposit` method simulataneouslySimulate invoked
            // We'll pretend it's for checking for fraudulent withdrawals :)
            sleep(1)
            
            self._balance = newBalance
            
            DispatchQueue.main.async {
                onSuccess()
            }
        }
    }
    
    /// Desposits $100 into the account.
    func deposit(amount: Int, onSuccess: () -> ()) {
        queue.async {
            let newBalance = self._balance + amount
            self._balance = newBalance
            
            DispatchQueue.main.async {
                onSuccess()
            }
        }
    }
}
