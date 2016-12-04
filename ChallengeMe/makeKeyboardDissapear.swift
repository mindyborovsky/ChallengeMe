//
//  makeKeyboardDissapear.swift
//  ChallengeMe
//
//  Created by George Daniel Mangum on 12/3/16.
//  Copyright © 2016 Mindy Borovsky. All rights reserved.
//

import Foundation
import UIKit

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
