//
//  DBService+Invited.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/15/19.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct InvitedCollectionKeys {
    static let CollectionKey = "invited"
    static let UserIdKey = "userId"
    static let DisplayNameKey = "displayName"
    static let FirstNameKey = "firstName"
    static let LastNameKey = "lastName"
    static let PhotoURLKey = "photoURL"
    static let LatitudeKey = "latitude"
    static let LongitudeKey = "longitude"
    static let TaskKey = "task"
    static let ConfirmationKey = "confirmation"
}

extension DBService {
    static public func addInvited(user: User, docRef: String, friends: [UserModel], tasks: Dictionary<Int,String>, completion: @escaping (Error?) -> Void)  {
        
        fetchUser(userId: user.uid) { (error, currentUser) in
            if let error = error {
                print("failed to fetch friends with error: \(error.localizedDescription)")
            } else if let currentUser = currentUser {
                firestoreDB.collection(EventsCollectionKeys.CollectionKey).document(docRef).collection(InvitedCollectionKeys.CollectionKey).document(user.uid).setData([
                    InvitedCollectionKeys.UserIdKey         : currentUser.userId,
                    InvitedCollectionKeys.DisplayNameKey    : currentUser.displayName,
                    InvitedCollectionKeys.FirstNameKey      : currentUser.firstName ?? "",
                    InvitedCollectionKeys.LastNameKey       : currentUser.lastName ?? "",
                    InvitedCollectionKeys.PhotoURLKey       : currentUser.photoURL ?? "",
                    InvitedCollectionKeys.LatitudeKey       : -1.0,
                    InvitedCollectionKeys.LongitudeKey      : -1.0,
                    InvitedCollectionKeys.ConfirmationKey   : true,
                    InvitedCollectionKeys.TaskKey           : "Host"
                    ])
                { (error) in
                    if let error = error {
                        print("adding friends error: \(error)")
                        completion(error)
                    } else {
                        print("friends added successfully to ref: \(currentUser.userId)")
                        completion(nil)
                    }
                }
                
            }
        }
        for (keyFriend,valueFriend) in friends.enumerated() {
            for (key,value) in tasks {
                if keyFriend == key {
                    firestoreDB.collection(EventsCollectionKeys.CollectionKey).document(docRef).collection(InvitedCollectionKeys.CollectionKey).document(valueFriend.userId).setData([
                        InvitedCollectionKeys.UserIdKey         : valueFriend.userId,
                        InvitedCollectionKeys.DisplayNameKey    : valueFriend.displayName,
                        InvitedCollectionKeys.FirstNameKey      : valueFriend.firstName,
                        InvitedCollectionKeys.LastNameKey       : valueFriend.lastName,
                        InvitedCollectionKeys.PhotoURLKey       : valueFriend.photoURL ?? "",
                        InvitedCollectionKeys.LatitudeKey       : -1.0,
                        InvitedCollectionKeys.LongitudeKey      : -1.0,
                        InvitedCollectionKeys.ConfirmationKey   : false,
                        InvitedCollectionKeys.TaskKey           : value
                        ])
                    { (error) in
                        if let error = error {
                            print("adding friends error: \(error)")
                            completion(error)
                        } else {
                            print("friends added successfully to ref: \(valueFriend.userId)")
                            completion(nil)
                        }
                    }

                }
            }
        }

    }
//    static public func deleteEvent(event: Event, completion: @escaping (Error?) -> Void) {
//        DBService.firestoreDB
//            .collection(EventsCollectionKeys.CollectionKey)
//            .document(event.documentId)
//            .delete { (error) in
//                if let error = error {
//                    completion(error)
//                } else {
//                    completion(nil)
//                }
//        }
//    }
}
