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
    static let PendingKey = "pending"
    static let RequestKey = "request"
    static let BlockedKey = "blocked"
}

extension DBService {
    static public func requestFriend(friend: UserModel, completion: @escaping (Error?) -> Void)  {
        let user = AppDelegate.authservice.getCurrentUser()
        var requestFriendDictionary : Dictionary<String,Any> = [:]
        
        requestFriendDictionary["\(user!.uid)"] = "\(user!.displayName ?? "No DisplayName")"
        var pendingFriendDictionary : Dictionary<String,Any> = [:]
        pendingFriendDictionary["\(friend.userId)"] = "\(friend.displayName)"
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(friend.userId)
            .collection(FriendsCollectionKey.PendingKey)
            .document(user!.uid)
            .setData(requestFriendDictionary)
            { (error) in
                if let error = error {
                    print("friend request error: \(error)")
                    completion(error)
                } else {
                    print("Friend Request Successful")
                    firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                        .document(user!.uid)
                        .collection(FriendsCollectionKey.RequestKey)
                        .document(friend.userId)
                        .setData(pendingFriendDictionary) {
                            (error) in
                            if let error = error {
                                print("Friend pending Error: \(error)")
                                completion(error)
                            } else {
                                print("Friend pending added successfully")
                                completion(nil)
                            }
                    }
                    print("friend requested successfully to: \(friend.userId)")
                    completion(nil)
                }
            }
    }
    static public func blockedUser(blocked: UserModel, completion: @escaping (Error?) -> Void)  {
        let user = AppDelegate.authservice.getCurrentUser()
        var blockedDictionary : Dictionary<String,Any> = [:]
        blockedDictionary["\(blocked.userId)"] = "\(blocked.displayName)"
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user!.uid)
            .collection(FriendsCollectionKey.BlockedKey)
            .document(blocked.userId)
            .setData(blockedDictionary)
            { (error) in
                if let error = error {
                    print("blocked error: \(error)")
                    completion(error)
                } else {
                    print("successfully blocked: \(blocked.userId) ")
                    completion(nil)
                }
        }
    }
    static public func unblockedUser(blocked: UserModel, completion: @escaping (Error?) -> Void)  {
        let user = AppDelegate.authservice.getCurrentUser()
        var blockedDictionary : Dictionary<String,Any> = [:]
        blockedDictionary["\(blocked.userId)"] = "\(blocked.displayName)"
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user!.uid)
            .collection(FriendsCollectionKey.BlockedKey)
            .document(blocked.userId)
            .delete()
            { (error) in
                if let error = error {
                    print("unblocked error: \(error)")
                    completion(error)
                } else {
                    print("successfully unblocked: \(blocked.userId) ")
                    completion(nil)
                }
        }
    }
    static public func removeFriend(removed: UserModel, completion: @escaping (Error?) -> Void)  {
        guard let user = AppDelegate.authservice.getCurrentUser() else {return}
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(FriendsCollectionKey.BlockedKey)
            .document(removed.userId)
            .delete()
                { (error) in
                    if let error = error {
                        print("removing friend error: \(error)")
                        completion(error)
                    } else {
                        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                            .document(removed.userId)
                            .collection(FriendsCollectionKey.BlockedKey)
                            .document(user.uid)
                            .delete()
                                { (error) in
                                    if let error = error {
                                        print("removing friend error: \(error)")
                                        completion(error)
                                    } else {
                                        print("successfully removed: \(removed.userId) ")
                                        completion(nil)
                                    }
                        }
                        print("successfully removed: \(removed.userId) ")
                        completion(nil)
                    }
        }
    }
    static public func cancelRequest(cancelRequest: UserModel, completion: @escaping (Error?) -> Void)  {
        let user = AppDelegate.authservice.getCurrentUser()
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user!.uid)
            .collection(FriendsCollectionKey.RequestKey)
            .document(cancelRequest.userId)
            .delete()
                { (error) in
                    if let error = error {
                        print("removing request error: \(error)")
                        completion(error)
                    } else {
                        print("successfully removed request: \(cancelRequest.userId) ")
                        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                            .document(cancelRequest.userId)
                            .collection(FriendsCollectionKey.PendingKey)
                            .document(user!.uid)
                            .delete() {
                                (error) in
                                if let error = error {
                                    print("Friend pending remove Error: \(error)")
                                    completion(error)
                                } else {
                                    print("Friend pending Successfully Removed")
                                    completion(nil)
                                }
                        }
                        completion(nil)
                    }
            }
    }
    static public func declinePending(pendingDecline: UserModel, completion: @escaping (Error?) -> Void)  {
        let user = AppDelegate.authservice.getCurrentUser()
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user!.uid)
            .collection(FriendsCollectionKey.PendingKey)
            .document(pendingDecline.userId)
            .delete()
                { (error) in
                    if let error = error {
                        print("decline pending error: \(error)")
                        completion(error)
                    } else {
                        print("successfully declined pending: \(pendingDecline.userId) ")
                        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                            .document(pendingDecline.userId)
                            .collection(FriendsCollectionKey.RequestKey)
                            .document(user!.uid)
                            .delete() {
                                (error) in
                                if let error = error {
                                    print(" User Requests decline Error: \(error)")
                                    completion(error)
                                } else {
                                    print("Friend Request successfully declined")
                                    completion(nil)
                                }
                        }
                        completion(nil)
                    }
        }
    }
    static public func addFriend(friend: UserModel, completion: @escaping (Error?) -> Void)  {
        guard let user = AppDelegate.authservice.getCurrentUser() else {return}
        var dictionaryFriends : Dictionary<String,Any> = [:]
        
        dictionaryFriends["\(friend.userId)"] = "\(friend.displayName)"
        var addselfFriends : Dictionary<String,Any> = [:]
        addselfFriends["\(user.uid)"] = "\(user.displayName ?? "N/A")"
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(FriendsCollectionKey.CollectionKey)
            .document(friend.userId)
            .setData(dictionaryFriends)
            { (error) in
                if let error = error {
                    print("adding friends error: \(error)")
                    completion(error)
                } else {
                    firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                        .document(friend.userId)
                        .collection(FriendsCollectionKey.CollectionKey)
                        .document(user.uid)
                        .setData(addselfFriends)
                        { (error) in
                            if let error = error {
                                print("adding friends error: \(error)")
                                completion(error)
                            } else {
                                firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                                    .document(friend.userId)
                                    .collection(FriendsCollectionKey.RequestKey)
                                    .document(user.uid)
                                    .delete()
                                        { (error) in
                                            if let error = error {
                                                print("friend pending delete error: \(error)")
                                                completion(error)
                                            } else {
                                                print("Friend Pending Successfully Removed")
                                                firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                                                    .document(user.uid)
                                                    .collection(FriendsCollectionKey.PendingKey)
                                                    .document(friend.userId)
                                                    .delete() {
                                                        (error) in
                                                        if let error = error {
                                                            print("Friend request remove Error: \(error)")
                                                            completion(error)
                                                        } else {
                                                            print("Friend Request Successfully Removed")
                                                            completion(nil)
                                                        }
                                                }
                                                print("friend requested successfully to: \(friend.userId)")
                                                completion(nil)
                                            }
                                    }
                                print("friends added successfully to: \(user.uid)")
                    
                                completion(nil)
                                }
                    }
                }
        }
    }
}
