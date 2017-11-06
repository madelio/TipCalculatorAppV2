//
//  ViewController.swift
//  TipCalculator-2
//
//  Created by Madel Asistio on 11/4/17.
//  Copyright © 2017 Madel Asistio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var mealPriceText: UITextField!
    @IBOutlet weak var tipAmountText: UILabel!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var tipPercentageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var totalPriceText: UILabel!
    
    let tipPercentages = [0.15, 0.18,0.20]
    var keyboardYPosition:CGFloat = 0.0
    var inputPriceIsEmpty = true
    var isRoundedUp = false
    
    let formatter = NumberFormatter()
    
    var originalTotal = 0.0
    var originalTip = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mealPriceText.becomeFirstResponder()
        formatter.numberStyle = .currency
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardY = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardYPosition = keyboardY.origin.y
        }
    }
    
    func calculateTips() {
        tipAmount = mealPrice * tipPercentages[tipPercentageSegmentedControl.selectedSegmentIndex]
        totalPrice = tipAmount + mealPrice
        
        originalTotal = totalPrice
        originalTip = tipAmount
        
    }
    
    func popTotalWindowUp () {
        UIView.animate(withDuration: 1) {
            self.calculatorView.frame.size.height -= self.totalPriceView.frame.size.height
            self.tipPercentageSegmentedControl.alpha += 1
            self.tipPercentageSegmentedControl.frame.origin.y -= self.totalPriceView.frame.size.height
        }
    }
    
    func pushTotalWindowDown () {
        UIView.animate(withDuration: 1) {
            self.calculatorView.frame.size.height += self.totalPriceView.frame.size.height
            self.tipPercentageSegmentedControl.alpha -= 1
            self.tipPercentageSegmentedControl.frame.origin.y += self.totalPriceView.frame.size.height
        }
    }
    
    @IBAction func changeTipPercentage(_ sender: UISegmentedControl) {
        calculateTips()
    }
    
    @IBAction func roundUpToggle(_ sender: UITapGestureRecognizer) {
        
        if isRoundedUp == false {
            totalPrice = round(totalPrice)
            tipAmount = tipAmount + (totalPrice - originalTotal)
            isRoundedUp = true

        } else {
            totalPrice = originalTotal
            tipAmount = originalTip
            isRoundedUp = false
        }
        
    }
    
    @IBAction func changedMealPrice(_ sender: UITextField) {
        if inputPriceIsEmpty == true {
            popTotalWindowUp()
            inputPriceIsEmpty = false
        }
        if mealPrice == 0.0 {
            pushTotalWindowDown()
            inputPriceIsEmpty = true
        }
        
        calculateTips()
    }
    
    var mealPrice: Double {
        
        get {
            if let mealPriceTextVal = mealPriceText.text {
                return Double(mealPriceTextVal) ?? 0.0
            }
            return 0.0
        }
        set {
            mealPriceText.text = String(format:"$%.2f", newValue)
        }
    }
    
    var tipAmount: Double {
        
        get {
            let tipFromFormatter = formatter.number(from: tipAmountText.text ?? "$0.00")!
            return tipFromFormatter.doubleValue
        }
        set {
            tipAmountText.text = String(format:"$%.2f", newValue)
        }
    }
    
    var totalPrice: Double {
        
        get {
            
             let totalFromFormatter = formatter.number(from: totalPriceText.text ?? "$0.00")!
            return totalFromFormatter.doubleValue
       
        }
        set {
            
            totalPriceText.text = String(format:"$%.2f", newValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

