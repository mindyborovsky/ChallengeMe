//
//  TimelineVC.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 11/17/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class TimelineVC: UIViewController, UIScrollViewDelegate {
    
    var ref: FIRDatabaseReference!
    
    var currChallenge = Challenge()
    var userChallenge: UserChallenge?
    
    var navTitle = UINavigationItem(title: "navTitle")
    
    var curTag = Int()
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        print("in did scroll")
    }
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return scrollView.subviews.first
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.

        ref = FIRDatabase.database().reference()

        
        // set up the observer for added events
        ref.child("Challenges").child((userChallenge?.id)!).observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in

            self.currChallenge = Challenge.initWith(snapshot: snapshot, id: (self.userChallenge?.id)!)
            
            
            self.updateView()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        getUserInfo()
        
    }

    func updateView() {
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://challengeme-75fd5.appspot.com")

//        currChallenge.name = userChallenge?.name
        
        navTitle.title = currChallenge.name
        
        self.title = currChallenge.name

        let theFrame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        
        let scrollView = UIScrollView(frame: theFrame)
        
        
        
        //scrollView.maximumZoomScale = 10.0;
        //scrollView.minimumZoomScale = 1.0;
        
        scrollView.delegate = self
        
        
        scrollView.backgroundColor = UIColor(red:0.05, green:0.75, blue:0.91, alpha:1.0)
        view.addSubview(scrollView)
        
        let lengthOfTimeline = CGFloat(currChallenge.events.count + 1)*80
        
        let bigFrame = CGRect(x:0, y:0, width: self.view.frame.width, height: lengthOfTimeline+100)
        let tlView = UIView(frame: bigFrame)
        tlView.backgroundColor = UIColor(red:0.05, green:0.75, blue:0.91, alpha:1.0)
        
        
        let path = UIBezierPath();
        path.move(to: CGPoint(x: self.view.frame.width/2, y: 0))
        path.addLine(to: CGPoint(x: self.view.frame.width/2, y: (lengthOfTimeline)))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 5.0
        shapeLayer.strokeColor = UIColor.black.cgColor
        tlView.layer.addSublayer(shapeLayer)
        
        // Right now I am just doing ten events
        // We need to query the DB (possibly done in previous VC and set as an array on segue to this VC), and iterate through all of the events.
        // For each event, we will check what user it is, and then add it to the given side of the timeline. Logged in user's challenges will be on the left. Opponent's challenges will be on the right.
        for each in currChallenge.events {
            let actualEventNum = Int(each.id!)!
            let spaceRef = storageRef.child("\(currChallenge.id!)/\(actualEventNum).jpg")
            print("\(currChallenge.id!)/\(actualEventNum).jpg")
            let path = UIBezierPath();
            let eventNum = Int(each.id!)! + 1
            let placeOnLine = CGFloat(eventNum*80)
            var imageFrameX = CGFloat()
            path.move(to: CGPoint(x: self.view.frame.width/2, y: placeOnLine))
            if (each.userId != self.uid) {
                path.addLine(to: CGPoint(x: self.view.frame.width/4, y: placeOnLine))
                imageFrameX = CGFloat((self.view.frame.width/4)-50)
            }
            else {
                path.addLine(to: CGPoint(x: (3*self.view.frame.width/4), y: placeOnLine))
                imageFrameX = CGFloat(3*self.view.frame.width/4)
            }
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.lineWidth = 5.0
            shapeLayer.strokeColor = UIColor.black.cgColor
            tlView.layer.addSublayer(shapeLayer)
            
            let eventButtonFrame = CGRect(x: imageFrameX, y: (placeOnLine - 25), width: 50, height: 50)
            let eventButton = UIButton(type: .custom)
            eventButton.frame = eventButtonFrame
            // Set button image!
            getPhoto(spaceRef: spaceRef, eventButton: eventButton)
            //let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/challengeme-75fd5.appspot.com/o/aa102079151492611708983341402682363502091082%2F3.jpg?alt=media&token=42ac1951-91b3-4fc5-ac35-785d0f3aa525")
            
            
            //eventButton.layer.cornerRadius = 25
            eventButton.layer.borderWidth = 3.0
            eventButton.layer.borderColor = UIColor.black.cgColor
            eventButton.layer.backgroundColor = UIColor.black.cgColor
            eventButton.tag = actualEventNum
            //          May want to set the eventButton tag to some type of id of the event
            eventButton.addTarget(self, action: #selector(eventButtonClick), for: UIControlEvents.touchUpInside)
            tlView.addSubview(eventButton)
        }
        
        if (currChallenge.status == 1) {
            let addButton = UIButton(type: .custom)
            addButton.frame = CGRect(x: ((self.view.frame.width/2)-25), y: lengthOfTimeline, width: 50, height: 50)
            addButton.layer.cornerRadius = 0.5*addButton.bounds.size.width
            addButton.layer.borderColor = UIColor.black.cgColor
            addButton.layer.borderWidth = 3.0
            addButton.clipsToBounds = true
            addButton.setImage(UIImage(named:"plus.png"), for: .normal)
            addButton.tag = 5
            addButton.addTarget(self, action: #selector(addButtonClick), for: UIControlEvents.touchUpInside)
            tlView.addSubview(addButton)
        }
        else {
            let addButton = UIButton(type: .custom)
            addButton.frame = CGRect(x: ((self.view.frame.width/2)-150), y: lengthOfTimeline, width: 300, height: 50)
            //            addButton.layer.cornerRadius = 0.5*addButton.bounds.size.width
            addButton.layer.borderColor = UIColor.black.cgColor
            addButton.layer.borderWidth = 3.0
            addButton.clipsToBounds = true
            addButton.setTitle("Completed!", for: .normal)
            //            addButton.setImage(UIImage(named:"plus.png"), for: .normal)
            //            addButton.tag = 5
            //            addButton.addTarget(self, action: #selector(addButtonClick), for: UIControlEvents.touchUpInside)
            tlView.addSubview(addButton)
        }
        
        
        scrollView.addSubview(tlView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: tlView.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addButtonClick(sender: UIButton) {
        if (sender.tag == 5) {
            self.performSegue(withIdentifier: "timelineToCreateEvent", sender: self)
        }
    }
    
    func eventButtonClick(sender: UIButton) {
        curTag = sender.tag
        self.performSegue(withIdentifier: "timelineToViewEvent", sender: self)
    }
    
    // This is what will be performed on segues from timeline to the View Event and Create Event Controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Segue for adding an event
        if segue.destination.isKind(of: AddEventVC.self) {
            // Things we will need here:
            // Figure out how many events have already been created (we already have to do this above to generate the timeline) and then set a variable in AddEventVC that indicates how many events already exist. We will then set the "id" of the event to one more than the number of events that exist (think about if we are going to index at 0 or 1).
            // I'm not sure if we will have to set this or if we can just get this value by virtue of being logged in, but we need to know the logged in User's ID so that we can associate the event with the proper user.
            let vc = segue.destination as! AddEventVC
            vc.currChallenge = currChallenge
        }
        if segue.destination.isKind(of: ChallengeInfoVC.self) {
            let vc = segue.destination as! ChallengeInfoVC
            vc.currChallenge = currChallenge
        }
        if segue.destination.isKind(of: ViewEventVC.self) {
            let vc = segue.destination as! ViewEventVC
            vc.currChallenge = currChallenge
            vc.eventTag = curTag
        }
    }
    
    
    func getPhoto(spaceRef: FIRStorageReference, eventButton: UIButton) {
        spaceRef.downloadURL { (URL, error) -> Void in
            if (error != nil) {
                // Handle any errors
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                self.getPhoto(spaceRef: spaceRef, eventButton: eventButton)
            } else {
                // Get the download URL for 'images/stars.jpg'
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: URL!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        eventButton.setImage(UIImage(data: data!), for: .normal)
                        // this is delayed by a cycle
                        self.view.setNeedsDisplay()
                        
                    }
                }
            }
        }
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
