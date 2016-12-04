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
    @IBOutlet weak var createChallengeButton: UIButton!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var invalidLabel: UILabel!
    
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
        
        durationTextField.keyboardType = UIKeyboardType.phonePad
        
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        self.createChallengeButton.isEnabled = false
        self.createChallengeButton.titleLabel?.textColor = UIColor.lightGray
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        updateView()
        self.view.setNeedsDisplay()
        
    }
    
    func updateView() {
        var isValid = true

        
        if let reward = onTheLineField.text {
            if reward.isEmpty {
                isValid = false
                self.invalidLabel.text = "Please choose what's on the line"
            }
        }
        
        if let durationString = durationTextField.text {
            if let duration = Int(durationString) {
                if duration < 1 {
                    isValid = false
                    self.invalidLabel.text = "Please enter a valid duration"
                }
            } else {
                self.invalidLabel.text = "Please enter a valid duration"
                isValid = false
            }
        }
        
        
        if let goal = challengeGoalField.text {
            if goal.isEmpty {
                isValid = false
                self.invalidLabel.text = "Please enter a goal"
            }
        }
        
        if opponent == nil {
            isValid = false
            self.invalidLabel.text = "Please select an opponent"
        }
        
        if let name = challengeNameField.text {
            if name.isEmpty {
                isValid = false
                self.invalidLabel.text = "Please enter a challenge name"
            }
        }
        
        self.createChallengeButton.isEnabled = isValid
        if isValid {
            // TODO: THis doesn't update until a second tap
            self.createChallengeButton.isHidden = true
            self.createChallengeButton.titleLabel?.textColor = UIColor.white
            self.createChallengeButton.isHidden = false
            self.invalidLabel.isHidden = true
            
        } else {
            self.createChallengeButton.isHidden = true
            self.createChallengeButton.titleLabel?.textColor = UIColor.lightGray
            self.createChallengeButton.isHidden = false
            self.invalidLabel.isHidden = false
        }
        
        self.createChallengeButton.setNeedsDisplay()
        self.view.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.opponentLabel.text = opponent?.name
        updateView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createChallenge(_ sender: Any) {
        
        //TODO: Create unique challenge id and separate users db logic from challenges db logic
        // TODO: disable button until challenge is valid
        // add new challenge to challenges db
        if let challengeName = challengeNameField.text {
            //TODO: Clean up optional ivars and challenge name to challenge id
            var opponentId: String = ""
            if let opponent = self.opponent {
                opponentId = opponent.uid!
            }
            let challengeId = Challenge.generateID(name: challengeName, creator: uid!, opponent: opponentId)
            
            // TODO: project wide constants
            // pending: 0
            // current: 1
            // past: 2
            let initialStatus = 0
            var userChallengeDict: Dictionary<String,Any> = ["name":""]
            var opponentChallengeDict: Dictionary<String,Any> = ["name":""]
            
            var newChallenge = Challenge()
            
            if let goal = challengeGoalField.text {
                newChallenge.creatorGoal = goal
            }
            if let reward = onTheLineField.text {
                newChallenge.reward = reward
            }
            if let durationString = durationTextField.text {
                if let duration = Int(durationString) {
                newChallenge.duration = duration
                } else {
                    // error constructing int
                    print(durationString)
                }
            }
            if let opponent = self.opponent {
                newChallenge.opponentId = opponent.uid
                //self.ref.child("Challenges/\(challengeName)/opponent").setValue(opponent.uid)
                opponentChallengeDict["name"] = challengeName
                opponentChallengeDict["status"] = initialStatus
                opponentChallengeDict["opponent"] = uid!
                opponentChallengeDict["creator"] = false
                opponentChallengeDict["id"] = challengeId
                
                
                userChallengeDict["opponent"] = opponent.uid
                
                self.ref.child("Users/\(opponent.uid!)/Challenges/\(challengeId)").setValue(opponentChallengeDict)
            }
            
            newChallenge.id = challengeId
            newChallenge.status = initialStatus
            newChallenge.name = challengeName
            newChallenge.creatorId = uid!
        
            userChallengeDict["name"] = challengeName
            // TODO: Change this to automatically accepted
            userChallengeDict["status"] = initialStatus
            userChallengeDict["creator"] = true
            userChallengeDict["id"] = challengeId
            
            newChallenge.saveToFirebase(ref: self.ref)
            self.ref.child("Users/\(uid!)/Challenges/\(challengeId)").setValue(userChallengeDict)
            
            
        }
        self.dismiss(animated: true, completion: {
            
            }
        )
    }
    
    @IBAction func findFriends(_ sender: UIButton) {
        updateView()
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
