//
//  Invitation.swift
//  FlockApp
//
//  Created by Biron Su on 4/25/19.
//

import Firebase
import UIKit

class InvitationListener {
    static func fetchForInvitationRequest(vc: UIViewController) {
        guard let user = AppDelegate.authservice.getCurrentUser() else {return}
        var listener: ListenerRegistration!
        listener = DBService.firestoreDB.collection(EventsCollectionKeys.CollectionKey)
            .whereField(InvitedCollectionKeys.UserIdKey, isEqualTo: user.uid)
            .addSnapshotListener {(snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let snapshot = snapshot {
                    let invitations = snapshot.documents.map {InvitedModel.init(dict: $0.data())}
                    if invitations.count > 0 {
                        let eventVC = EventViewController()
                        eventVC.modalPresentationStyle = .overCurrentContext
                        
                        vc.present(eventVC, animated: true)
                        
                    }
                }
        }
    }
}
