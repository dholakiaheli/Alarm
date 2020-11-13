//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Heli Bavishi on 11/9/20.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.shared.loadFromPersistance()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.shared.alarms.count
//        return AlarmController.shared.mockAlarms.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell()}

        cell.alarm = AlarmController.shared.alarms[indexPath.row]
//        cell.alarm = AlarmController.shared.mockAlarms[indexPath.row]
        //cell.updateViews()
        
        //STEP 5 - set cell delegate
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let alarmToDelete = AlarmController.shared.alarms[indexPath.row]

//            let alarmToDelete = AlarmController.shared.mockAlarms[indexPath.row]

            AlarmController.shared.deleteAlarm(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //IIDOO
        //Identifier
        if segue.identifier == "toDetailVC" {
            //Index //Destination
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? AlarmDetailTableViewController else { return }
                //Object to Send
            let alarm = AlarmController.shared.alarms[indexPath.row]
            // Object to recieve
            destination.alarm = alarm
            
        }
    }
}// END of class

//STEP 4 - create extension on class
extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(for cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleEnabled(for: alarm)
        tableView.reloadData()
    }
}
