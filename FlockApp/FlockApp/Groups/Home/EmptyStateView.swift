//
//  EmptyStateView.swift
//  FlockApp
//
//  Created by Yaz Burrell on 5/15/19.
//

import UIKit

class EmptyStateView: UIView {

    lazy var emptyStateImage: CircularImageView = {
        let image = CircularImageView(image: UIImage(named: "AppIcon"))
        return image
    }()
    
    lazy var emptyStateMessage: UITextView = {
        let text = UITextView()
        text.text = "No upcoming events!"
        return text 
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
       setupImage()
       setupEmptyStateMessage()
        
    }
    
    func setupImage(){
        addSubview(emptyStateImage)
        emptyStateImage.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyStateImage.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        emptyStateImage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.4).isActive = true
        emptyStateImage.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    func setupEmptyStateMessage(){
        addSubview(emptyStateMessage)
        emptyStateMessage.translatesAutoresizingMaskIntoConstraints = false
        emptyStateMessage.centerYAnchor.constraint(equalTo: emptyStateImage.centerYAnchor, constant: 30).isActive = true
        emptyStateMessage.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyStateMessage.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        
    }
}
