//
//  ProfileViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/11/19.
//

import UIKit
import Toucan
import Firebase

class ProfileViewController: BaseViewController {
    
    var user: UserModel?
    let profileView = ProfileView()
    var editToggle = false

    var friends = [String]()
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    private var profileImage: UIImage?
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileView)
        self.profileView.editButton.isEnabled = false
        self.profileView.editButton.isHidden = true
        profileView.editButton.addTarget(self, action: #selector(editSetting), for: .touchUpInside)
        profileView.imageButton.addTarget(self, action: #selector(imageButtonPressed), for: .touchUpInside)
        profileView.addFriend.addTarget(self, action: #selector(addFriendPressed), for: .touchUpInside)
        fetchFriends()
        setupProfile()
    }

    private func setupProfile(){
        if let loggedUser = AppDelegate.authservice.getCurrentUser() {
            DBService.fetchUser(userId: loggedUser.uid) { (error, userModel) in
                if let error = error {
                    print(error)
                } else if let userModel = userModel {
                    if self.user == nil {
                        self.user = userModel
                    }
                    if userModel.userId == self.user!.userId {
                        self.profileView.editButton.isEnabled = true
                        self.profileView.editButton.isHidden = false
                        self.profileView.addFriend.isEnabled = false
                        self.profileView.addFriend.isHidden = true
                    } else {
                        self.profileView.editButton.isEnabled = false
                        self.profileView.editButton.isHidden = true
                    }
                    
                    if self.friends.contains(self.user!.userId) {
                        self.profileView.addFriend.isHidden = true
                        self.profileView.addFriend.isEnabled = false
                    }
                    self.profileView.displayNameTextView.text = self.user!.displayName
                    self.profileView.emailTextView.text = self.user!.email
                    self.profileView.firstNameTextView.text = self.user!.firstName
                    self.profileView.lastNameTextView.text = self.user!.lastName
                    self.profileView.phoneNumberTextView.text = self.user!.phoneNumber
                    if let image = self.user!.photoURL, !image.isEmpty {
                        self.profileView.imageButton.kf.setImage(with: URL(string: image), for: .normal)
                    }
                }
            }
        }
    }
    private func fetchFriends() {
        guard let user = authservice.getCurrentUser() else {
            print("Please log in")
            return
        }
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(FriendsCollectionKey.CollectionKey)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    self?.friends = snapshot.documents.map {
                        let dictionary =  $0.data() as? [String:String]
                        guard let key = dictionary?.keys.first else { return "" }
                        return key
                    }
                }
        }
    }
    @objc private func imageButtonPressed() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    @objc private func addFriendPressed() {
        DBService.addFriend(friend: self.user!) { (error) in
            if let error = error {
                self.showAlert(title: "Adding Friends Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Friend Added", message: nil)
                self.profileView.addFriend.isEnabled = false
                self.profileView.addFriend.isHidden = true
            }
        }
    }
    @objc private func editSetting() {
        if !editToggle {
            profileView.imageButton.isUserInteractionEnabled = true
            profileView.displayNameTextView.isEditable = true
            profileView.displayNameTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.emailTextView.isEditable = true
            profileView.emailTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.firstNameTextView.isEditable = true
            profileView.firstNameTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.lastNameTextView.isEditable = true
            profileView.lastNameTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.phoneNumberTextView.isEditable = true
            profileView.phoneNumberTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.editButton.setTitle("Save", for: .normal)
            editToggle = true
        } else {
            //Add save profile func
            saveProfile()
            profileView.imageButton.isUserInteractionEnabled = false
            profileView.displayNameTextView.isEditable = false
            profileView.displayNameTextView.backgroundColor = .white
            profileView.emailTextView.isEditable = false
            profileView.emailTextView.backgroundColor = .white
            profileView.firstNameTextView.isEditable = false
            profileView.firstNameTextView.backgroundColor = .white
            profileView.lastNameTextView.isEditable = false
            profileView.lastNameTextView.backgroundColor = .white
            profileView.phoneNumberTextView.isEditable = false
            profileView.phoneNumberTextView.backgroundColor = .white
            profileView.editButton.setTitle("Edit", for: .normal)
            editToggle = false
        }
    }
    private func saveProfile() {
        guard let firstName = profileView.firstNameTextView.text,
            !firstName.isEmpty,
            let lastName = profileView.lastNameTextView.text,
            !lastName.isEmpty,
            let displayName = profileView.displayNameTextView.text,
            !displayName.isEmpty,
            let email = profileView.emailTextView.text,
            !email.isEmpty,
            let phone = profileView.phoneNumberTextView.text,
            !phone.isEmpty,
            let user = AppDelegate.authservice.getCurrentUser(),
            let profileImageSave = profileView.imageButton.imageView?.image?.jpegData(compressionQuality: 1.0)
            else {
                showAlert(title: "Missing Fields", message: "Make sure all text fields are not empty!")
                return
        }
        StorageService.postImage(imageData: profileImageSave, imageName: Constants.ProfileImagePath + user.uid) { (error, imageURL) in
            if let error = error {
                self.showAlert(title: "Error Saving Photo", message: error.localizedDescription)
            } else if let imageURL = imageURL {
                // update auth user and user db document
                let request = user.createProfileChangeRequest()
                request.displayName = displayName
                request.photoURL = imageURL
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        self.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
                    }
                })
                DBService.firestoreDB
                    .collection(UsersCollectionKeys.CollectionKey)
                    .document(user.uid)
                    .updateData([UsersCollectionKeys.FirstNameKey : firstName,
                                 UsersCollectionKeys.LastNameKey : lastName,
                                 UsersCollectionKeys.DisplayNameKey : displayName,
                                 UsersCollectionKeys.EmailKey : email,
                                 UsersCollectionKeys.PhoneNumberKey : phone,
                                 UsersCollectionKeys.PhotoURLKey : imageURL.absoluteString
                    ]) { (error) in
                        if let error = error {
                            self.showAlert(title: "Editing Error", message: error.localizedDescription)
                        }
                }
                self.dismiss(animated: true)
            }
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image is nil")
            return
        }
        let resizedImage = Toucan.init(image: originalImage).resize(CGSize(width: 500, height: 500))
        profileImage = resizedImage.image
        profileView.imageButton.setImage(profileImage, for: .normal)
        dismiss(animated: true)
    }
}
