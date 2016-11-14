//
//  ViewController.swift
//  ChallengeMe
//
//  Created by Mindy Borovsky on 11/9/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    // comment to check git
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
    }

    @IBAction func didPressLoginButton(_ sender: UIButton) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

