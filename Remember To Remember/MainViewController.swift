//
//  ViewController.swift
//  Remember To Remember
//
//  Created by Daniel Lumbu on 8/15/24.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController, AddScreenViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var remindersArray: [Reminders] = [Reminders(header: "yeah", body: "whow")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName:  "ReminderCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
 

    }
    // Used this method in viewcontroller lifecycle to be able to load the safe area
    override func viewDidLayoutSubviews() {
        let swiftUIView = DatePickerCalendar()
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        let calenderLocation = CGRect(x: 0, y: view.safeAreaInsets.top + 20, width: view.frame.size.width, height: 120.0)
        hostingController.view.frame = calenderLocation
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)  // hosting swiftui in Uikit
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddScreen"){
            let destination = segue.destination as! AddScreenViewController
            destination.delegate = self
            destination.remindersArrayAddScreen = remindersArray
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "AddScreen", sender: self)
            
    }
    func didDismissWithAction() {
        self.tableView.reloadData()
        
          // Your code here
      }
    func didDismissWithData(data:[Reminders]) {
        remindersArray = data
     }

}


extension MainViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ReminderCell
        cell.header.text = remindersArray[indexPath.row].header
        cell.body.text = remindersArray[indexPath.row].body
        
        return cell
    }
    
    
}
