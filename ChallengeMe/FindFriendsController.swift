//
//  FindFriendsController.swift
//  ChallengeMe
//
//  Created by Mindy Borovsky on 11/18/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKShareKit

class FindFriendsController: UITableViewController {
    
    var reuseIdentifier = "friendCell"

    var user: FIRUser?
    var friends: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
            // TODO: Multiple profiles?
            for profile in user.providerData {
                
                
                let name = profile.displayName
                let email = profile.email
                //let photoURL = profile.photoURL
                let uid = profile.uid
                
                print(name!)
                print(uid)
                print(email!)
                findFriends(uid: uid)
            }
            
        } else {
            print("Error with getting user")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }
    
    
    func findFriends(uid: String) -> Void {
        //let params = {}
        let friendsRequest : FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "/\(uid)/friends", parameters: nil)
        friendsRequest.start { (connection, result, error) in
            let resultdict = result as! NSDictionary
            print("Result Dict: \(resultdict)")
            let data = resultdict.value(forKey: "data") as! NSArray
            
            for i in 0..<data.count {
                let valueDict : NSDictionary = data[i] as! NSDictionary
                let id = valueDict.value(forKey:"id") as! String
                let name = valueDict.value(forKey: "name") as! String
                let friend = User(uid: id, name: name)
                self.friends.append(friend)
            }
            
            let friends = resultdict.value(forKey: "data") as! NSArray
            print("Found \(friends.count) friends")
            
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell...
        cell.textLabel!.text = friends[indexPath.row].name

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
