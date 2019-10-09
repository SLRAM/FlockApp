//
//  CreateEditTableViewCell.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/9/19.
//

import UIKit

protocol CreateEditTableViewCellDelegate: AnyObject {
    func textDelegate()
}

class CreateEditTableViewCell: UITableViewCell {
    weak var delegate: CreateEditTableViewCellDelegate?

    lazy var friendName: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var friendTask: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a task"
        tf.delegate = self
        return tf
    }()
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension CreateEditTableViewCell {
    func setConstraints() {
        
        setNameLabel()
        setTaskField()
        
        
    }
    func setNameLabel() {
        self.addSubview(friendName)
        friendName.translatesAutoresizingMaskIntoConstraints = false
        friendName.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        friendName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        friendName.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        friendName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
    }
    func setTaskField() {
        self.addSubview(friendTask)
        friendTask.translatesAutoresizingMaskIntoConstraints = false
        friendTask.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        friendTask.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        friendTask.topAnchor.constraint(equalTo: topAnchor).isActive = true
        friendTask.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    
    
}
extension CreateEditTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textDelegate()
        textField.resignFirstResponder()
        return true
    }
}
