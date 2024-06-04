//
//  SignupViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/2/24.
//



import UIKit
import FirebaseFirestore

class SignupViewController: UIViewController {
    

//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    @IBAction func signupButtonTapped(_ sender: UIButton) {
//    @IBAction func signupButtonTapped(_ sender: UIButton) {
    
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
    
//    guard let name = nameTextField.text,
//              let email = emailTextField.text,
//              let password = passwordTextField.text else {
//            return
//        }
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
                return
            }
        
        
        // Firestore에 사용자 데이터 저장
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document() // 새로운 문서 생성
                userRef.setData([
//            "name": name,
            "email": email,
            "password": password
            // 비밀번호는 보안상 절대 저장해서는 안 됩니다.
            // 대신에 Firebase Authentication으로 인증된 사용자의 UID를 사용하여 연결할 수 있습니다.
        ]) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added successfully")
                self.navigateToLogin()
                // 회원가입 성공 후 다음 화면으로 이동하거나 로직을 추가할 수 있습니다.
            }
        }
    }
    
    func navigateToLogin() {
            if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                navigationController?.pushViewController(loginViewController, animated: true)
            }
        }
    
}



