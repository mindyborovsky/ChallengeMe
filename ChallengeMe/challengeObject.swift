//
//  challengeObject.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 11/15/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum ChallengeStatus {
    case Pending
    case Current
    case Past
}

struct Challenge {
    
    var id: String?
    
    var name: String?
    
    var opponentId: String?
    
    var creatorId: String?
    
    var opponentGoal: String?
    
    var creatorGoal: String?
    
    var reward: String?
    
    // TODO: Replace with enum ChallengeStatus
    var status: Int?
    
    static func generateID(name: String, creator: String, opponent: String) -> String{
        // TODO: Make this a real hash function
        let id = name + creator + opponent + String(arc4random())
        return id
    }
    
    
    static func initWith(snapshot: FIRDataSnapshot, id: String) -> Challenge {
        var challenge = Challenge()
        let value = snapshot.value as? NSDictionary
        challenge.id = id
        challenge.name  = value?["name"] as? String ?? ""
        challenge.creatorId  = value?["creatorId"] as? String ?? ""
        challenge.creatorGoal  = value?["creatorGoal"] as? String ?? ""
        challenge.opponentGoal  = value?["opponentGoal"] as? String ?? ""
        challenge.opponentId = value?["opponentId"] as? String ?? ""
        challenge.reward = value?["reward"] as? String ?? ""
        // TODO: This will throw errors
        challenge.status = value?["status"] as? Int ?? -1
        return challenge
    }
    
    func toDictionary() -> Dictionary<String,Any> {
        var dict: Dictionary<String,Any> = ["name":""]
        dict["name"] = self.name!
        dict["creatorId"] = self.creatorId!
        dict["opponentId"] = self.opponentId!
        dict["creatorGoal"] = self.creatorGoal!
        dict["opponentGoal"] = self.opponentGoal ?? ""
        dict["reward"] = self.reward!
        dict["status"] = self.status!
        return dict
    }
    
    func saveToFirebase(ref: FIRDatabaseReference) {
        if let id = self.id {
        ref.child("Challenges/\(id)").setValue(self.toDictionary())
        } else {
            print("no id for challenge")
        }
    }
}
