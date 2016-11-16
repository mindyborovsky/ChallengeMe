//
//  ChallengeCreationController.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 11/15/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChallengeCreationController: UIViewController {
    
     var ref: FIRDatabaseReference!

    @IBOutlet weak var challengeName: UITextField!
    
    @IBOutlet weak var opponentSearch: UISearchBar!
    
    @IBOutlet weak var challengeGoal: UITextField!
    
    @IBOutlet weak var onTheLine: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func createChallenge(_ sender: Any) {
        
        // add new challenge to challenges db
        //self.ref.child("Challenges\(challengeName.text)/creator").setValue(facebookUserID)
        self.ref.child("Challenges/\(challengeName.text)/opponent").setValue(opponentSearch.text)
        print(challengeName.text!)
        self.ref.child("Challenges/\(challengeName.text)/goal").setValue(challengeGoal.text)
        self.ref.child("Challenges/\(challengeName.text)/bet").setValue(onTheLine.text)
        
        
        //self.ref.child("Users"/\()
        // Add challenge to current user
        // Add challenge to opponent
        
        
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
