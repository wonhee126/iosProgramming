//
//  BikeMeasurementViewController.swift
//  iosProgramming-Project-2171217-juwonhee
//
//  Created by juwonhee on 6/14/24.
//



//이용 시간: 분 단위로 표시.
//거리: 1초당 4.17미터 (0.00417km)로 계산.
//칼로리: 1분당 5.8 칼로리로 계산.
//탄소절감: 1km당 0.21kg CO2로 계산.



import UIKit

class BikeMeasurementViewController: UIViewController {

    @IBOutlet weak var arrivedButton: UIButton!
    
    var timer: Timer?
    var elapsedTime: TimeInterval = 0.0
    let stopwatchLabel = UILabel()
    let usageTimeLabel = UILabel()
    let distanceLabel = UILabel()
    let calorieLabel = UILabel()
    let carbonReductionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar() // 상단바
        setupStopwatchLabel()
        setupMetricsLabels()
        setupStartButton()
        setupStopButton()
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

    func setupStopwatchLabel() {
        stopwatchLabel.frame = CGRect(x: 0, y: 0, width: 199, height: 50)
        stopwatchLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        stopwatchLabel.font = UIFont(name: "Jua-Regular", size: 40)
        stopwatchLabel.text = "00:00:00초"
        
        let parent = self.view!
        parent.addSubview(stopwatchLabel)
        stopwatchLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stopwatchLabel.widthAnchor.constraint(equalToConstant: 199),
            stopwatchLabel.heightAnchor.constraint(equalToConstant: 50),
            stopwatchLabel.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 115),
            stopwatchLabel.topAnchor.constraint(equalTo: parent.topAnchor, constant: 242)
        ])
    }
    
    func setupMetricsLabels() {
        setupMetricLabel(label: usageTimeLabel, text: "이용시간: 0분", yPosition: 361)
        setupMetricLabel(label: distanceLabel, text: "거리: 0.00km", yPosition: 466)
        setupMetricLabel(label: calorieLabel, text: "칼로리: 0.0kcal", yPosition: 571)
        setupMetricLabel(label: carbonReductionLabel, text: "탄소절감: 0.0kg", yPosition: 676)
    }
    
    func setupMetricLabel(label: UILabel, text: String, yPosition: CGFloat) {
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 38)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Jua-Regular", size: 30)
        label.text = text
        
        let parent = self.view!
        parent.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 38),
            label.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 45),
            label.topAnchor.constraint(equalTo: parent.topAnchor, constant: yPosition)
        ])
    }

    func setupStartButton() {
        let startButton = UIButton(type: .system)
        startButton.setTitle("출발하기", for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Jua-Regular", size: 30)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        let parent = self.view!
        parent.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: parent.topAnchor, constant: 100)
        ])
    }

    func setupStopButton() {
        arrivedButton.setTitle("목적지 도착", for: .normal)
        arrivedButton.setTitleColor(.black, for: .normal)
        arrivedButton.backgroundColor = UIColor(red: 148/255, green: 206/255, blue: 204/255, alpha: 1.0)
        arrivedButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        arrivedButton.translatesAutoresizingMaskIntoConstraints = false
        
        let parent = self.view!
        parent.addSubview(arrivedButton)
        arrivedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrivedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            arrivedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arrivedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arrivedButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        

    }

    @objc func startButtonTapped() {
        startStopwatch()
    }
    
    @objc func stopButtonTapped() {
        stopStopwatch()
    }

    func startStopwatch() {
        timer?.invalidate()
        elapsedTime = 0.0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
    }
    
    @objc func updateStopwatch() {
        elapsedTime += 1.0
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) / 60) % 60
        let seconds = Int(elapsedTime) % 60
        stopwatchLabel.text = String(format: "%02d:%02d:%02d초", hours, minutes, seconds)
        
        // Update the metrics
        let totalSeconds = Int(elapsedTime)
        let totalMinutes = totalSeconds / 60 // elapsed time을 60으로 나누어 분 단위로 계산
        
        let distance = (elapsedTime * 4.17) / 1000.0 // km
        let calories = Double(totalMinutes) * 5.8 // totalMinutes를 Double로 변환하여 사용
        let carbonReduction = distance * 0.21 // assuming 0.21 kg CO2 per km
        
        usageTimeLabel.text = String(format: "이용시간: %d분", totalMinutes)
        distanceLabel.text = String(format: "거리: %.2fkm", distance)
        calorieLabel.text = String(format: "칼로리: %.1fkcal", calories)
        carbonReductionLabel.text = String(format: "탄소절감: %.2fkg", carbonReduction)
    }
    
    func stopStopwatch() {
        timer?.invalidate()
        timer = nil
    }
}
