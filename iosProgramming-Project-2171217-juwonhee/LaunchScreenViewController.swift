////
////  LaunchScreenViewController.swift
////  iosProgramming-Project-2171217-juwonhee
////
////  Created by juwonhee on 6/3/24.
////
import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 자전구리 라벨
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label1.font = UIFont(name: "Jua-Regular", size: 30)
        label1.textAlignment = .center
        label1.text = "자전구리"
        self.view.addSubview(label1)
        
        NSLayoutConstraint.activate([
            label1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label1.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50) // Y축 위치 조정
        ])
        
        // 시민과 함께하는 친환경 이동수단 라벨
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label2.font = UIFont(name: "Jua-Regular", size: 25)
        label2.textAlignment = .center
        label2.text = "시민과 함께하는 친환경 이동수단"
        self.view.addSubview(label2)
        
        NSLayoutConstraint.activate([
            label2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 20)
        ])
        
        // 이미지 뷰
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bikeIcon.png")
        self.view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: label1.topAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 230),
            imageView.heightAnchor.constraint(equalToConstant: 243)
        ])
    }
}
