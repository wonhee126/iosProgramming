//
//  MypageViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/2/24.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class MypageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var allRecordListButton: UIButton!
    @IBOutlet weak var enjoyButton: UIButton!
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let emailLabel = UILabel()
    let usageLabel = UILabel()
    let usageTimeLabel = UILabel()
    let distanceLabel = UILabel()
    let caloriesLabel = UILabel()
    let carbonReductionLabel = UILabel()
    let usageDetailsContainer = UIView()
    let logoutButton = UIButton()
    let loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar() // 상단바
        
        if Auth.auth().currentUser != nil {
            // 로그인된 상태
            setupUI()
            fetchUserInfo()
        } else {
            // 로그인되지 않은 상태
            setupLoginButton()
            allRecordListButton.isHidden = true
            enjoyButton.isHidden = true
        }
        
        // 프로필 이미지에 tagGesture 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    @objc func profileImageViewTapped() {
           let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.sourceType = .photoLibrary // 앨범에서 사진 선택
           
           present(imagePickerController, animated: true, completion: nil)
       }
    
    // 사용자가 이미지 피커에서 이미지를 선택했을 때 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profileImageView.image = pickedImage
            }
            dismiss(animated: true, completion: nil)
        }
        
    // 사용자가 이미지 피커에서 취소 버튼을 눌렀을 때 호출
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        self.navigationItem.title = ""
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoImage = UIImage(named: "NavigatorIcon")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "EcoBike"
        titleLabel.font = UIFont.systemFont(ofSize: 8)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 36),
            imageView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        self.navigationItem.titleView = titleView
    }

    // 사용자가 로그인이 되어있을 때 보여주는 UI
    func setupUI() {
        view.backgroundColor = .white
        
        profileImageView.image = UIImage(named: "EcoBike")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFit
        view.addSubview(profileImageView)
        
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        
        emailLabel.font = UIFont.systemFont(ofSize: 18)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        usageLabel.text = "대여반납이력"
        usageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        usageLabel.translatesAutoresizingMaskIntoConstraints = false
        usageLabel.textAlignment = .left
        view.addSubview(usageLabel)
        
        usageDetailsContainer.layer.borderWidth = 3.0
        usageDetailsContainer.layer.borderColor = UIColor(red: 174/255, green: 225/255, blue: 223/255, alpha: 1).cgColor
        usageDetailsContainer.layer.cornerRadius = 10
        usageDetailsContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usageDetailsContainer)
        
        let usageDetailsStack = UIStackView()
        usageDetailsStack.axis = .vertical
        usageDetailsStack.alignment = .fill
        usageDetailsStack.spacing = 5
        usageDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        
        usageTimeLabel.text = "0 분"
        distanceLabel.text = "0.00 km"
        caloriesLabel.text = "0.00 kcal"
        carbonReductionLabel.text = "0.00 kg"
        
        let usageRow1 = createUsageRow(labelText: "이용시간", valueLabel: usageTimeLabel)
        let usageRow2 = createUsageRow(labelText: "거리", valueLabel: distanceLabel)
        let usageRow3 = createUsageRow(labelText: "칼로리", valueLabel: caloriesLabel)
        let usageRow4 = createUsageRow(labelText: "탄소절감", valueLabel: carbonReductionLabel)
        
        view.addSubview(allRecordListButton)
        allRecordListButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        usageDetailsStack.addArrangedSubview(usageRow1)
        usageDetailsStack.addArrangedSubview(usageRow2)
        usageDetailsStack.addArrangedSubview(usageRow3)
        usageDetailsStack.addArrangedSubview(usageRow4)
        
        usageDetailsContainer.addSubview(usageDetailsStack)
        
        enjoyButton.setTitle("즐겨찾기", for: .normal)
        enjoyButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        enjoyButton.setTitleColor(.black, for: .normal)
        enjoyButton.layer.cornerRadius = 5
        enjoyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enjoyButton)
        
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.layer.cornerRadius = 5
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside) // 로그아웃 버튼 액션 추가
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
               
            nicknameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nicknameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nicknameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            
            usageLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            usageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            allRecordListButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            allRecordListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            usageDetailsContainer.topAnchor.constraint(equalTo: usageLabel.bottomAnchor, constant: 10),
            usageDetailsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usageDetailsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            usageDetailsStack.topAnchor.constraint(equalTo: usageDetailsContainer.topAnchor, constant: 10),
            usageDetailsStack.leadingAnchor.constraint(equalTo: usageDetailsContainer.leadingAnchor, constant: 10),
            usageDetailsStack.trailingAnchor.constraint(equalTo: usageDetailsContainer.trailingAnchor, constant: -10),
           
            usageDetailsStack.bottomAnchor.constraint(equalTo: usageDetailsContainer.bottomAnchor, constant: -10),
            
            enjoyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            enjoyButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            enjoyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            enjoyButton.heightAnchor.constraint(equalToConstant: 50),
            
            logoutButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        

    }

    func createUsageRow(labelText: String, valueLabel: UILabel) -> UIStackView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.alignment = .fill
        rowStack.spacing = 5
        rowStack.distribution = .equalSpacing
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = labelText
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        valueLabel.font = UIFont.systemFont(ofSize: 16)
        
        rowStack.addArrangedSubview(label)
        rowStack.addArrangedSubview(valueLabel)
        
        return rowStack
    }
    
    // 로그인한 사용자별로 현재까지의 합산된 기록 출력
    func fetchUserHistory() {
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }
        
        let _: Void = db.collection("history").document("bikelist")
            .collection(user.email!).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching user history: \(error.localizedDescription)")
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                print("No documents found.")
                return
            }
            
            var totalUsageTime: Int = 0
            var totalDistance: Double = 0.0
            var totalCalories: Double = 0.0
            var totalCarbonReduction: Double = 0.0
            
            for document in querySnapshot.documents {
                let data = document.data()
                if let usageTime = data["usageTime"] as? Int {
                    totalUsageTime += usageTime
                }
                if let distance = data["distance"] as? Double {
                    totalDistance += distance
                }
                if let calories = data["calories"] as? Double {
                    totalCalories += calories
                }
                if let carbonReduction = data["carbonReduction"] as? Double {
                    totalCarbonReduction += carbonReduction
                }
            }
            
            DispatchQueue.main.async { // UI 업데이트를 메인 스레드에서 안전하게 수행
                self.usageTimeLabel.text = "\(totalUsageTime) 분"
                self.distanceLabel.text = String(format: "%.2f km", totalDistance)
                self.caloriesLabel.text = String(format: "%.2f kcal", totalCalories)
                self.carbonReductionLabel.text = String(format: "%.2f kg", totalCarbonReduction)
            }
        }
    }

    func fetchUserInfo() { // 로그인한 사용자 정보 출력
        let user = Auth.auth().currentUser!
        let email = user.email ?? "Unknown Email"
        let uid = user.uid
        
        let db = Firestore.firestore()
        db.collection("Users").document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let nickname = data?["nickname"] as? String ?? "Unknown Nickname"
                self.updateUI(email: email, nickname: nickname) // 닉네임과 이메일 출력
                self.fetchUserHistory() // 로그인한 사용자별로 현재까지의 합산된 기록 출력
            } else {
                print("Document does not exist")
                if let error = error {
                    print("Error fetching document: \(error)")
                }
            }
        }
    }
    
    func updateUI(email: String, nickname: String) {
        DispatchQueue.main.async { // UI 업데이트를 메인 스레드에서 안전하게 수행
            self.nicknameLabel.text = "\(nickname)님"
            self.emailLabel.text = "\(email)"

        }
    }

    @objc func logoutButtonTapped() {
        //print("here!!!11111")
        resetBikeRecordInFirestore() // 이용권 구매에서 선택한 출발지와 도착지 초기화
        do {
            try Auth.auth().signOut()
            navigateToLoginScreen() // 로그인 페이지로 이동
        } catch {
            print("Error signing out:", error)
        }
    }

    func navigateToLoginScreen() { // 로그인 페이지로 이동
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else {
            print("LoginViewController not found")
            return
        }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    func setupLoginButton() { // 사용자가 로그인하지 않았을 때 보이는 UI
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = UIColor(red: 174/255, green: 225/255, blue: 223/255, alpha: 1)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func loginButtonTapped() { // 로그인 페이지로 이동
        navigateToLoginScreen()
    }
    
    func resetBikeRecordInFirestore() {
        //print("here!!22222")
        guard let user = Auth.auth().currentUser else {
            print("User not logged in.")
            return
        }
        let docRef = db.collection("Users").document(user.uid)
                         .collection("history").document("bikeList")
                         .collection("1").document("record")
        
        let defaultStartLocation = "출발지를 설정해주세요"
        let defaultEndLocation = "도착지를 설정해주세요"
        let startTimestamp = Timestamp(date: Date())
        let endTimestamp = Timestamp(date: Date())
        //print("here!!333333")
        // 데이터 초기화 작업
        docRef.updateData([
                "startLocation": defaultStartLocation,
                "startTimestamp": startTimestamp,
                "startType": "",
                "endLocation": defaultEndLocation,
                "endTimestamp": endTimestamp,
                "endType": ""
      
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
}

