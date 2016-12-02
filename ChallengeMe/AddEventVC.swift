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
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .camera
//        present(picker, animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        eventPic.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func eventSubmit(_ sender: Any) {
        // Replace "example challenge" with the challenge id
        // Replace "3" with whatever the event number is (discussed above)
        // Must add description and some type of link to the image in the database
        
        let nextEventIndex = currChallenge.events.count
        
        //
        // PHOTO STUFF - adding to firebase storage
        //
        var downloadURL: String = ""
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://challengeme-75fd5.appspot.com")
        let spaceRef = storageRef.child("\(currChallenge.id!)/\(nextEventIndex).jpg")
//        let urlpath     = Bundle.main.path(forResource: "running", ofType: "jpg")
//        let localFile: NSURL = NSURL.fileURL(withPath: urlpath!) as NSURL;
        var data = NSData()
        data = UIImageJPEGRepresentation(eventPic.image!, 0.8)! as NSData
        
        let metaData = FIRStorageMetadata()
        
        metaData.contentType = "image/jpg"
        
        spaceRef.put(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
//                self.databaseRef.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
            }
            
        }
        // Upload the file to the path "folderName/file.jpg"
//        let uploadTask = spaceRef.putFile(photoURL as URL, metadata: nil)
//
//        let observer = uploadTask.observe(.progress) { snapshot in
//            print(snapshot.progress) // NSProgress object
//        }
        
        //
        // WRITE TO FIREBASE
        //
        var newEvent = Event()
       
        newEvent.id = String(nextEventIndex)
        newEvent.description = eventDesc.text
        newEvent.userId = self.uid
        newEvent.imageLink = downloadURL
        let eventDict = newEvent.toDictionary()
        self.ref.child("Challenges/\(currChallenge.id!)/events/\(currChallenge.events.count)").setValue(eventDict)
        

        currChallenge.events.append(newEvent)
        
        self.ref.child("Challenges/\(currChallenge.id!)/events/count").setValue(currChallenge.events.count)
        
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
