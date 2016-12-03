//
//  userChallenge.swift
//  ChallengeMe
//
//  Created by Mindy Borovsky on 11/30/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserChallenge {
    
    var creator: Bool
    
    var name: String
    
    var status: Int
    
    var opponent: String
    
    var id: String
    
    // TODO: always use this
    func toDictionary() -> Dictionary<String,Any> {
        var dict: Dictionary<String,Any> = ["name":""]
        dict["name"] = self.name
        dict["creator"] = self.creator
        dict["status"] = self.status
        dict["opponent"] = self.opponent
        dict["id"] = self.id
        return dict
    }
    
    // TODO: always use this
    func saveToFirebase(ref: FIRDatabaseReference, uid: String) {
        ref.child("Users/\(uid)/Challenges/\(self.id)").setValue(self.toDictionary())
    }
    
    
    static func initWith(challenge: Challenge, userId: String) -> UserChallenge {
        let creator = userId == challenge.creatorId
        let opponent = creator ? challenge.opponentId : challenge.creatorId
        return UserChallenge(creator: creator, name: challenge.name!, status: challenge.status!, opponent: opponent!, id: challenge.id!)
        
    }
}
