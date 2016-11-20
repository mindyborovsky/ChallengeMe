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
    
    @IBOutlet weak var opponentLabel: UILabel!
    @IBOutlet weak var challengeNameField: UITextField!
    @IBOutlet weak var challengeGoalField: UITextField!
    @IBOutlet weak var onTheLineField: UITextField!
    
    // TODO: Clean this up
    var name: String?
    var email: String?
    var opponent: User?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.opponentLabel.text = opponent?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createChallenge(_ sender: Any) {
        
        //TODO: Create unique challenge id and separate users db logic from challenges db logic
        // TODO: disable button until challenge is valid
        // add new challenge to challenges db
        //self.ref.child("Challenges\(challengeName.text)/creator").setValue(facebookUserID)
        if let challengeName = challengeNameField.text {
            //TODO: Clean up optional ivars and challenge name to challenge id
            let challengeId = challengeName
            // TODO: project wide constants
            // pending: 0
            // current: 1
            // past: 2
            let initialStatus = 0
            
            var challengeDict: Dictionary<String,Any> = ["goal":""]
            var userChallengeDict: Dictionary<String,Any> = ["name":""]
            var opponentChallengeDict: Dictionary<String,Any> = ["name":""]
            
            if let goal = challengeGoalField.text {
                challengeDict["goal"] = goal
                //self.ref.child("Challenges/\(challengeId)/goal").setValue(goal)
            }
            if let reward = onTheLineField.text {
                challengeDict["reward"] = reward
                //self.ref.child("Challenges/\(challengeId)/reward").setValue(reward)
            }
            if let opponent = self.opponent {
                challengeDict["opponent"] = opponent.uid
                //self.ref.child("Challenges/\(challengeName)/opponent").setValue(opponent.uid)
                opponentChallengeDict["name"] = challengeName
                opponentChallengeDict["status"] = initialStatus
                opponentChallengeDict["creator"] = false
                self.ref.child("Users/\(opponent.uid!)/Challenges/\(challengeId)").setValue(opponentChallengeDict)
//                self.ref.child("Users/\(opponent.uid!)/Challenges/\(challengeId)/name").setValue(challengeName)
//                self.ref.child("Users/\(opponent.uid!)/Challenges/\(challengeId)/status").setValue(initialStatus)
//                self.ref.child("Users/\(opponent.uid!)/Challenges/\(challengeId)/creator").setValue(false)
            }
            challengeDict["status"] = initialStatus
            //self.ref.child("Challenges/\(challengeId)/status").setValue(initialStatus)
            challengeDict["name"] = challengeName
//            self.ref.child("Challenges/\(challengeId)/name").setValue(challengeName)
        
            userChallengeDict["name"] = challengeName
            userChallengeDict["status"] = initialStatus
            userChallengeDict["creator"] = true
//            self.ref.child("Users/\(uid!)/Challenges/\(challengeId)/name").setValue(challengeName)
//            self.ref.child("Users/\(uid!)/Challenges/\(challengeId)/status").setValue(initialStatus)
//            self.ref.child("Users/\(uid!)/Challenges/\(challengeId)/creator").setValue(true)
             self.ref.child("Challenges/\(challengeId)").setValue(challengeDict)
            self.ref.child("Users/\(uid!)/Challenges/\(challengeId)").setValue(userChallengeDict)
            
            
        //self.ref.child("Users"/\()
        // Add challenge to current user
        // Add challenge to opponent
        }
        
        self.navigationController?.popViewController(animated: true)
        
        // TODO: alert user challenge is made
    }
    
    @IBAction func findFriends(_ sender: UIButton) {
        
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destination.isKind(of: FindFriendsController.self) {
            let vc = segue.destination as! FindFriendsController
            vc.challengeVC = self
        }
    }
 

}
