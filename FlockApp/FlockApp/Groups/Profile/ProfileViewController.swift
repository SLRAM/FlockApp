//
//  ProfileViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/11/19.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    var user: UserModel?
    let profileView = ProfileView()
    var editToggle = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileView)
        profileView.editButton.addTarget(self, action: #selector(editSetting), for: .touchUpInside)
        setupProfile()
    }

    private func setupProfile(){
        if let currentUser = AppDelegate.authservice.getCurrentUser() {
            DBService.fetchUser(userId: currentUser.uid) { (error, userModel) in
                if let error = error {
                    print(error)
                } else if let userModel = userModel{
                    self.user = userModel
                    if currentUser.email == self.user!.email {
                        self.profileView.editButton.isEnabled = true
                        self.profileView.editButton.isHidden = false
                    } else {
                        self.profileView.editButton.isEnabled = false
                        self.profileView.editButton.isHidden = true
                    }
                    self.profileView.displayNameLabel.text = self.user!.displayName
                    self.profileView.emailTextView.text = self.user!.email
                    self.profileView.fullNameTextView.text = self.user!.fullName
                }
            }
        }
    }
    @objc private func editSetting() {
        if !editToggle {
            profileView.imageButton.isUserInteractionEnabled = true
            profileView.emailTextView.isEditable = true
            profileView.emailTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.firstNameTextView.isEditable = true
            profileView.firstNameTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.lastNameTextView.isEditable = true
            profileView.lastNameTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.phoneNumberTextView.isEditable = true
            profileView.phoneNumberTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.bioTextView.isEditable = true
            profileView.bioTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.editButton.setTitle("Save", for: .normal)
            editToggle = true
        } else {
            //Add save profile func
//            saveProfile()
            profileView.imageButton.isUserInteractionEnabled = false
            profileView.emailTextView.isEditable = false
            profileView.emailTextView.backgroundColor = .white
            profileView.firstNameTextView.isEditable = false
            profileView.firstNameTextView.backgroundColor = .white
            profileView.lastNameTextView.isEditable = false
            profileView.lastNameTextView.backgroundColor = .white
            profileView.phoneNumberTextView.isEditable = false
            profileView.phoneNumberTextView.backgroundColor = .white
            profileView.bioTextView.isEditable = false
            profileView.bioTextView.backgroundColor = .white
            profileView.editButton.setTitle("Edit", for: .normal)
            editToggle = false
        }
    }
//    private func saveProfile() {
//        guard let firstName = firstNameTextView.text,
//            !firstName.isEmpty,
//            firstName != placeHolderText,
//            let lastName = lastNameTextView.text,
//            !lastName.isEmpty,
//            lastName != placeHolderText,
//            let userName = userNameTextView.text?.replacingOccurrences(of: "@", with: ""),
//            !userName.isEmpty,
//            userName != placeHolderText,
//            let bio = bioTextView.text,
//            !bio.isEmpty,
//            bio != placeHolderText,
//            let user = authservice.getCurrentUser(),
//            let coverImageSave = editProfileCoverImage.imageView?.image?.jpegData(compressionQuality: 1.0),
//            let profileImageSave = editProfileImage.imageView?.image?.jpegData(compressionQuality: 1.0)
//            else {
//                showAlert(title: "Missing Fields", message: "Make sure all text fields are not empty!")
//                return
//        }
//        StorageService.postImage(imageData: profileImageSave, imageName: Constants.ProfileImagePath + user.uid) { (error, imageURL) in
//            if let error = error {
//                self.showAlert(title: "Error Saving Photo", message: error.localizedDescription)
//            } else if let imageURL = imageURL {
//                // update auth user and user db document
//                let request = user.createProfileChangeRequest()
//                request.displayName = userName
//                request.photoURL = imageURL
//                request.commitChanges(completion: { (error) in
//                    if let error = error {
//                        self.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
//                    }
//                })
//                StorageService.postImage(imageData: coverImageSave, imageName: Constants.CoverImagePath + user.uid, completion: { (error, coverURL) in
//                    if let error = error {
//                        self.showAlert(title: "Error Saving Cover Photo", message: error.localizedDescription)
//                    } else if let coverURL = coverURL {
//                        DBService.firestoreDB
//                            .collection(BloggersCollectionKeys.CollectionKey)
//                            .document(user.uid)
//                            .updateData([BloggersCollectionKeys.CoverImageURLKey : coverURL.absoluteString]) { (error) in
//                                if let error = error {
//                                    self.showAlert(title: "Cover Saving Error", message: error.localizedDescription)
//                                }
//                        }
//                    }
//                })
//                DBService.firestoreDB
//                    .collection(BloggersCollectionKeys.CollectionKey)
//                    .document(user.uid)
//                    .updateData([BloggersCollectionKeys.FirstNameKey : firstName,
//                                 BloggersCollectionKeys.LastNameKey : lastName,
//                                 BloggersCollectionKeys.BioKey : bio,
//                                 BloggersCollectionKeys.DisplayNameKey : userName,
//                                 BloggersCollectionKeys.PhotoURLKey : imageURL.absoluteString
//                    ]) { (error) in
//                        if let error = error {
//                            self.showAlert(title: "Editing Error", message: error.localizedDescription)
//                        }
//                }
//                self.dismiss(animated: true)
//            }
//        }
//    }
}
