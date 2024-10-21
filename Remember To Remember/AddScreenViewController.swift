//
//  AddScreenViewController.swift
//  Remember To Remember
//
//  Created by Daniel Lumbu on 9/5/24.
//

import UIKit
import SwiftUI
import Combine


protocol AddScreenViewControllerDelegate: AnyObject {
    func didDismissWithAction()
    func didDismissWithData(data:  [Reminders])
}

class AddScreenViewController: UIViewController {
    var cancellable: AnyCancellable?
    @Published var selectedDate = Date()
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var timeButton1: UIButton!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var timeButton2: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var remindersArrayAddScreen: [Reminders] = []
    weak var delegate: AddScreenViewControllerDelegate?
    @IBOutlet weak var dateLabel: UILabel!
    let startDateLabel = UILabel()
    let endDateLabel = UILabel()
    @IBOutlet weak var titleTextBar: UITextField!
    @IBOutlet weak var detailsTextbar: UITextField!
    
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeTextLabel: UILabel!
    var subViewHostingController: UIHostingController<DatePickerGrid>?
    var hostingController: UIHostingController<FormattedDate>?
    let scrollView = UIScrollView()
    let contentView = UIView()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextBar.delegate = self
        detailsTextbar.delegate = self
        setupUI()

    }
    
    
    

    
    @IBAction func dateButtonPressed(_ sender: UIButton) {
        print(selectedDate)
        timeButton2.isHidden = !timeButton2.isHidden
        timeButton1.isHidden = !timeButton1.isHidden
        if let subView = subViewHostingController?.view {
            UIView.animate(withDuration: 0.3, animations: {
                subView.isHidden = !subView.isHidden
                
                
            })
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.remindersArrayAddScreen.append(Reminders(header: titleTextBar.text!, body: detailsTextbar.text!))
        delegate?.didDismissWithData(data: remindersArrayAddScreen)
        delegate?.didDismissWithAction()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchSelected(_ sender: UISwitch) {
        UIView.animate(withDuration: 0.3, animations: {
            self.dateButton.isHidden = !self.dateButton.isHidden
            self.startDateButton.isHidden = !self.startDateButton.isHidden
            self.endDateButton.isHidden = !self.endDateButton.isHidden
            self.view.layoutIfNeeded() // Ensures the layout updates with the animation
            
        })
    }
    
    private func setupScrollview() {
        view.bringSubviewToFront(titleTextBar)
        view.bringSubviewToFront(detailsTextbar)
        view.bringSubviewToFront(saveButton)
        view.bringSubviewToFront(switchButton)
        view.bringSubviewToFront(dateButton)
    }
        
    func setupUI() {
        startDateButton.isHidden = true
        endDateButton.isHidden = true
        timeButton2.isHidden = true
        // Initialize the SwiftUI SubView
        // Create the binding for selectedDate
        let gridCalenderView = DatePickerGrid(selectedDate: Binding(
            get: { self.selectedDate },  // Get from UIKit's selectedDate
            set: { newDate in             // Set from SwiftUI changes
                self.selectedDate = newDate
                self.timeTextLabel.text = newDate.formatted()
            }
        ))
        
        // Embed the SwiftUI view in a UIHostingController
        subViewHostingController = UIHostingController(rootView: gridCalenderView)
        
        // Add the UIHostingController's view to the UIKit view hierarchy
        if let subView = subViewHostingController?.view {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
            
            // Set up constraints for the SwiftUI subview
            NSLayoutConstraint.activate([
                subView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subView.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 5),
                subView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            ])
            
            // Initially hide the SwiftUI subview
            subView.isHidden = true
        }
        // Initially hide the start and end date labels
        
    }
    
    override func viewDidLayoutSubviews() {
            // Check if the hostingController is already created and added to the view
            if hostingController == nil {
                var swiftUIView = FormattedDate(selectedDate: selectedDate)
                let labelPosition = timeTextLabel.frame.origin
                let calenderLocation = CGRect(x: labelPosition.x, y: labelPosition.y + 430, width: view.frame.size.width / 2, height: 45)
                cancellable = $selectedDate.sink { newValue in
                    print("yes just once \(newValue)")
                    swiftUIView = FormattedDate(selectedDate: newValue,backgroundColor: .clear)
                    self.hostingController = UIHostingController(rootView: swiftUIView)
                    
                    guard let hostingController = self.hostingController else { return }
                    
                    self.addChild(hostingController)

                    hostingController.view.frame = calenderLocation
                    self.view.addSubview(hostingController.view)
                    hostingController.didMove(toParent: self)
                     // Do something when myVariable changes
                 }
    
        }
    }
    
}

extension AddScreenViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        titleTextBar.endEditing(true)
        detailsTextbar.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if titleTextBar.text == "" {
           titleTextBar.text = "Task 1"
           return true
        }else{
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            
        
    }
}
