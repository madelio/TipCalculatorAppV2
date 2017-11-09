//
//  SettingsTableViewController.swift
//  TipCalculator-2
//
//  Created by Madel Asistio on 11/6/17.
//  Copyright © 2017 Madel Asistio. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func changedRoundOption(to: Bool)
    func reset()

}

class SettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var defaultTipLabel: UILabel!

    let rowsInSection = [2, 1]
    let defaults = UserDefaults.standard
    var choosingDefaultTipInProgress = false
    
    @IBOutlet weak var tipPicker: UIPickerView!
    @IBOutlet weak var canRoundSwitch: UISwitch!
    weak var delegate:SettingsViewControllerDelegate?
    
    var calc: TipCalculator?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tipPicker.dataSource = self
        self.tipPicker.delegate = self
        
        
         defaultTipLabel.text = String(describing: calc!.tipPercentage[defaultTipIndex])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        canRoundSwitch.setOn(canRound, animated: true)
        tipPicker.selectRow(defaultTipIndex, inComponent: 0, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
            
        case 0:
            return rowsInSection[0]
        case 1:
            return rowsInSection[1]
        default:
            return 0
        }
      
    }
    
    @IBAction func toggleRoundButton(_ sender: UISwitch) {
        if canRoundSwitch.isOn {
            canRound = true
        } else {
            canRound = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if choosingDefaultTipInProgress {
                choosingDefaultTipInProgress = false
            } else {
                choosingDefaultTipInProgress = true
            }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.row == 0 && indexPath.section == 0 {
            if choosingDefaultTipInProgress {
                return 45 + tipPicker.frame.height
            } else {
                return 45
            }
        }
        return 45
    }

    /* Picker Functions */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (calc!.tipPercentage.count)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: calc!.tipPercentage[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaultTipLabel.text = String(describing: calc!.tipPercentage[row])
        defaultTipIndex = row
        print(defaultTipIndex)
    }
    
    var defaultTipIndex: Int {
        get {
            return defaults.integer(forKey: "defaultTip")
        }
        set {
            defaultTipLabel.text = String(describing: calc!.tipPercentage[newValue])
            defaults.set(newValue, forKey: "defaultTip")
            defaults.synchronize()
        }
    }
    
    var canRound: Bool {
        get {
            return defaults.bool(forKey: "canRound")
        }
        set {
            canRoundSwitch.isOn = newValue
            defaults.set(newValue, forKey: "canRound")
            delegate?.changedRoundOption(to: canRoundSwitch.isOn)
            defaults.synchronize()
        }
    }
 
    @IBAction func resetDefaults(_ sender: UIButton) {
        defaultTipIndex = 0
        canRound = false
        delegate?.reset()
    }
}
