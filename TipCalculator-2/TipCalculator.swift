//
//  TipCalculator.swift
//  TipCalculator-2
//
//  Created by Madel Asistio on 11/8/17.
//  Copyright © 2017 Madel Asistio. All rights reserved.
//

import Foundation

struct TipCalculator {
    
    var mealPrice: Double?
    var totalPrice: Double?
    var tipAmount: Double?
    
    var tipPercentage = [0.15, 0.18, 0.20]
    
    
    mutating func calculateTips(with percentageIndex: Int) {
        
        if mealPrice != nil {
            tipAmount = mealPrice! * tipPercentage[percentageIndex]
            totalPrice = mealPrice! + tipAmount!
        }
    }
    
    mutating func changeTipAmt(at index: Int, with value: Double) {
        tipPercentage[index] = value
    }
    
    mutating func roundVals() -> (Double, Double) {
        var rounded = (tip: 0.0, total: 0.0)
        
        if let totalPrice = totalPrice {
            rounded.total = round(totalPrice)
            
            if let tip = tipAmount {
                rounded.tip = tip + (rounded.total - totalPrice)
            }
        }
        
        return rounded
        
    }
        
    
}
