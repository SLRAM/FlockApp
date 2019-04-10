//
//  MenuLauncher.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import UIKit

class Menu: NSObject {
    let name: String
    let imageName: String
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
class MenuLauncher: NSObject {
    
    let backgroundView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    let cellId = "cellId"
    let menuList: [Menu] = {
        
        return[Menu(name: "Flock", imageName: ""),
               Menu(name: "Events", imageName: "calendar"),
               Menu(name: "Profile", imageName: "profile"),
               Menu(name: "Friends", imageName: "friends"),
               Menu(name: "", imageName: ""),
               Menu(name: "", imageName: ""),
               Menu(name: "", imageName: ""),
               Menu(name: "", imageName: ""),
               Menu(name: "", imageName: ""),
               Menu(name: "", imageName: ""),
               Menu(name: "", imageName: ""),
               Menu(name: "", imageName: ""),
               Menu(name: "Settings", imageName: "settings"),
               Menu(name: "Sign Out", imageName: "signout2")]
    }()
    var baseVC: BaseViewController?
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                showMenu()
            default:
                break
            }
        }
    }
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(backgroundView)
            window.addSubview(collectionView)
            
            backgroundView.frame = window.frame
            backgroundView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.backgroundView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: window.frame.width/2.5, height: window.frame.height)
            }
        }
    }
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }
    }
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
}
extension MenuLauncher: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCollectionViewCell
        let menus = menuList[indexPath.item]
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(patternImage: UIImage(named: "flock")!)
        }
        cell.menu = menus
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = menuList[indexPath.item]
        handleDismiss()
        baseVC?.showViewController(keyword: selectedItem.name)
    }
    
}
