//
//  ViewController.swift
//  ThreadSanitizerUI
//
//  Created by Samuel Burnstone on 02/08/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var balanceLabel: UILabel!
    
    let account = Account()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBalanceLabel()
    }
    
    @IBAction func withdraw(_ sender: UIButton) {
        self.account.withdraw(amount: 100, onSuccess: updateBalanceLabel)
    }
    
    @IBAction func deposit(_ sender: UIButton) {
        self.account.deposit(amount: 100, onSuccess: updateBalanceLabel)
    }
    
    func updateBalanceLabel() {
        balanceLabel.text = "Balance: $\(account.balance)"
    }
}
