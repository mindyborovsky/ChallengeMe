//
//  AddEventVC.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 12/1/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AddEventVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: FIRDatabaseReference!
    
    var currChallenge = Challenge()
    
    @IBOutlet weak var eventDesc: UITextField!
    
    @IBOutlet weak var eventPic: UIImageView!
    
    
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

        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
        self.title = "New Event"
        
        getUserInfo()
        
        // This is a temporary fix of just setting the image manually, needs to be DELETED later
        eventPic.image = UIImage(named: "running.jpg")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        eventPic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: true, completion: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func takePic(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func eventSubmit(_ sender: Any) {
        // Replace "example challenge" with the challenge id
        // Replace "3" with whatever the event number is (discussed above)
        // Must add description and some type of link to the image in the database
        
        //
        // PHOTO STUFF - adding to firebase storage
        //
//        let storage = FIRStorage.storage()
//        let storageRef = storage.reference(forURL: "gs://challengeme-75fd5.appspot.com")
//        let spaceRef = storageRef.child("images/event.jpg")
//        let urlpath     = Bundle.main.path(forResource: "running", ofType: "jpg")
//        let localFile: NSURL = NSURL.fileURL(withPath: urlpath!) as NSURL;
//        
//        // Upload the file to the path "folderName/file.jpg"
//        let uploadTask = spaceRef.putFile(localFile as URL, metadata: nil)
//        
//        let observer = uploadTask.observe(.progress) { snapshot in
//            print(snapshot.progress) // NSProgress object
//        }
        
        //
        // WRITE TO FIREBASE
        //
        
        var eventDict: Dictionary<String,Any> = ["id":""]
        eventDict["id"] = currChallenge.events.count + 1
        eventDict["description"] = eventDesc.text
        eventDict["userId"] = self.uid
        eventDict["imageLink"] = "this is a dummy link"
        
        self.ref.child("Challenges/\(currChallenge.id!)/events/\(currChallenge.events.count + 1)").setValue(eventDict)
        
        self.navigationController?.popViewController(animated: true)
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
