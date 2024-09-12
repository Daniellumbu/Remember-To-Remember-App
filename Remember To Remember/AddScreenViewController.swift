//
//  AddScreenViewController.swift
//  Remember To Remember
//
//  Created by Daniel Lumbu on 9/5/24.
//

import UIKit
import SwiftUI


protocol AddScreenViewControllerDelegate: AnyObject {
    func didDismissWithAction()
    func didDismissWithData(data:  [Reminders])
}

class AddScreenViewController: UIViewController {
    @IBOutlet weak var switchButton: UISwitch!
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
    var subViewHostingController: UIHostingController<DatePickerGrid>?
    let scrollView = UIScrollView()
    let contentView = UIView()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextBar.delegate = self
        detailsTextbar.delegate = self
        setupUI()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Constraints for contentView inside scrollView
        // Constraints for contentView inside scrollView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // This is important to define the content size
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000)// Set a larger height to make it scrollable
        ])
        contentView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true
        scrollView.isUserInteractionEnabled = true
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        view.bringSubviewToFront(titleTextBar)
        view.bringSubviewToFront(detailsTextbar)
        view.bringSubviewToFront(saveButton)
        view.bringSubviewToFront(switchButton)


        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let swiftUIView = FormattedDate(selectedDate: Date())
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        let labelPosition = dateLabel.frame.origin
        let calenderLocation = CGRect(x:labelPosition.x, y: labelPosition.y, width: view.frame.size.width/3, height: 50)
        hostingController.view.frame = calenderLocation
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)  // hosting swiftui in Uikit
    }
    
    @IBAction func dateButtonPressed(_ sender: UIButton) {
        if let subView = subViewHostingController?.view {
            UIView.animate(withDuration: 0.3, animations: {
                subView.isHidden = !subView.isHidden
                
            })
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //        if textFieldShouldEndEditing(<#UITextField#>) == false {
        //            return
        //        }
        
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
    
    func setupUI() {
        startDateButton.isHidden = true
        endDateButton.isHidden = true
        // Initialize the SwiftUI SubView
        let gridCalenderView = DatePickerGrid()
        
        // Embed the SwiftUI view in a UIHostingController
        subViewHostingController = UIHostingController(rootView: gridCalenderView)
        
        // Add the UIHostingController's view to the UIKit view hierarchy
        if let subView = subViewHostingController?.view {
            subView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subView)
            
            // Set up constraints for the SwiftUI subview
            NSLayoutConstraint.activate([
                subView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subView.topAnchor.constraint(equalTo: startDateButton.bottomAnchor, constant: 20),
                subView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            ])
            
            // Initially hide the SwiftUI subview
            subView.isHidden = true
        }
        // Initially hide the start and end date labels
        
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
