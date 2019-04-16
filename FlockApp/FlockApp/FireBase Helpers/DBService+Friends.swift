//
//  DBService+Friends.swift
//  FlockApp
//
//  Created by Biron Su on 4/16/19.
//

import Foundation
import FirebaseFirestore
import Firebase

struct FriendsCollectionKey {
    static let CollectionKey = "friends"
}

extension DBService {
    static public func addFriend(friend: UserModel, completion: @escaping (Error?) -> Void)  {
        let user = AppDelegate.authservice.getCurrentUser()
        var dictionaryFriends : Dictionary<String,Any> = [:]
        
        dictionaryFriends["\(friend.userId)"] = "\(friend.displayName)"
        
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user!.uid)
            .collection(FriendsCollectionKey.CollectionKey)
            .document(friend.userId)
            .setData(dictionaryFriends)
            { (error) in
                if let error = error {
                    print("adding friends error: \(error)")
                    completion(error)
                } else {
                    print("friends added successfully to: \(user!.uid)")
                    completion(nil)
                }
        }
    }
}
