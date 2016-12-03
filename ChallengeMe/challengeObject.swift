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
    
    var events: Array<Event> = []
    
    var duration: Int?
    
    // TODO: Replace with enum ChallengeStatus
    var status: Int?
    
    var winnerId: String?
    
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
        challenge.duration = value?["duration"] as? Int ?? -1
        challenge.winnerId = value?["winnerId"] as? String ?? ""
        // TODO: Figure out all of this janky events array stuff
        let events = value?["events"] as? NSDictionary
        var creatorCount = 0
        var opponentCount = 0
        if let count = events?["count"] as? Int {
            for i in 0..<count {
                
                let val = events?[String(i)]
                let eventDict = val as? NSDictionary
                
                let event = Event.initWith(dictionary: eventDict as! Dictionary<String, Any>)
                if event.userId! == challenge.creatorId! {
                    creatorCount += 1
                } else if event.userId! == challenge.opponentId {
                    opponentCount += 1
                } else {
                    print("invalid event")
                }
                challenge.events.append(event)
            }
            if challenge.status != 2 {
                if opponentCount >= challenge.duration! {
                    // First time challenge is set to completed
                    challenge.updateCompletedChallenge(winnerId: challenge.opponentId!)
                } else if creatorCount >= challenge.duration! {
                    // First time challenge is set to completed
                    challenge.updateCompletedChallenge(winnerId: challenge.creatorId!)
                    
                }
            }
        }
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
        dict["duration"] = self.duration!
        var eventsObject: Optional<Dictionary<String,Any>>
        for i in 0..<self.events.count {
            if eventsObject == nil {
                eventsObject = ["0":""]
            }
            let eventDict = self.events[i].toDictionary()
            eventsObject!.updateValue(eventDict, forKey: String(i))
        }
        dict["winnerId"] = self.winnerId ?? ""
        
        return dict
    }
    
    func saveToFirebase(ref: FIRDatabaseReference) {
        if let id = self.id {
            ref.child("Challenges/\(id)").setValue(self.toDictionary())
        } else {
            print("no id for challenge")
        }
    }
    
    mutating func updateCompletedChallenge(winnerId: String) {
        
        self.status = 2
        self.winnerId = winnerId
        
        let creatorChallenge = UserChallenge.initWith(challenge: self, userId: self.creatorId!)
        let opponentChallenge = UserChallenge.initWith(challenge: self, userId: self.opponentId!)
        
        let ref = FIRDatabase.database().reference()
        creatorChallenge.saveToFirebase(ref: ref, uid: self.creatorId!)
        opponentChallenge.saveToFirebase(ref: ref, uid: self.opponentId!)
        self.saveToFirebase(ref: ref)
        
        // Increment ref
        ref.child("Usrs/")
    }
}
