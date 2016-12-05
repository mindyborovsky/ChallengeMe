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


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    var userLoggedIn = false
    @IBOutlet weak var loginButton: UIButton!
    
    var ref: FIRDatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TODO: Remove this logout
        FBSDKLoginManager().logOut()
        // Do any additional setup after loading the view, typically from a nib.
        userLoggedIn = FBSDKAccessToken.current() != nil
        if (userLoggedIn)
        {
            // User is already logged in, do work such as go to next view controller.
            
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
        ref = FIRDatabase.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (userLoggedIn) {
            performSegue(withIdentifier: "homeSegue", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FB login delegate
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        // check result
        if FBSDKAccessToken.current() != nil {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) {(user, error) in
                // handle error
                if let result = user {
                    print(result)
                    for profile in result.providerData {
                        
                        let name = profile.displayName
                        let uid = profile.uid
                        let photoURL = profile.photoURL
                        //TODO: Is this bad?
                        self.ref.child("Users/\(uid)/Name").setValue(name)
                        
                        self.ref.child("Users/\(uid)/Picture").setValue("\(photoURL!)")
                        
                    }
                    self.performSegue(withIdentifier: "homeSegue", sender: self)
                }
                if let err = error {
                    print(err)
                }
                
            }
        }
        
        
        
    }
    
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    // MARK: - FB User
    public func getUserInfo(){
        // THIS METHOD ISNT USED
        if let user = FIRAuth.auth()?.currentUser {
            // TODO: Multiple profiles?
            for profile in user.providerData {
                
                
                let name = profile.displayName
                _ = profile.email
                let photoURL = profile.photoURL
                let uid = profile.uid
                //TODO: Is this bad?
                self.ref.child("Users/\(uid)/Name").setValue(name)
                self.ref.child("Users/\(uid)/Picture").setValue(photoURL!)
                
            }
            
        } else {
            
        }
        
    }
    
    //    func getChallenges()
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("segue")
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return true
    }
    
}

