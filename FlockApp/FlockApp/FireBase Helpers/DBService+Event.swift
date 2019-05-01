//
//  DBService+Event.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseAuth


struct EventsCollectionKeys {
    static let EventNameKey = "eventName"
    static let CollectionKey = "events"
    static let EventPendingKey = "eventPending"
    static let EventAcceptedKey = "eventAccepted"
    static let EventDescriptionKey = "eventDescription"
    static let UserIDKey = "userID"
    static let CreatedDateKey = "createdDate"
    static let StartDateKey = "startDate"
    static let EndDateKey = "endDate"
    static let DocumentIdKey = "documentId"
    static let ImageURLKey = "imageURL"
    static let LocationStringKey = "locationString"
    static let LocationLatKey = "locationLat"
    static let LocationLongKey = "locationLong"
//    static let InvitedKey = "invited"
    static let TrackingTimeKey = "trackingTime"
    static let QuickEventKey = "quickEvent"
    static let ProximityKey = "proximity"
}

extension DBService {
    static public func postEvent(event: Event, completion: @escaping (Error?) -> Void)  {
        firestoreDB.collection(EventsCollectionKeys.CollectionKey)
            .document(event.documentId).setData([
                EventsCollectionKeys.EventNameKey       : event.eventName,
                EventsCollectionKeys.CreatedDateKey     : event.createdDate,
                EventsCollectionKeys.StartDateKey       : event.startDate,
                EventsCollectionKeys.EndDateKey         : event.endDate,
                EventsCollectionKeys.UserIDKey          : event.userID,
                EventsCollectionKeys.EventDescriptionKey: event.eventDescription,
                EventsCollectionKeys.ImageURLKey        : event.imageURL,
                EventsCollectionKeys.DocumentIdKey      : event.documentId,
                EventsCollectionKeys.LocationStringKey  : event.locationString,
                EventsCollectionKeys.LocationLatKey     : event.locationLat,
                EventsCollectionKeys.LocationLongKey    : event.locationLong,
                EventsCollectionKeys.TrackingTimeKey    : event.trackingTime,
                EventsCollectionKeys.QuickEventKey      : event.quickEvent,
                EventsCollectionKeys.ProximityKey       : event.proximity
                ])
            { (error) in
                if let error = error {
                    print("posting event error: \(error)")
                    completion(error)
                } else {
                    print("event posted successfully to ref: \(event.documentId)")
                    completion(nil)
                }
        }
    }
    static public func postPendingEventToUser(user: User, userIds: [UserModel], event: Event, completion: @escaping (Error?) -> Void)  {
        var usersIds = [String]()
        usersIds.append(user.uid)
        for userId in userIds {
            usersIds.append(userId.userId)
        }
        
        
        for userId in usersIds {
            fetchUser(userId: userId) { (error, currentUser) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let currentUser = currentUser {
                    firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                        .document(userId)
                        .collection(EventsCollectionKeys.EventPendingKey)
                        .document(event.documentId)
                        .setData([
                        EventsCollectionKeys.EventNameKey       : event.eventName,
                        EventsCollectionKeys.CreatedDateKey     : event.createdDate,
                        EventsCollectionKeys.StartDateKey       : event.startDate,
                        EventsCollectionKeys.EndDateKey         : event.endDate,
                        EventsCollectionKeys.UserIDKey          : event.userID,
                        EventsCollectionKeys.EventDescriptionKey: event.eventDescription,
                        EventsCollectionKeys.ImageURLKey        : event.imageURL,
                        EventsCollectionKeys.DocumentIdKey      : event.documentId,
                        EventsCollectionKeys.LocationStringKey  : event.locationString,
                        EventsCollectionKeys.LocationLatKey     : event.locationLat,
                        EventsCollectionKeys.LocationLongKey    : event.locationLong,
                        EventsCollectionKeys.TrackingTimeKey    : event.trackingTime,
                        EventsCollectionKeys.QuickEventKey      : event.quickEvent,
                        EventsCollectionKeys.ProximityKey       : event.proximity,
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
        }

    }
    static public func postAcceptedEventToUser(user: User, userIds: [UserModel], event: Event, completion: @escaping (Error?) -> Void)  {
        var usersIds = [String]()
        usersIds.append(user.uid)
        for userId in userIds {
            usersIds.append(userId.userId)
        }
        for userId in usersIds {
            fetchUser(userId: userId) { (error, currentUser) in
                if let error = error {
                    print("failed to fetch friends with error: \(error.localizedDescription)")
                } else if let currentUser = currentUser {
                    firestoreDB.collection(UsersCollectionKeys.CollectionKey)
                        .document(userId)
                        .collection(EventsCollectionKeys.EventAcceptedKey)
                        .document(event.documentId)
                        .setData([
                        EventsCollectionKeys.EventNameKey       : event.eventName,
                        EventsCollectionKeys.CreatedDateKey     : event.createdDate,
                        EventsCollectionKeys.StartDateKey       : event.startDate,
                        EventsCollectionKeys.EndDateKey         : event.endDate,
                        EventsCollectionKeys.UserIDKey          : event.userID,
                        EventsCollectionKeys.EventDescriptionKey: event.eventDescription,
                        EventsCollectionKeys.ImageURLKey        : event.imageURL,
                        EventsCollectionKeys.DocumentIdKey      : event.documentId,
                        EventsCollectionKeys.LocationStringKey  : event.locationString,
                        EventsCollectionKeys.LocationLatKey     : event.locationLat,
                        EventsCollectionKeys.LocationLongKey    : event.locationLong,
                        EventsCollectionKeys.TrackingTimeKey    : event.trackingTime,
                        EventsCollectionKeys.QuickEventKey      : event.quickEvent,
                        EventsCollectionKeys.ProximityKey       : event.proximity,
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
        }
        
        
    }
    static public func deleteEventFromPending(user: User, event: Event, completion: @escaping (Error?) -> Void) {
        firestoreDB.collection(UsersCollectionKeys.CollectionKey)
            .document(user.uid)
            .collection(EventsCollectionKeys.EventPendingKey)
            .document(event.documentId)
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }


    static public func deleteEvent(event: Event, completion: @escaping (Error?) -> Void) {
        DBService.firestoreDB
            .collection(EventsCollectionKeys.CollectionKey)
            .document(event.documentId)
            .delete { (error) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
        }
    }
}
