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
}

extension DBService {
    static public func addInvited(docRef: String, friends: [UserModel], completion: @escaping (Error?) -> Void)  {
        var dictionaryFriends : Dictionary<String,Any> = [:]
        
        for friend in friends {
            dictionaryFriends["\(friend.userId)"] = "\(friend.displayName)"
        }
        firestoreDB.collection(EventsCollectionKeys.CollectionKey).document(docRef).collection(InvitedCollectionKeys.CollectionKey).document(docRef).setData(dictionaryFriends)
            { (error) in
                if let error = error {
                    print("adding friends error: \(error)")
                    completion(error)
                } else {
                    print("friends added successfully to ref: \(docRef)")
                    completion(nil)
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
