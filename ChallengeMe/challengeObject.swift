//
//  challengeObject.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 11/15/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import Foundation

struct Challenge {
    
    var name: String?
    
    var opponent: String?
    
    var creatorID: Int?
    
    var goal: String?
    
    var goal2: String?
    
    var reward: String?
    
    var status: Int?
    
    static func generateID(name: String, creator: String, opponent: String) -> String{
        let id = name + creator + opponent + String(arc4random())
        return id
    }
    
    
    
}
