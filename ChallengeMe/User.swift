//
//  User.swift
//  ChallengeMe
//
//  Created by Mindy Borovsky on 11/16/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import Foundation

struct User {
    var uid: String?
    var name: String?
    var email: String?
    var photoURL: String?
    var token: String?
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
}
