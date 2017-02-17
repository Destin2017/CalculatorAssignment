
//  ViewController.swift
//  sCalc
//
//  Created by ilabadmin on 1/30/17.
//  Copyright © 2017 Strathmore. All rights reserved.
//

 import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private weak var lblDisplay: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var model = CalculatorModel()
    
    private var userIsTyping = false
    private let DECIMAL_CHAR = "."
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsTyping {
            let textCurrentlyInDisplay = lblDisplay.text!
            if digit != DECIMAL_CHAR || lblDisplay.text!.rangeOfString(DECIMAL_CHAR) == nil {
                lblDisplay.text = textCurrentlyInDisplay + digit
            }
        } else {
            if digit == DECIMAL_CHAR {
                lblDisplay.text = "0\(digit)"
            } else {
                lblDisplay.text = digit
            }
        }
        
        userIsTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(lblDisplay.text!)!
        }
        
        set {
            lblDisplay.text = String(newValue)
        }
    }
    
    
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsTyping {
            model.setOperand(displayValue)
            userIsTyping = false
        }
        
        if let mathOperation = sender.currentTitle {
            model.performOperand(mathOperation)
        }
        
        displayValue = model.result
        
        descriptionLabel.text = model.description
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}