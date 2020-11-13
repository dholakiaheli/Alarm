//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Heli Bavishi on 11/9/20.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    //MARK: - Properties
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
            }
        }
    
    var alarmIsOn: Bool = true
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    // MARK: - Table view data source

    @IBAction func enableButtonTapped(_ sender: Any) {
        alarmIsOn.toggle()
        button.setTitle(alarmIsOn ? "On" : "Off", for: .normal)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {

        guard let text = textField.text else { return }
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: datePicker.date, name: text, enabled: alarmIsOn)
        } else {
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: text, enabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
            guard let alarm = alarm
                   else { return }
        datePicker.date = alarm.fireDate
        textField.text = alarm.name
        alarmIsOn = alarm.enabled
        button.setTitle(alarmIsOn ? "On" : "Off", for: .normal)
    }
}
