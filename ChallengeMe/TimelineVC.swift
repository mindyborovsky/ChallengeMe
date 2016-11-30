//
//  TimelineVC.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 11/17/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit

class TimelineVC: UIViewController, UIScrollViewDelegate {
    
    
    var currChallenge = Challenge(name: "name", opponent: "test", creatorID: 2932, goal: "test2", goal2: "test4", reward: "test3", status: 0)
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

        currChallenge.name = userChallenge?.name
        
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
            
            let eventImgFrame = CGRect(x: imageFrameX, y: (placeOnLine - 25), width: 50, height: 50)
            let eventImg = UIImageView(frame: eventImgFrame)
            eventImg.layer.cornerRadius = 25
            eventImg.layer.borderWidth = 3.0
            eventImg.layer.borderColor = UIColor.black.cgColor
            eventImg.layer.backgroundColor = UIColor.black.cgColor
            
            tlView.addSubview(eventImg)
        }
        
        let addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: ((self.view.frame.width/2)-25), y: (bigFrame.height*(7/8)), width: 50, height: 50)
        addButton.layer.cornerRadius = 0.5*addButton.bounds.size.width
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.borderWidth = 3.0
        addButton.clipsToBounds = true
        addButton.setImage(UIImage(named:"plus.png"), for: .normal)
        //addButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        tlView.addSubview(addButton)
        
        scrollView.addSubview(tlView)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
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
