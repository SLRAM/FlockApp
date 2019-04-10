//
//  MenuCollectionViewCell.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    var menu: Menu? {
        didSet {
            menuLabel.text = menu?.name
            if let imageName = menu?.imageName {
                iconImageView.image = UIImage(named: imageName)
            }
        }
    }
    let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "Menu"
        return label
    }()
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addMenuLabel()
        addImageView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) failed to implement")
    }
    
    private func addMenuLabel() {
        addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 50),
            menuLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            menuLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            menuLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
    }
    private func addImageView() {
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: menuLabel.leadingAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
}
