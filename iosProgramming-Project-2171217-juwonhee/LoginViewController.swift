import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomViews()
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
        
        let emailContainerView = UIView()
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = UIColor.systemTeal.cgColor
        emailContainerView.layer.cornerRadius = 5
        self.view.addSubview(emailContainerView)
        emailContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            emailContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            emailContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        emailTextField = UITextField()
        emailTextField.placeholder = "아이디"
        emailContainerView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailContainerView.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: emailContainerView.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: emailContainerView.trailingAnchor, constant: -10),
            emailTextField.bottomAnchor.constraint(equalTo: emailContainerView.bottomAnchor)
        ])
        
        let passwordContainerView = UIView()
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = UIColor.systemTeal.cgColor
        passwordContainerView.layer.cornerRadius = 5
        self.view.addSubview(passwordContainerView)
        passwordContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordContainerView.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 20),
            passwordContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            passwordContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            passwordContainerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "비밀번호"
        passwordContainerView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordContainerView.topAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordContainerView.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordContainerView.trailingAnchor, constant: -10),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordContainerView.bottomAnchor)
        ])
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = UIColor.systemTeal
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        self.view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let signUpButton = UIButton(type: .system)
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.backgroundColor = UIColor.systemTeal
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 5
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: 40),
            signUpButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            signUpButton.widthAnchor.constraint(equalToConstant: 150),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
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
//                self.dismiss(animated: true, completion: nil)
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                mainTabBarController.modalPresentationStyle = .fullScreen
                self.present(mainTabBarController, animated: true, completion: nil)
            }
        }
    }

    @objc func signUpButtonTapped(_ sender: UIButton) {
        if let signupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
            signupViewController.modalPresentationStyle = .fullScreen
            self.present(signupViewController, animated: true, completion: nil)
        } else {
            print("SignupViewController not found")
        }
    }
}

