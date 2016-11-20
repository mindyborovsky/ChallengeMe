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
    
    @IBOutlet weak var opponentGoal: UILabel!
    
    @IBOutlet weak var onTheLine: UILabel!
    
    @IBOutlet weak var yourGoal: UITextField!
    
    var currChallenge = Challenge(name: "name", opponent: "test", creator: false, goal: "test2", goal2: "test4", reward: "test3", status: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
        //challenger.text = currChallenge.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func acceptButton(_ sender: Any) {
        self.ref.child("Challenges/\(currChallenge.name)/status").setValue(1)
        self.ref.child("Challenges/\(currChallenge.name)/goal2").setValue(yourGoal.text!)
        
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
