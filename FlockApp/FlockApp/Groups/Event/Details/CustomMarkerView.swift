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
//    init(frame: CGRect, images: [URL], borderColor: UIColor, tag: Int) {
//        self.img = .url(image)
//        super.init(frame: frame)
//        self.borderColor = borderColor
//        self.tag = tag
//        setupViews()
//    }
//    init(frame: CGRect, images: [UIImage], borderColor: UIColor, tag: Int) {
//        self.img = .image(image)
//        super.init(frame: frame)
//        self.borderColor = borderColor
//        self.tag = tag
//        setupViews()
//    }
    
    func setupViews() {
        let markerImage = UIImageView()
        switch img {
        case .url(let url):
            markerImage.kf.setImage(with: url)

        case .image(let image):
            markerImage.image = image
        }
        markerImage.frame=CGRect(x: 0, y: 0, width: 50, height: 50)
        markerImage.layer.cornerRadius = 25
        markerImage.layer.borderColor = borderColor?.cgColor
        markerImage.layer.borderWidth = 4
        markerImage.backgroundColor = .white //remove to make image transparent
        markerImage.clipsToBounds = true
        let markerLabel = UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
        markerLabel.text = "▾"
        markerLabel.font = UIFont.systemFont(ofSize: 24)
        markerLabel.textColor = borderColor
        markerLabel.textAlignment = .center
        
        self.addSubview(markerImage)
        self.addSubview(markerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
