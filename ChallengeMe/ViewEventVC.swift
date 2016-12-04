//
//  ViewEventVC.swift
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

class ViewEventVC: UIViewController {

    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var eventUserName: UILabel!
    @IBOutlet weak var eventPic: UIImageView!
    @IBOutlet weak var eventDisc: UILabel!
    
    var eventTag = Int()
    
    var currChallenge = Challenge()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        
        print(currChallenge.events[eventTag].userId!)
        ref.child("Users/\(currChallenge.events[eventTag].userId!)").observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            
            let dict: NSDictionary = snapshot.value as! NSDictionary
            if let userName = dict["Name"] as? String {
                self.eventUserName.text = userName
            }
        });
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://challengeme-75fd5.appspot.com")
        
        let spaceRef = storageRef.child("\(currChallenge.id!)/\(eventTag).jpg")
        
        spaceRef.downloadURL { (URL, error) -> Void in
            if (error != nil) {
                // Handle any errors
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            } else {
                // Get the download URL for 'images/stars.jpg'
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: URL!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        self.eventPic.image = UIImage(data: data!)
                        // this is delayed by a cycle
                        self.view.setNeedsDisplay()
                        
                    }
                }
            }
        }
        
        
        eventDisc.text = currChallenge.events[eventTag].description!
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
