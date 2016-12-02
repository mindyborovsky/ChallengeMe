//
//  AcceptChallenge.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 11/20/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class AcceptChallenge: UIViewController {

    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var challenger: UILabel!
    
    @IBOutlet weak var creatorGoal: UILabel!
    
    @IBOutlet weak var onTheLine: UILabel!
    
    @IBOutlet weak var yourGoal: UITextField!
    
    var userChallenge: UserChallenge?
    
    var challenge: Challenge = Challenge()
    
    var creatorName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        var challengeId: String
        var opponentId: String = ""
        if let challenge = userChallenge {
            opponentId = challenge.opponent
            challengeId = challenge.id
            self.challenge.name = challenge.name
        
        ref.child("Challenges").child(challengeId).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            // Get user value
            self.challenge = Challenge.initWith(snapshot: snapshot)
            
        
            self.updateView()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        

        
        
        ref.child("Users").child(opponentId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.creatorName = value?["Name"] as? String ?? ""
            self.updateView()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        }
        

            
        
        
    }
    
    func updateView() {
        if let challengerName = creatorName {
        challenger.text =  (challengerName) + " challenged you!"
        creatorGoal.text = (challengerName) + "'s goal is to " + (challenge.creatorGoal)!
        }
        onTheLine.text = challenge.reward
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func acceptButton(_ sender: Any) {
        //self.ref.child("Challenges/\(challenge!.name)/status").setValue(1)
        //self.ref.child("Challenges/\(currChallenge!.name)/goal2").setValue(yourGoal.text!)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rejectButton(_ sender: Any) {
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
