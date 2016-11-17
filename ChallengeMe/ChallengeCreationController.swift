//
//  ChallengeCreationController.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 11/15/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class ChallengeCreationController: UIViewController {
    
     var ref: FIRDatabaseReference!
    
//    var currentUserProfile = {
//        if let user = FIRAuth.auth()?.currentUser {
//            for profile in user.providerData {
//                
//                return profile
////                let name = profile.displayName
////                let email = profile.email
////                let photoURL = profile.photoURL
////                let uid = profile.uid
////                return uid
//            }
//            
//        } else {
//            
//        }
//    }

    @IBOutlet weak var challengeNameField: UITextField!
    
    @IBOutlet weak var opponentSearch: UISearchBar!
    
    @IBOutlet weak var challengeGoalField: UITextField!
    
    @IBOutlet weak var onTheLineField: UITextField!
    
    // TODO: Clean this up
    var name: String?
    var email: String?
    var photoURL: URL?
    var uid: String?
    
    func getUserInfo() {
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                
                
                                self.name = profile.displayName
                                self.email = profile.email
                                self.photoURL = profile.photoURL
                                self.uid = profile.uid
                
            }
            
        } else {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        // TODO: explicitly calling this is not great
        getUserInfo()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createChallenge(_ sender: Any) {
        
        //TODO: Create unique challenge id and separate users db logic from challenges db logic
        
        // add new challenge to challenges db
        //self.ref.child("Challenges\(challengeName.text)/creator").setValue(facebookUserID)
        if let challengeName = challengeNameField.text {
            //TODO: Clean up optional ivars and challenge name to challenge id
            let challengeId = challengeName
            
        
            //self.ref.child("Challenges/\(challengeName)/opponent").setValue(opponentSearch.text)
            if let goal = challengeGoalField.text {
                self.ref.child("Challenges/\(challengeId)/goal").setValue(goal)
            }
            if let reward = onTheLineField.text {
                self.ref.child("Challenges/\(challengeId)/reward").setValue(reward)
            }
            // TODO: project wide constants
            // pending: 0
            // current: 1
            // past: 2
            self.ref.child("Challenges/\(challengeId)/status").setValue(1)
            
            self.ref.child("Challenges/\(challengeId)/name").setValue(challengeName)
        
          
            self.ref.child("Users/\(uid!)/Challenges/\(challengeId)/name").setValue(challengeName)
            self.ref.child("Users/\(uid!)/Challenges/\(challengeId)/status").setValue(1)
        //self.ref.child("Users"/\()
        // Add challenge to current user
        // Add challenge to opponent
        }
        
        self.navigationController?.popViewController(animated: true)
        
        // TODO: alert user challenge is made
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
