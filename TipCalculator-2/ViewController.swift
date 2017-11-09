//
//  ViewController.swift
//  TipCalculator-2
//
//  Created by Madel Asistio on 11/4/17.
//  Copyright © 2017 Madel Asistio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SettingsViewControllerDelegate {
    
    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var mealPriceText: UITextField!
    @IBOutlet weak var tipAmountText: UILabel!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var tipPercentageSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var totalPriceText: UILabel!
    
    var defaultTipIndex = 0
    var keyboardYPosition:CGFloat = 0.0
    var inputPriceIsEmpty = true
    var isRoundedUp = false
    
    var canRound = true
    
    let formatter = NumberFormatter()
    let defaults = UserDefaults.standard
    
    private var calc = TipCalculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mealPriceText.becomeFirstResponder()
        formatter.numberStyle = .currency
        
        canRound = defaults.bool(forKey: "canRound")
       tipPercentageSegmentedControl.selectedSegmentIndex = defaults.integer(forKey: "defaultTip")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardY = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardYPosition = keyboardY.origin.y
        }
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
       
        calc.calculateTips(with: tipPercentageSegmentedControl.selectedSegmentIndex, mealPrice)
        
        tipAmount = calc.tip ?? 0.0
        totalPrice = calc.total ?? 0.0
    }
    
    @IBAction func roundUpToggle(_ sender: UITapGestureRecognizer) {
        
        if canRound {
            if isRoundedUp == false {
                let rounded = calc.roundVals()
                
                totalPrice = rounded.total
                tipAmount = rounded.tip
                
                isRoundedUp = true
                
            } else {
                totalPrice = calc.total!
                tipAmount = calc.tip!
                isRoundedUp = false
            }
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
        
        calc.calculateTips(with: tipPercentageSegmentedControl.selectedSegmentIndex, mealPrice)
        
        tipAmount = calc.tip ?? 0.0
        totalPrice = calc.total ?? 0.0
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
    
    func changedRoundOption(to canRoundVal: Bool) {
       canRound = canRoundVal
    }
    
    func reset() {
        tipPercentageSegmentedControl.selectedSegmentIndex = 0
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSettings" {
           let settingsVC = segue.destination as! SettingsTableViewController
            settingsVC.delegate = self
            settingsVC.calc = calc
         
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

