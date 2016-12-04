//
//  HomeTableVC.swift
//  ChallengeMe
//
//  Created by Mindy Borovsky on 11/14/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeTableVC: UITableViewController {
    
    //    var table: [Challenge] = () {
    //        challenges = [Challenge()]
    //
    //        return challenges
    //    }
    var challenges: [[UserChallenge]] = [[], [], []]
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    var selectedChallenge: UserChallenge?
    
    let sectionTitles = ["Pending Challenges", "Current Challenges", "Past Challenges"]
    
    var userID = String()
    
    // MARK: - Data
    func loadChallenges(_ uid: String) {

        ref.child("Users/\(uid)/Challenges").observe(FIRDataEventType.childChanged, with: { (snapshot: FIRDataSnapshot) in
            // TODO: Clean this up into a UserChallenge method
            let dict: NSDictionary = snapshot.value as! NSDictionary
            var name: String = ""
            var status: Int = 0
            var creator: Bool = true
            var opponent: String = ""
            var id: String = ""
            if let nameVal = dict.value(forKey: "name") {
                name = nameVal as! String
            }
            if let statusString = dict.value(forKey:"status") {
                status = statusString as! Int
            }
            if let creatorBool = dict.value(forKey:"creator") {
                creator = creatorBool as! Bool
                print(name)
                print(creatorBool as! Bool)
                print(creator)
            }
            if let opponentString = dict.value(forKey:"opponent") {
                opponent = opponentString as! String
            }
            if let idString = dict.value(forKey:"id") {
                id = idString as! String
            }
            
            
            let challenge = UserChallenge(creator: creator, name: name, status: status, opponent:opponent, id: id)
            
            // Remove the old challenge if it's still there
            var indexToRemove = (-1,-1)
            for i in 0..<3 {
                for j in 0..<self.challenges[i].count {
                    if self.challenges[i][j].id == challenge.id {
                        indexToRemove = (i,j)
                    }
                }
            }
            self.challenges[indexToRemove.0].remove(at:indexToRemove.1)
            if (status != -1){
                self.challenges[status].append(challenge)
            }
            
            // main thread
            self.tableView.reloadData()
        })
        // TODO: Use observe correctly and remove observers when necessary
        ref.child("Users/\(uid)/Challenges").observe(FIRDataEventType.childAdded, with: { (snapshot: FIRDataSnapshot) in
            //snapshot.value(forKey: )
            // TODO: need challenge id from value?
            let dict: NSDictionary = snapshot.value as! NSDictionary
            var name: String = ""
            var status: Int = 0
            var creator: Bool = true
            var opponent: String = ""
            var id: String = ""
            if let nameVal = dict.value(forKey: "name") {
                name = nameVal as! String
            }
            if let statusString = dict.value(forKey:"status") {
                status = statusString as! Int
            }
            if let creatorBool = dict.value(forKey:"creator") {
                creator = creatorBool as! Bool
                print(name)
                print(creatorBool as! Bool)
                print(creator)
            }
            if let opponentString = dict.value(forKey:"opponent") {
                opponent = opponentString as! String
            }
            if let idString = dict.value(forKey:"id") {
                id = idString as! String
            }
            
            
            let challenge = UserChallenge(creator: creator, name: name, status: status, opponent:opponent, id: id)
            // this is gonna crash if status is not correct
            if (status != -1){
                self.challenges[status].append(challenge)
            }
            // main thread
            self.tableView.reloadData()

            
            })
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TODO: this sucks
        if let user = FIRAuth.auth()?.currentUser {
            // TODO: Multiple profiles?
            for profile in user.providerData {
                
                
                let name = profile.displayName
                let email = profile.email
                //let photoURL = profile.photoURL
                let uid = profile.uid
                userID = profile.uid
                
                print(name!)
                print(uid)
                print(email!)
                
                // async
                loadChallenges(uid)
                
                
            }
            
        } else {
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        challenges = [[], [], []]
//        tableView.reloadData()
//        loadChallenges(userID)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // TODO: check for challenges status
        return challenges[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.text = challenges[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChallenge = challenges[indexPath.section][indexPath.row]
        if (selectedChallenge?.status != 0) {
            self.performSegue(withIdentifier: "TimelineSegue", sender: self)
        }
        else {
            if (selectedChallenge?.creator == false) {
                self.performSegue(withIdentifier: "AcceptSegue", sender: self)
            }
            
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    
      //MARK: - Navigation
    
      //In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: TimelineVC.self) {
            let vc = segue.destination as! TimelineVC
            vc.userChallenge = selectedChallenge!
        }
        if segue.destination.isKind(of: AcceptChallenge.self){
            let vc = segue.destination as! AcceptChallenge
            vc.userChallenge = selectedChallenge
        }
     }
 
    
}
