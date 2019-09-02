//
//  EmptyStateView.swift
//  FlockApp
//
//  Created by Yaz Burrell on 5/15/19.
//

import UIKit

class EmptyStateView: UIView {

//    lazy var emptyStateImage: CircularImageView = {
//        let image = CircularImageView(image: UIImage(named: "AppIcon"))
//        return image
//    }()
    
//    lazy var emptyStateMessage: UITextView = {
//        let text = UITextView()
//        text.text = "No upcoming events!"
//        return text
//    }()
    
    lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
//        label.text = "No Events available. To get started click the + to create your own."
        label.textColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.init(descriptor: UIFontDescriptor(name: "Helvetica nueue", size: 12), size: 20)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        setupLabel()
        
        
    }
    
//    func setupImage(){
//        addSubview(emptyStateImage)
//        emptyStateImage.translatesAutoresizingMaskIntoConstraints = false
//        emptyStateImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
//        emptyStateImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
//        emptyStateImage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4).isActive = true
//        emptyStateImage.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.3).isActive = true
//    }
    
//    func setupEmptyStateMessage(){
//        addSubview(emptyStateMessage)
//        emptyStateMessage.translatesAutoresizingMaskIntoConstraints = false
//        emptyStateMessage.centerYAnchor.constraint(equalTo: emptyStateImage.centerYAnchor, constant: 30).isActive = true
//        emptyStateMessage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
//        emptyStateMessage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
//
//    }
    
    func setupLabel() {
        addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyStateLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        emptyStateLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        
    }
}
