//
//  EventModel.swift
//  FlockApp
//
//  Created by Biron Su on 4/10/19.
//

import Foundation

struct Event {
    let eventName: String
    let createdDate: String
    let userID: String
    let imageURL: String
    let eventDescription: String
    let documentId: String
    let startDate: String
    let endDate: String
    // add user id for attendees
    // add tasks?
    // add time/date
    // add location
    
    init(eventName: String, createdDate: String, userID: String, imageURL: String, eventDescription: String, documentId: String, startDate: String, endDate: String) {
        self.eventName = eventName
        self.createdDate = createdDate
        self.userID = userID
        self.imageURL = imageURL
        self.eventDescription = eventDescription
        self.documentId = documentId
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(dict: [String: Any]) {
        self.eventName = dict[EventsCollectionKeys.EventNameKey] as? String ?? "no event name"
        self.createdDate = dict[EventsCollectionKeys.CreatedDateKey] as? String ?? "no date"
        self.userID = dict[EventsCollectionKeys.UserIDKey] as? String ?? "no blogger id"
        self.imageURL = dict[EventsCollectionKeys.ImageURLKey] as? String ?? "no imageURL"
        self.eventDescription = dict[EventsCollectionKeys.EventDescriptionKey] as? String ?? "no description"
        self.documentId = dict[EventsCollectionKeys.DocumentIdKey] as? String ?? "no document id"
        self.startDate = dict[EventsCollectionKeys.StartDateKey] as? String ?? "No start date"
        self.endDate = dict[EventsCollectionKeys.EndDateKey] as? String ?? "No end date"
    }
}
