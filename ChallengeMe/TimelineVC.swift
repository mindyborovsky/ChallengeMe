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

class TimelineVC: UIViewController, UIScrollViewDelegate {
    
    var ref: FIRDatabaseReference!
    
    var currChallenge = Challenge()
    var userChallenge: UserChallenge?
    
    var navTitle = UINavigationItem(title: "navTitle")
    
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
        
        ref.child("Challenges").child((userChallenge?.id)!).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            // Get user value
            self.currChallenge = Challenge.initWith(snapshot: snapshot, id: (self.userChallenge?.id)!)
            
            
            self.updateView()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }

    func updateView() {
        print("Here")
//        currChallenge.name = userChallenge?.name
        
        navTitle.title = currChallenge.name
        
        self.title = currChallenge.name

        let theFrame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        
        let scrollView = UIScrollView(frame: theFrame)
        
        //scrollView.maximumZoomScale = 10.0;
        //scrollView.minimumZoomScale = 1.0;
        
        scrollView.delegate = self
        
        
        scrollView.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        
        let bigFrame = CGRect(x:0, y:0, width: self.view.frame.width, height: 1000)
        let tlView = UIView(frame: bigFrame)
        tlView.backgroundColor = UIColor(red:0.50, green:0.55, blue:0.55, alpha:1.0)
        
        
        let path = UIBezierPath();
        path.move(to: CGPoint(x: self.view.frame.width/2, y: 0))
        path.addLine(to: CGPoint(x: self.view.frame.width/2, y: (bigFrame.height*(7/8))))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 5.0
        shapeLayer.strokeColor = UIColor.black.cgColor
        tlView.layer.addSublayer(shapeLayer)
        
        // Right now I am just doing ten events
        // We need to query the DB (possibly done in previous VC and set as an array on segue to this VC), and iterate through all of the events.
        // For each event, we will check what user it is, and then add it to the given side of the timeline. Logged in user's challenges will be on the left. Opponent's challenges will be on the right.
        for each in 1...10 {
            let path = UIBezierPath();
            let placeOnLine = CGFloat(each*50)
            var imageFrameX = CGFloat()
            path.move(to: CGPoint(x: self.view.frame.width/2, y: placeOnLine))
            if (each % 2 == 0) {
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
            eventButton.layer.cornerRadius = 25
            eventButton.layer.borderWidth = 3.0
            eventButton.layer.borderColor = UIColor.black.cgColor
            eventButton.layer.backgroundColor = UIColor.black.cgColor
            //          May want to se the eventButton tag to some type of id of the event
            eventButton.addTarget(self, action: #selector(eventButtonClick), for: UIControlEvents.touchUpInside)
            tlView.addSubview(eventButton)
        }
        
        if (currChallenge.status == 1) {
            let addButton = UIButton(type: .custom)
            addButton.frame = CGRect(x: ((self.view.frame.width/2)-25), y: (bigFrame.height*(7/8)), width: 50, height: 50)
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
            addButton.frame = CGRect(x: ((self.view.frame.width/2)-150), y: (bigFrame.height*(7/8)), width: 300, height: 50)
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
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
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
