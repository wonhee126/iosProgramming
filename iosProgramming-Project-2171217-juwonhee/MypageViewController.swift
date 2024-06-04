//
//  MypageViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/2/24.
//

import UIKit
import FirebaseAuth

class MypageViewController: UIViewController {
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}



//let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//self.navigationController?.pushViewController(loginViewController, animated: true)



