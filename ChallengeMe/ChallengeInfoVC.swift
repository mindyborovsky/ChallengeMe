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
    
    @IBOutlet weak var creatorImage: UIImageView!
    
    @IBOutlet weak var opponentImage: UIImageView!
    
    var currChallenge = Challenge()
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
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
