//
//  DateViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import UIKit
import UserNotifications

class DateViewController: UIViewController {
    let dateView = DateView()
    var event: Event?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dateView)
        navigationItem.rightBarButtonItem = dateView.okayButton
        navigationItem.leftBarButtonItem = dateView.cancelButton
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
        let startContent = UNMutableNotificationContent()
        
        startContent.title = NSString.localizedUserNotificationString(forKey: "Testing Beginning", arguments: nil)
        startContent.body = NSString.localizedUserNotificationString(forKey: "Event Starting", arguments: nil)
        startContent.sound = UNNotificationSound.default
        
        let endContent = UNMutableNotificationContent()
        endContent.title = NSString.localizedUserNotificationString(forKey: "Testing end", arguments: nil)
        endContent.body = NSString.localizedUserNotificationString(forKey: "Event Ending", arguments: nil)
        endContent.sound = UNNotificationSound.default
        
        let startDate = startDatePicker.date
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: startDate)
        let startMinutes = calendar.component(.minute, from: startDate)
        
        let endDate = endDatePicker.date
        let endHour = calendar.component(.hour, from: endDate)
        let endMinutes = calendar.component(.minute, from: endDate)

        var startDateComponent = DateComponents()
        startDateComponent.hour = startHour
        startDateComponent.minute = startMinutes
        startDateComponent.timeZone = TimeZone.current
        var endDateComponent = DateComponents()
        endDateComponent.hour = endHour
        endDateComponent.minute = endMinutes
        endDateComponent.timeZone = TimeZone.current

        let startTrigger = UNCalendarNotificationTrigger(dateMatching: startDateComponent, repeats: false)
        let endTrigger = UNCalendarNotificationTrigger(dateMatching: endDateComponent, repeats: false)

        let startRequest = UNNotificationRequest(identifier: "Event Start", content: startContent, trigger: startTrigger)
        let endRequest = UNNotificationRequest(identifier: "Event End", content: endContent, trigger: endTrigger)
        
        UNUserNotificationCenter.current().add(startRequest) { (error) in
            if let error = error {
                print("notification delivery error: \(error)")
            } else {
                print("successfully added start notification")
            }
        }
        UNUserNotificationCenter.current().add(endRequest) { (error) in
            if let error = error {
                print("notification delivery error: \(error)")
            } else {
                print("successfully added end notification")
            }
        }
        showAlert(title: "Reminder set", message: nil)
    }
    func cancelPressed() {
        dismiss(animated: true)
    }
}
