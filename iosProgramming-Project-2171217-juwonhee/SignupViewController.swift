//
//  SignupViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/2/24.
//



import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
    
    var nicknameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomViews()

    }
    
    @objc func backButtonTapped() {
           dismiss(animated: true, completion: nil)
       }
    
    func setupCustomViews() {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "EcoBike")
        logoImageView.contentMode = .scaleAspectFit
        self.view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "EcoBike"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        let nicknameContainerView = createContainerView()
        self.view.addSubview(nicknameContainerView)
        NSLayoutConstraint.activate([
            nicknameContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nicknameContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            nicknameContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            nicknameContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        nicknameTextField = createTextField(placeholder: "닉네임")
        nicknameContainerView.addSubview(nicknameTextField)
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: nicknameContainerView.topAnchor),
            nicknameTextField.leadingAnchor.constraint(equalTo: nicknameContainerView.leadingAnchor, constant: 10),
            nicknameTextField.trailingAnchor.constraint(equalTo: nicknameContainerView.trailingAnchor, constant: -10),
            nicknameTextField.bottomAnchor.constraint(equalTo: nicknameContainerView.bottomAnchor)
        ])
        
        let emailContainerView = createContainerView()
        self.view.addSubview(emailContainerView)
        NSLayoutConstraint.activate([
            emailContainerView.topAnchor.constraint(equalTo: nicknameContainerView.bottomAnchor, constant: 20),
            emailContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            emailContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            emailContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        emailTextField = createTextField(placeholder: "이메일")
        emailContainerView.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailContainerView.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor, constant: -10),
            emailTextField.bottomAnchor.constraint(equalTo: emailContainerView.bottomAnchor)
        ])
        
        let passwordContainerView = createContainerView()
        self.view.addSubview(passwordContainerView)
        NSLayoutConstraint.activate([
            passwordContainerView.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 20),
            passwordContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            passwordContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            passwordContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        passwordTextField = createTextField(placeholder: "비밀번호")
        passwordTextField.isSecureTextEntry = true
        passwordContainerView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordContainerView.topAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainerView.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordContainerView.trailingAnchor, constant: -10),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordContainerView.bottomAnchor)
        ])
        
        let signUpButton = UIButton(type: .system)
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 5
        signUpButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 40),
            signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 150),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("뒤로가기", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.layer.cornerRadius = 5
        backButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 150),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createContainerView() -> UIView {
        let containerView = UIView()
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0).cgColor
        containerView.layer.cornerRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    @objc func signupButtonTapped() {
        guard let nickname = nicknameTextField.text, !nickname.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("모든 필드를 입력해야 합니다.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("회원가입 실패: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                print("회원가입 실패: 사용자 정보를 가져올 수 없습니다.")
                return
            }
            
            let db = Firestore.firestore()
            let userRef = db.collection("Users").document(user.uid)
            userRef.setData([
                "nickname": nickname,
                "email": email
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document added successfully")
                    self.navigateToLoginScreen()
                }
            }
        }
    }
    
    func navigateToLoginScreen() {
        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            loginViewController.modalPresentationStyle = .fullScreen
            present(loginViewController, animated: true, completion: nil)
        }
    }
}



