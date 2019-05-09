//
//  CustomMarkerView.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 5/6/19.
//

import Foundation
import UIKit

enum ImageType {
    case url(URL)
    case image(UIImage)
}

class CustomMarkerView: UIView {
    var img: ImageType
    var borderColor: UIColor!
    
    init(frame: CGRect, image: URL, borderColor: UIColor, tag: Int) {
        self.img = .url(image)
        super.init(frame: frame)
        self.borderColor = borderColor
        self.tag = tag
        setupViews()
    }
    init(frame: CGRect, image: UIImage, borderColor: UIColor, tag: Int) {
        self.img = .image(image)
        super.init(frame: frame)
        self.borderColor = borderColor
        self.tag = tag
        setupViews()
    }
    
    func setupViews() {
        let imgView = UIImageView()
        switch img {
        case .url(let url):
            imgView.kf.setImage(with: url)

        case .image(let image):
            imgView.image = image
        }
        imgView.frame=CGRect(x: 0, y: 0, width: 50, height: 50)
        imgView.layer.cornerRadius = 25
        imgView.layer.borderColor = borderColor?.cgColor
        imgView.layer.borderWidth = 4
        imgView.clipsToBounds = true
        let lbl=UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
        lbl.text = "▾"
        lbl.font=UIFont.systemFont(ofSize: 24)
        lbl.textColor = borderColor
        lbl.textAlignment = .center
        
        self.addSubview(imgView)
        self.addSubview(lbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
