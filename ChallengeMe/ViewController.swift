//
//  ViewController.swift
//  ChallengeMe
//
//  Created by Mindy Borovsky on 11/9/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    var ref: FIRDatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = FBSDKLoginButton()
        //loginButton.delegate = self
        
        ref = FIRDatabase.database().reference()
        
        self.ref.child("Challenges/challengeOne/creator").setValue("1234")
        self.ref.child("Challenges/challengeOne/opponent").setValue("5678")
        self.ref.child("Challenges/challengeOne/goal").setValue("Run 5 miles")
        self.ref.child("Challenges/challengeOne/bet").setValue("Ted Drewes")

        
    }

    @IBAction func didPressLoginButton(_ sender: UIButton) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

