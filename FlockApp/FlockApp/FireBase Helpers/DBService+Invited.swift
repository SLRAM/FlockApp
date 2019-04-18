//
//  DBService+Invited.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/15/19.
//

import Foundation
import FirebaseFirestore
import Firebase

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
}

extension DBService {
    static public func addInvited(docRef: String, friends: [UserModel], tasks: Dictionary<Int,String>, completion: @escaping (Error?) -> Void)  {
        
        for friend in friends {
            
            print(tasks)
            for (keyFriend,valueFriend) in friends.enumerated() {
                for (key,value) in tasks {
                    if keyFriend == key {
                        print(value)
                        firestoreDB.collection(EventsCollectionKeys.CollectionKey).document(docRef).collection(InvitedCollectionKeys.CollectionKey).document(friend.userId).setData([
                            InvitedCollectionKeys.UserIdKey         : friend.userId,
                            InvitedCollectionKeys.DisplayNameKey    : friend.displayName,
                            InvitedCollectionKeys.FirstNameKey      : friend.firstName,
                            InvitedCollectionKeys.LastNameKey       : friend.lastName,
                            InvitedCollectionKeys.PhotoURLKey       : friend.photoURL ?? "",
                            InvitedCollectionKeys.LatitudeKey       : 0.0,
                            InvitedCollectionKeys.LongitudeKey      : 0.0,
                            InvitedCollectionKeys.TaskKey           : value
                            ])
                        { (error) in
                            if let error = error {
                                print("adding friends error: \(error)")
                                completion(error)
                            } else {
                                print("friends added successfully to ref: \(friend.userId)")
                                completion(nil)
                            }
                        }

                    }
                }
            }
//            var dictionaryFriends : Dictionary<String,Any> = [:]
//            dictionaryFriends["userId"] = "\(friend.userId)"
//            dictionaryFriends["displayName"] = "\(friend.displayName)"
//            dictionaryFriends["firstName"] = "\(friend.firstName)"
//            dictionaryFriends["lastName"] = "\(friend.lastName)"
//            dictionaryFriends["photoURL"] = "\(friend.photoURL)"
//            dictionaryFriends["latitude"] = 0.0
//            dictionaryFriends["longitude"] = 0.0
            
//            firestoreDB.collection(EventsCollectionKeys.CollectionKey).document(docRef).collection(InvitedCollectionKeys.CollectionKey).document(friend.userId).setData([
//                InvitedCollectionKeys.UserIdKey         : friend.userId,
//                InvitedCollectionKeys.DisplayNameKey    : friend.displayName,
//                InvitedCollectionKeys.FirstNameKey      : friend.firstName,
//                InvitedCollectionKeys.LastNameKey       : friend.lastName,
//                InvitedCollectionKeys.PhotoURLKey       : friend.photoURL ?? "",
//                InvitedCollectionKeys.LatitudeKey       : 0.0,
//                InvitedCollectionKeys.LongitudeKey      : 0.0,
//                InvitedCollectionKeys.TaskKey           : "Task"
//                ])
            
            
            
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
