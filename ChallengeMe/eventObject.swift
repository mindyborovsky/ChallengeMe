//
//  eventObject.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 12/1/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import Foundation

struct Event {
    var description: String?
    var userId: String?
    var imageLink: String?
    var id: String?
    
    func toDictionary() -> Dictionary<String,Any> {
        var dict: Dictionary<String,Any> = ["id":""]
        dict["id"] = self.id!
        dict["description"] = self.description!
        dict["userId"] = self.userId!
        dict["imageLink"] = self.imageLink!
        return dict
    }
    
    static func initWith(dictionary: Dictionary<String,Any>) -> Event {
        var event = Event()
        // leave this wizardry alone
        
        event.id = dictionary["id"] as? String ?? "error parsing id"
        event.description = dictionary["description"] as? String ?? ""
        event.userId = dictionary["userId"] as? String ?? ""
        event.imageLink = dictionary["imageLink"] as? String ?? ""
        return event
    }
}
