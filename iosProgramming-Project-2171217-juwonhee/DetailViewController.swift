//
//  DetailViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/14/24.
//

import UIKit

class DetailViewController: UIViewController {

    var bikeRecord: BikeRecord?
    
    @IBOutlet weak var carbonReductionLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var usageTimeLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var startLocationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var backgroundView1: UIView!
    
        let grayView1: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            view.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
            view.layer.cornerRadius = 25.0
            return view
        }() // 출발지 view
    
        let greenView1: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            view.backgroundColor = UIColor(red: 0.58, green: 0.808, blue: 0.8, alpha: 1)
            view.layer.cornerRadius = 25.0
            return view
        }()
    
    let middleCircleView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        view.layer.cornerRadius = 10.0
        return view
    }()
    let middleCircleView2: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        view.layer.cornerRadius = 10.0
        return view
        
    }()
    
        let dividerView: UIView = {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 1, height: 100) // 세로선
            let stroke = UIView()
            stroke.frame = view.bounds.insetBy(dx: -0.5, dy: -0.5)
            stroke.backgroundColor = UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
            view.addSubview(stroke)
            return view
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            setupNavigationBar()
            setupUI()
            updateUI()
        }
        

    
    func setupUI() {
        let views = [greenView1, grayView1, middleCircleView,middleCircleView2,endLocationLabel, startLocationLabel, startTimeLabel, endTimeLabel, dividerView]

        views.forEach { view in
            guard let view = view else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
            if !self.view.subviews.contains(view) {
                self.view.addSubview(view)
            }
        }
        
        backgroundView1.frame = CGRect(x: 0, y: 0, width: 200, height: 184)
        backgroundView1.backgroundColor = UIColor(red: 0.58, green: 0.808, blue: 0.8, alpha: 1)
        
        startLocationLabel.textColor = .black
        
        startLocationLabel.font = UIFont(name: "Jua-Regular", size: 10)
        startLocationLabel.textAlignment = .center
        startLocationLabel.numberOfLines = 3

        endLocationLabel.textColor = UIColor.black
        endLocationLabel.font = UIFont(name: "Jua-Regular", size: 10)
        endLocationLabel.textAlignment = .center
        endLocationLabel.numberOfLines = 3
        
        startTimeLabel.frame = CGRect(x: 0, y: 0, width: 82, height: 31)
        startTimeLabel.textColor = UIColor.black
        startTimeLabel.font = UIFont(name: "Jua-Regular", size: 10)
        startTimeLabel.textAlignment = .center
        startTimeLabel.numberOfLines = 2

        endTimeLabel.frame = CGRect(x: 0, y: 0, width: 82, height: 31)
        endTimeLabel.textColor = UIColor.black
        endTimeLabel.font = UIFont(name: "Jua-Regular", size: 10)
        endTimeLabel.textAlignment = .center
        endTimeLabel.numberOfLines = 2
        
            NSLayoutConstraint.activate([

                backgroundView1.heightAnchor.constraint(equalToConstant: 180),
                backgroundView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                backgroundView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                backgroundView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),

                grayView1.widthAnchor.constraint(equalToConstant: 50),
                grayView1.heightAnchor.constraint(equalToConstant: 50),
                grayView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
                grayView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 352),
                
                greenView1.widthAnchor.constraint(equalToConstant: 50),
                greenView1.heightAnchor.constraint(equalToConstant: 50),
                greenView1.leadingAnchor.constraint(equalTo: grayView1.leadingAnchor),
                greenView1.topAnchor.constraint(equalTo: grayView1.topAnchor, constant: 150),

                
                endLocationLabel.widthAnchor.constraint(equalToConstant: 120),
                endLocationLabel.leadingAnchor.constraint(equalTo: greenView1.trailingAnchor, constant: 10),
                endLocationLabel.topAnchor.constraint(equalTo: startLocationLabel.topAnchor, constant: 150),
                
                startLocationLabel.widthAnchor.constraint(equalToConstant: 120),
                startLocationLabel.leadingAnchor.constraint(equalTo: grayView1.trailingAnchor, constant: 10),
                startLocationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 361),
                
                startTimeLabel.widthAnchor.constraint(equalToConstant: 120),
                startTimeLabel.leadingAnchor.constraint(equalTo: startLocationLabel.trailingAnchor, constant: 10),
                startTimeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 361),

                endTimeLabel.widthAnchor.constraint(equalToConstant: 120),
                endTimeLabel.leadingAnchor.constraint(equalTo: endLocationLabel.trailingAnchor, constant: 10),
                endTimeLabel.topAnchor.constraint(equalTo: startTimeLabel.topAnchor, constant: 150),
                
                dividerView.widthAnchor.constraint(equalToConstant: 1),
                   dividerView.centerXAnchor.constraint(equalTo: grayView1.centerXAnchor),
                   dividerView.topAnchor.constraint(equalTo: grayView1.bottomAnchor),
                   dividerView.bottomAnchor.constraint(equalTo: greenView1.topAnchor),
                
                middleCircleView.widthAnchor.constraint(equalToConstant: 20),
                middleCircleView.heightAnchor.constraint(equalToConstant: 20),
                middleCircleView.centerXAnchor.constraint(equalTo: grayView1.centerXAnchor),
                middleCircleView.centerYAnchor.constraint(equalTo: grayView1.centerYAnchor),
                
                middleCircleView2.widthAnchor.constraint(equalToConstant: 20),
                middleCircleView2.heightAnchor.constraint(equalToConstant: 20),
                middleCircleView2.centerXAnchor.constraint(equalTo: greenView1.centerXAnchor),
                middleCircleView2.centerYAnchor.constraint(equalTo: greenView1.centerYAnchor),
                
           ])
       }
                
        func updateUI() {
            guard let record = bikeRecord else {
                print("자전거 기록이 없습니다.")
                return
            }
            
            startLocationLabel.text = "\(record.startLocation)"
            endLocationLabel.text = "\(record.endLocation)"
            usageTimeLabel.text = "이용 시간: \(record.usageTime) 분"
            distanceLabel.text = String(format: "거리: %.2f km", record.distance)
            caloriesLabel.text = String(format: "칼로리 소모: %.1f kcal", record.calories)
            carbonReductionLabel.text = String(format: "탄소 절감: %.3f kg", record.carbonReduction)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone.current
            
            startTimeLabel.text = "\(dateFormatter.string(from: record.startTime))"
            endTimeLabel.text = "\(dateFormatter.string(from: record.endTime))"
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
    
    }
