//
//  StatsViewController.swift
//  ChallengeMe
//
//  Created by Mindy Borovsky on 12/3/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

class StatsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var winPercentageLabel: UILabel!
    @IBOutlet weak var challengesWonLabel: UILabel!
    @IBOutlet weak var challegesCompletedLabel: UILabel!

    
    var userName: String?
    var userId: String?
    var profileURL: URL?
    var challengesCompleted: Int?
    var challengesWon: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: this sucks, it might not be that bad.
        if let user = FIRAuth.auth()?.currentUser {
            // TODO: Multiple profiles?
            for profile in user.providerData {
                
                //let email = profile.email
                let photoURL = profile.photoURL
                userId = profile.uid
                userName = profile.displayName
                self.profileURL = photoURL
                
                DispatchQueue.global().async {
                    let dataContents = try? Data(contentsOf: photoURL!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    if let data = dataContents {
                        self.imageView.image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.updateView()
                            self.imageView.setNeedsDisplay()
                        }
                    } else {
                        // error fetching photoURL
                    }
                }
            }
            
        } else {
            
        }
        updateView()
        setUpObsever()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView() {
        titleLabel.text = "My Stats"
        if let total = challengesCompleted {
        challengesWonLabel.text = "Challenges Won: \(challengesWon!)"
        challegesCompletedLabel.text = "Challenges Completed: \(challengesCompleted!)"
            if total != 0 {
                let winPercentage = Double(challengesWon!) / Double(total) * 10000.0
                let winPercentageInt = winPercentage.rounded() / 100
            
                winPercentageLabel.text = "Win Percentage: \(winPercentageInt))"
            } else {
                winPercentageLabel.text = "You have no completed challenges!"
            }
        } else {
            winPercentageLabel.text = "You have no completed challenges!"
            challengesWonLabel.text = "Challenges Won: 0"
            challegesCompletedLabel.text = "Challenges Completed: 0"
        }
    }
    
    
    // MARK: - Data
    func setUpObsever() {
        if let uid = userId {
        let ref = FIRDatabase.database().reference()
        ref.child("Users/").child(uid).observe(FIRDataEventType.value, with: { (snapshot: FIRDataSnapshot) in
            
            let dict = snapshot.value as? NSDictionary ?? [:]
            let challenges = dict["Challenges"] as? NSDictionary ?? [:]
            self.challengesWon = dict["challengesWon"] as? Int ?? 0
            self.challengesCompleted = dict["challengesCompleted"] as? Int ?? 0
            
            self.calculateStats(challengesDict: challenges)
            
            self.updateView()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        }

        
    }
    
    func calculateStats(challengesDict: NSDictionary) {
        for value in challengesDict.allValues {
            let valueDict = value as? NSDictionary
            if let challengeDict = valueDict {
                let status = challengeDict["status"] as? Int ?? -1
                if status != -1 {
                    //let challenge = UserChallenge.initWith(dictionary: challengeDict)
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
