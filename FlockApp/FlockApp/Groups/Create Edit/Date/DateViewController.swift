//
//  DateViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import UIKit
import UserNotifications

protocol DateViewControllerDelegate: AnyObject {
    func selectedDate(startDate: Date, endDate: Date)
}

class DateViewController: UIViewController {
    
    weak var delegate: DateViewControllerDelegate?
    let dateView = DateView()
    var event: Event?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Dates"

        view.addSubview(dateView)
        navigationItem.rightBarButtonItem = dateView.okayButton
//        navigationItem.leftBarButtonItem = dateView.cancelButton
        dateView.delegate = self
        dateView.startDatePicker.addTarget(self, action: #selector(startDatePickerValue), for: .valueChanged)
        dateView.endDatePicker.addTarget(self, action: #selector(endDatePickerValue), for: .valueChanged)
    }
    @objc func startDatePickerValue() {
        dateView.endDatePicker.minimumDate = NSCalendar.current.date(byAdding: .minute, value: 1, to: dateView.startDatePicker.date)
    }
    @objc func endDatePickerValue() {
    }
}
extension DateViewController: ReminderButtonsDelegates {
    func okayPressed(startDatePicker: UIDatePicker, endDatePicker: UIDatePicker) {

        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        let alertController = UIAlertController(title: "Date has been set for the event.", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
           
            self.delegate?.selectedDate(startDate: startDate, endDate: endDate)
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
