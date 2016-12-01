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
    
    
    @IBOutlet weak var eventDesc: UITextField!
    
    @IBOutlet weak var eventPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
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
        
//        self.ref.child("Challenges/example challenge/events/3/name").setValue("Sample Event!")
//        let storage = FIRStorage.storage()
//        let storageRef = storage.reference(forURL: "gs://challengeme-75fd5.appspot.com")
//        let spaceRef = storageRef.child("images/space.jpg")
//        //let urlpath     = Bundle.main.path(forResource: "running", ofType: "jpg")
//        //let localFile: NSURL = NSURL.fileURL(withPath: urlpath!) as NSURL;
//        let imageURL = info[UIImagePickerControllerReferenceURL] as NSURL
//        let imageName = imageURL.path!.lastPathComponent
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
//        let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
//        
//        let image = info[UIImagePickerControllerOriginalImage] as UIImage
//        let data = UIImagePNGRepresentation(image)
//        data.writeToFile(localPath, atomically: true)
//        
//        let imageData = NSData(contentsOfFile: localPath)!
//        let photoURL = NSURL(fileURLWithPath: localPath)
//        // Upload the file to the path "folderName/file.jpg"
//        let uploadTask = spaceRef.putFile(photoURL as URL, metadata: nil)
//        
//        let observer = uploadTask.observe(.progress) { snapshot in
//            print(snapshot.progress) // NSProgress object
//        }
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
