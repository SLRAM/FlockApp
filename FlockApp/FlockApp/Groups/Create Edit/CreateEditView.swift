//
//  CreateEditView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit
protocol CreateViewDelegate: AnyObject {
    func createPressed()
    func addressPressed()
}
class CreateEditView: UIView {
    
    weak var delegate: CreateViewDelegate?
    
    
    lazy var addressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Event Address", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(addressPressed), for: .touchUpInside)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10.0
        return button
    }()
    @objc func addressPressed() {
        delegate?.addressPressed()
        print("event address pressed")
        
    }
    
    public lazy var createButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Create", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createPressed))
        return button
    }()
    @objc func createPressed() {
        delegate?.createPressed()
    }
    
    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 10.0
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = #colorLiteral(red: 0.8529050946, green: 0.8478356004, blue: 0.8568023443, alpha: 0.4653253425).cgColor
        textView.textColor = .gray
        textView.textAlignment = .center
//        textView.font = textView.font?.withSize(20)
        textView.text = "Enter the Event Title"
        textView.tag = 0
        
        return textView
    }()
    lazy var firstQuizTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.textColor = .gray
        textView.text = "Enter first quiz fact"
        textView.tag = 1
        
        return textView
    }()
    lazy var secondQuizTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.textColor = .gray
        textView.text = "Enter second quiz fact"
        textView.tag = 2
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .white
        setupCollectionView()
    }
    
}
extension CreateEditView {
    func setupCollectionView() {
        setupTitleTextField()
        setupAddressButton()
//        setupFirstQuizTextField()
//        setupSecondTextField()
    }
    func setupTitleTextField() {
        addSubview(titleTextView)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        titleTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    func setupAddressButton() {
        addSubview(addressButton)
        addressButton.translatesAutoresizingMaskIntoConstraints = false
        addressButton.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10).isActive = true
        addressButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        addressButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        addressButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.07).isActive = true
    }
    func setupFirstQuizTextField() {
        addSubview(firstQuizTextView)
        firstQuizTextView.translatesAutoresizingMaskIntoConstraints = false
        firstQuizTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10).isActive = true
        firstQuizTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        firstQuizTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        firstQuizTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.20).isActive = true
    }
    func setupSecondTextField() {
        addSubview(secondQuizTextView)
        secondQuizTextView.translatesAutoresizingMaskIntoConstraints = false
        secondQuizTextView.topAnchor.constraint(equalTo: firstQuizTextView.bottomAnchor, constant: 10).isActive = true
        secondQuizTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        secondQuizTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        secondQuizTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.20).isActive = true
    }
}
