//
//  ProfileViewController.swift
//  FlockApp
//
//  Created by Biron Su on 4/11/19.
//

import UIKit
import Toucan
import Firebase

class ProfileViewController: UIViewController {
    
    var user: UserModel?
    let profileView = ProfileView()
    var editToggle = false

    var friends = [String]()
    var blockedUsers = [String]()
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
        self.title = "Profile"
        profileView.firstNameTextView.delegate = self
        profileView.lastNameTextView.delegate = self
        profileView.emailTextView.delegate = self
        profileView.phoneNumberTextView.delegate = self
        profileView.editButton.addTarget(self, action: #selector(editSetting), for: .touchUpInside)
        profileView.imageButton.addTarget(self, action: #selector(imageButtonPressed), for: .touchUpInside)
        profileView.signOutButton.addTarget(self, action: #selector(signOutPressed), for: .touchUpInside)
        setupProfile()
        fetchFriends()
        checkBlockedUser()
        checkBlockedStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
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
                    if userModel.userId != self.user!.userId {
                        self.profileView.editButton.isEnabled = false
                        self.profileView.editButton.isHidden = true
                        self.profileView.addFriend.isHidden = false
                        self.profileView.addFriend.isEnabled = true
                        self.profileView.signOutButton.isEnabled = false
                        self.profileView.signOutButton.isHidden = true
                    }
                    
                    if self.friends.contains(self.user!.userId) {
                        self.profileView.addFriend.removeTarget(self, action: #selector(self.addFriendPressed), for: .touchUpInside)
                        self.profileView.addFriend.addTarget(self, action: #selector(self.removeFriendPressed), for: .touchUpInside)
                        self.profileView.addFriend.setTitle(" Remove Friend ", for: .normal)
                    } else {
                        self.profileView.addFriend.removeTarget(self, action: #selector(self.removeFriendPressed), for: .touchUpInside)
                        self.profileView.addFriend.addTarget(self, action: #selector(self.addFriendPressed), for: .touchUpInside)
                        self.profileView.addFriend.setTitle(" Add Friend ", for: .normal)
                    }
                }
            }
        }
    }
    private func checkBlockedUser() {
        guard let loggedUser = authservice.getCurrentUser() else {
            print("Please log in")
            return
        }
        guard let user = user else {return}
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(loggedUser.uid)
            .collection(FriendsCollectionKey.BlockedKey)
            .addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print("failed to check blocked user: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    self.blockedUsers = snapshot.documents.map {
                        $0.documentID
                    }
                    if self.blockedUsers.contains(user.userId) {
                        self.profileView.blockButton.removeTarget(self, action: #selector(self.blockUser), for: .touchUpInside)
                        self.profileView.blockButton.addTarget(self, action: #selector(self.unblockUser), for: .touchUpInside)
                        self.profileView.blockButton.setTitle(" Unblock User ", for: .normal)
                    } else {
                        self.profileView.blockButton.removeTarget(self, action: #selector(self.unblockUser), for: .touchUpInside)
                        self.profileView.blockButton.addTarget(self, action: #selector(self.blockUser), for: .touchUpInside)
                        self.profileView.blockButton.setTitle(" Block User ", for: .normal)
                    }
                }
            })
    }
    private func checkBlockedStatus() {
        guard let loggedUser = authservice.getCurrentUser() else {
            print("Please log in")
            return
        }
        guard let user = user else {return}
        listener = DBService.firestoreDB
            .collection(UsersCollectionKeys.CollectionKey)
            .document(user.userId)
            .collection(FriendsCollectionKey.BlockedKey)
            .whereField("blocked", isEqualTo: loggedUser.uid)
            .addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print("failed to check blocked status: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    let _ = snapshot.documents.map {
                        if $0.documentID == loggedUser.uid {
                            self.profileView.addFriend.isEnabled = false
                            self.profileView.addFriend.isUserInteractionEnabled = false
                            self.profileView.emailTextView.isHidden = true
                            self.profileView.firstNameTextView.isHidden = true
                            self.profileView.lastNameTextView.isHidden = true
                            self.showAlert(title: "Blocked by User", message: "You are unable to view \(self.user!.displayName)'s profile.")
                        }
                    }
                }
            })
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
                        $0.documentID
                    }
                }
        }
    }
    @objc private func imageButtonPressed() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    @objc private func addFriendPressed() {
        DBService.requestFriend(friend: self.user!) { (error) in
            if let error = error {
                self.showAlert(title: "Friend Request Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Friend Requested", message: nil)
            }
        }
    }
    @objc private func removeFriendPressed() {
        DBService.removeFriend(removed: self.user!) { (error) in
            if let error = error {
                self.showAlert(title: "Friend Remove Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Friend Successfully Removed", message: nil)
            }
        }
    }
    @objc private func signOutPressed() {
        authservice.signOutAccount()
        showLoginView()
    }
    @objc private func blockUser() {
        DBService.blockedUser(blocked: self.user!) { (error) in
            if let error = error {
                self.showAlert(title: "Block error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Blocked \(self.user!.displayName)", message: "Successfully added \(self.user!.displayName) to your blocked list")
            }
        }
    }
    @objc private func unblockUser() {
        DBService.unblockedUser(blocked: self.user!) { (error) in
            if let error = error {
                self.showAlert(title: "Unblock Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Unblocked \(self.user!.displayName)", message: "Successfully unblocked \(self.user!.displayName)")
            }
        }
    }
    @objc private func editSetting() {
        if !editToggle {
            profileView.imageButton.isUserInteractionEnabled = true
            profileView.displayNameTextView.isEditable = true
            profileView.displayNameTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//            profileView.emailTextView.isEditable = true
//            profileView.emailTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.firstNameTextView.text = user!.firstName
            profileView.firstNameTextView.isEditable = true
            profileView.firstNameTextView.isHidden = false
            profileView.firstNameTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            profileView.lastNameTextView.text = user!.lastName
            profileView.lastNameTextView.isEditable = true
            profileView.lastNameTextView.isHidden = false
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
            profileView.displayNameTextView.backgroundColor = UIColor.init(red: 151/255, green: 6/255, blue: 188/255, alpha: 1)
            profileView.fullNameTextView.isEditable = false
            profileView.fullNameTextView.isHidden = false
//            profileView.emailTextView.isEditable = false
//            profileView.emailTextView.backgroundColor = .white
            profileView.firstNameTextView.isEditable = false
            profileView.firstNameTextView.isHidden = true
            profileView.firstNameTextView.backgroundColor = .white
            profileView.lastNameTextView.isEditable = false
            profileView.lastNameTextView.isHidden = true
            profileView.lastNameTextView.backgroundColor = .white
            profileView.phoneNumberTextView.isEditable = false
            profileView.phoneNumberTextView.backgroundColor = .clear
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
//                self.dismiss(animated: true)
            }
        }
        self.profileView.fullNameTextView.text = profileView.firstNameTextView.text + " " + profileView.lastNameTextView.text
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

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
