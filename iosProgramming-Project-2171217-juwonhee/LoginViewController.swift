//
//  LoginViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/2/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Email and Password are required")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        let alert = UIAlertController(title: "Login Failed", message: "Failed to login. Please check your email and password.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                    } else {
                        print("User logged in successfully")
                        // 성공적으로 로그인 후 이전 화면으로 돌아가기
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            
            @IBAction func signUpButton(_ sender: UIButton) {
                let signupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
                self.navigationController?.pushViewController(signupViewController, animated: true)
            }
        }



