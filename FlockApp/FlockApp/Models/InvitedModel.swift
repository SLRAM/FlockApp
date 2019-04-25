//
//  InvitedModel.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 4/17/19.
//

import Foundation

struct InvitedModel {
    let userId: String
    let displayName: String
    let firstName: String?
    let lastName: String?
    let photoURL: String?
    let latitude: Double?
    let longitude: Double?
    let task: String?
    let confirmation: Bool

    public var fullName: String {
        return ((firstName ?? "") + " " + (lastName ?? "")).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(userId: String,
         displayName: String,
         firstName: String?,
         lastName: String?,
         photoURL: String?,
         latitude: Double?,
         longitude: Double?,
         task: String,
         confirmation: Bool) {
        self.userId = userId
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.photoURL = photoURL
        self.latitude = latitude
        self.longitude = longitude
        self.task = task
        self.confirmation = confirmation
    }
    
    init(dict: [String: Any]) {
        self.userId = dict[InvitedCollectionKeys.UserIdKey] as? String ?? ""
        self.displayName = dict[InvitedCollectionKeys.DisplayNameKey] as? String ?? ""
        self.firstName = dict[InvitedCollectionKeys.FirstNameKey] as? String ?? "FirstName"
        self.lastName = dict[InvitedCollectionKeys.LastNameKey] as? String ?? "LastName"
        self.photoURL = dict[InvitedCollectionKeys.PhotoURLKey] as? String ?? ""
        self.latitude = dict[InvitedCollectionKeys.LatitudeKey] as? Double
        self.longitude = dict[InvitedCollectionKeys.LongitudeKey] as? Double
        self.task = dict[InvitedCollectionKeys.TaskKey] as? String ?? "Task"
        self.confirmation = dict[InvitedCollectionKeys.ConfirmationKey] as? Bool ?? false
        
    }
}
