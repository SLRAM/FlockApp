//
//  DateView.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import UIKit

protocol ReminderButtonsDelegates: AnyObject {
    func okayPressed(startDatePicker: UIDatePicker, endDatePicker: UIDatePicker)
    func cancelPressed()
}

class DateView: UIView {
    
    let today = Date()
    
    lazy var startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = NSCalendar.current.date(byAdding: .year, value: 0, to: today)
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = Date()
        datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        return datePicker
    }()
    
    lazy var endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = NSCalendar.current.date(byAdding: .day, value: 0, to: today)
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = Date()
        datePicker.setValue(UIColor.black, forKeyPath: "textColor")
        return datePicker
    }()
    lazy var viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Event Date Setting"
        label.textAlignment = .center
        return label
    }()
    lazy var startLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Event Start Date"
        label.textAlignment = .center
        return label
    }()
    lazy var endLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Event End Date"
        label.textAlignment = .center
        return label
    }()
    public lazy var okayButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Okay", style: UIBarButtonItem.Style.plain, target: self, action: #selector(okayButtonPressed))
        return button
    }()
    
    public lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonPressed))
        return button
    }()
    
    weak var delegate: ReminderButtonsDelegates?

    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .white
        setupViewLabel()
        setupStartLabel()
        setupStartDatePicker()
        setupEndLabel()
        setupEndDatePicker()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewLabel() {
        addSubview(viewLabel)
        viewLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            viewLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            viewLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            viewLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    func setupStartLabel() {
        addSubview(startLabel)
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startLabel.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 15),
            startLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    func setupStartDatePicker() {
        addSubview(startDatePicker)
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startDatePicker.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 8),
            startDatePicker.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startDatePicker.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startDatePicker.heightAnchor.constraint(equalToConstant: 300)
            ])
    }
    func setupEndLabel() {
        addSubview(endLabel)
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endLabel.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 20),
            endLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            endLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            endLabel.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    func setupEndDatePicker() {
        addSubview(endDatePicker)
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endDatePicker.topAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 8),
            endDatePicker.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            endDatePicker.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            endDatePicker.heightAnchor.constraint(equalToConstant: 300)
            ])
    }
    
    @objc func okayButtonPressed() {
        delegate?.okayPressed(startDatePicker: startDatePicker, endDatePicker: endDatePicker)
    }
    
    @objc func cancelButtonPressed() {
        delegate?.cancelPressed()
    }
}
