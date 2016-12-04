//
//  ChallengeInfoVC.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 12/3/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ChallengeInfoVC: UIViewController {
    
    @IBOutlet weak var numComNeed: UILabel!
    @IBOutlet weak var myGoal: UILabel!
    
    @IBOutlet weak var onTheLine: UILabel!
    @IBOutlet weak var creatorImage: UIImageView!
    @IBOutlet weak var opponentGoal: UILabel!
    
    @IBOutlet weak var opponentImage: UIImageView!
    
    var currChallenge = Challenge()
    
    
    var ref: FIRDatabaseReference!
    
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
        
        getUserInfo()
        
        ref.child("Users/\(currChallenge.creatorId!)").observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            
            let dict: NSDictionary = snapshot.value as! NSDictionary
            if let creatorPic = dict["Picture"] as? String {
                print(creatorPic)
                DispatchQueue.global().async {
                    let url = NSURL(string: creatorPic)
                    let data = try? Data(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.creatorImage.image = UIImage(data: data!)
                        // this is delayed by a cycle
                        self.view.setNeedsDisplay()
                        
                    }
                }
            }
        });
        
        ref.child("Users/\(currChallenge.opponentId!)").observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            
            let dict: NSDictionary = snapshot.value as! NSDictionary
            if let opponentPic = dict["Picture"] as? String {
                print(opponentPic)
                DispatchQueue.global().async {
                    let url = NSURL(string: opponentPic)
                    let data = try? Data(contentsOf: url! as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.opponentImage.image = UIImage(data: data!)
                        // this is delayed by a cycle
                        self.view.setNeedsDisplay()
                        
                    }
                }
            }
        });
        
        if (currChallenge.creatorId! == self.uid!) {
            myGoal.text = "My Goal: \(currChallenge.creatorGoal!)"
            opponentGoal.text = "Opponent's Goal: \(currChallenge.opponentGoal!)"
        }
        else {
            myGoal.text = "My Goal: \(currChallenge.opponentGoal!)"
            opponentGoal.text = "Opponent's Goal: \(currChallenge.creatorGoal!)"
        }
        
        onTheLine.text = "\(currChallenge.reward!)"
        
        numComNeed.text = "Number of Completions Needed: \(currChallenge.duration!)"
        
        self.title = currChallenge.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
