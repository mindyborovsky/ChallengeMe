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
    
    var won: Bool
    
    // TODO: always use this
    func toDictionary() -> Dictionary<String,Any> {
        var dict: Dictionary<String,Any> = ["name":""]
        dict["name"] = self.name
        dict["creator"] = self.creator
        dict["status"] = self.status
        dict["opponent"] = self.opponent
        dict["id"] = self.id
        dict["won"] = self.won
        return dict
    }
    
    // TODO: always use this
    func saveToFirebase(ref: FIRDatabaseReference, uid: String) {
        ref.child("Users/\(uid)/Challenges/\(self.id)").setValue(self.toDictionary())
    }
    
    
    static func initWith(challenge: Challenge, userId: String) -> UserChallenge {
        let creator = userId == challenge.creatorId
        let opponent = creator ? challenge.opponentId : challenge.creatorId
        let userId = creator ? challenge.creatorId : challenge.opponentId
        let won = challenge.winnerId == userId
        return UserChallenge(creator: creator, name: challenge.name!, status: challenge.status!, opponent: opponent!, id: challenge.id!, won: won)
        
    }
    
    static func initWith(dictionary: NSDictionary) -> UserChallenge {
        let name = dictionary["name"] as? String ?? ""
        let creator = dictionary["creator"] as? Bool ?? true
        let status = dictionary["status"] as? Int ?? -1
        let opponent = dictionary["opponent"] as? String ?? ""
        let id = dictionary["id"] as? String ?? ""
        let won = dictionary["won"] as? Bool ?? false
        let userChallenge = UserChallenge(creator: creator, name: name, status: status, opponent: opponent, id: id, won: won)
    
        return userChallenge
    }
 
}
