//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Heli Bavishi on 11/9/20.
//

import UIKit

//STEP 1- Declare Protocol
protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(for cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    var alarm: Alarm? {
    didSet {
        layoutIfNeeded()
        updateViews()
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // STEP 2 - create delegate property
    weak var delegate: SwitchTableViewCellDelegate?
    
    @IBAction func switchValueChanged(_ sender: Any) {
    //STEP 3 - call protocol in action
        
        guard let switchDelegate = delegate else { return }
            switchDelegate.switchCellSwitchValueChanged(for: self)
    }
    
    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
}
