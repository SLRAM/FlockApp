//
//  DBService+Event.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import Foundation

import Foundation
import FirebaseFirestore
import Firebase

struct EventsCollectionKeys {
    static let EventNameKey = "eventName"
    static let CollectionKey = "events"
    static let EventDescriptionKey = "eventDescription"
    static let UserIDKey = "userID"
    static let CreatedDateKey = "createdDate"
    static let StartDateKey = "startDate"
    static let EndDateKey = "endDate"
    static let DocumentIdKey = "documentId"
    static let ImageURLKey = "imageURL"
}

extension DBService {
    static public func postEvent(event: Event) {
        firestoreDB.collection(EventsCollectionKeys.CollectionKey)
            .document(event.documentId).setData([
                EventsCollectionKeys.EventNameKey       : event.eventName,
                EventsCollectionKeys.CreatedDateKey     : event.createdDate,
                EventsCollectionKeys.StartDateKey       : event.startDate,
                EventsCollectionKeys.EndDateKey     : event.endDate,
                EventsCollectionKeys.UserIDKey       : event.userID,
                EventsCollectionKeys.EventDescriptionKey  : event.eventDescription,
                EventsCollectionKeys.ImageURLKey        : event.imageURL,
                EventsCollectionKeys.DocumentIdKey      : event.documentId
                ])
            { (error) in
                if let error = error {
                    print("posting event error: \(error)")
                } else {
                    print("event posted successfully to ref: \(event.documentId)")
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
