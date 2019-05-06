//
//  CustomSegmentControl.swift
//  FlockApp
//
//  Created by Yaz Burrell on 5/6/19.
//

import UIKit

@IBDesignable
class customSegmentedControl: UIView {
    
    var buttons = [UIButton]()
    
    var borderWidth: CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable
    var borderColor = UIColor.clear {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.height/2
    }
    
}
