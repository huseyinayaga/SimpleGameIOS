//
//  ViewController.swift
//  CatchTheKenny
//
//  Created by Hüseyin Ayağa on 19.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private func generalLabel(text: String, font: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    let imageStack: UIStackView = {
        let stack = UIStackView()
        stack.layer.cornerRadius = 20
        stack.backgroundColor = .systemBlue
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    let kennyImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "kenny"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    private var counter = 20 {
        didSet {
            counterLbl.text = "\(counter)"
        }
    }
    private var highScore: Int = 0 {
        didSet {
            highScoreLbl.text = "High Score: \(highScore)"
        }
    }
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let counterLbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let highScoreLbl: UILabel = {
        let label = UILabel()
        label.text = "High Score: 0"
        label.font = .systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startButton: UIButton = {
        let buton = UIButton()
        buton.setTitle("Start", for: .normal)
        buton.backgroundColor = .systemBlue
        buton.setTitleColor(.orange, for: .normal)
        buton.layer.cornerRadius = 10
        buton.translatesAutoresizingMaskIntoConstraints = false
        return buton
    }()
   
    private var animationDuration: TimeInterval = 0.2
    private var timer1: Timer?
    private var timer2: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(counterLbl)
        view.addSubview(scoreLabel)
        view.addSubview(startButton)
        view.addSubview(imageStack)
        imageStack.addArrangedSubview(kennyImage)
        view.addSubview(highScoreLbl)
        
        setupConstraints()
        
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        kennyImage.addGestureRecognizer(tapGesture)
        kennyImage.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            counterLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            counterLbl.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: counterLbl.bottomAnchor, constant: 20),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 15),
            
            imageStack.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.95),
            imageStack.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.50),
            imageStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageStack.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            
            kennyImage.widthAnchor.constraint(equalTo: imageStack.widthAnchor, multiplier: 0.3),
            kennyImage.heightAnchor.constraint(equalTo: imageStack.heightAnchor, multiplier: 0.3),
            
            highScoreLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            highScoreLbl.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    @objc private func counterDown() {
        counter -= 1
        if counter == 0 {
            if score > highScore {
                self.highScore = score
            }
            endGame()
        }
        counterLbl.text = String(counter)
    }

    @objc private func imageTapped() {
        score += 1
    }

    @objc private func startGame() {
        self.kennyImage.isUserInteractionEnabled = true
        self.counter = 20
        self.score = 0
        self.timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.counterDown), userInfo: nil, repeats: true)
        self.startMovingImage()
    }

    private func startMovingImage() {
        timer1 = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(moveImage), userInfo: nil, repeats: true)
    }

    @objc private func moveImage() {
        let stackWidth = imageStack.frame.width
        let stackHeight = imageStack.frame.height

        let newX = CGFloat.random(in: 0...(stackWidth - kennyImage.frame.width))
        let newY = CGFloat.random(in: 0...(stackHeight - kennyImage.frame.height))

        UIView.animate(withDuration: animationDuration) {
            self.kennyImage.center = CGPoint(x: newX + (self.kennyImage.frame.width / 2), y: newY + (self.kennyImage.frame.height / 2))
        }
    }

    private func endGame() {
        timer2?.invalidate()
        timer1?.invalidate()
        let alertcontroller = UIAlertController(title: "Süre Bitti", message: "Süreniz bitti, tekrar oynamak ister misiniz?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Vazgeç", style: .cancel) { _ in
            self.score = 0
            self.kennyImage.isUserInteractionEnabled = false
        }
        let replayButton = UIAlertAction(title: "Oyna", style: .default) { _ in
            self.startGame()
        }
        alertcontroller.addAction(cancelButton)
        alertcontroller.addAction(replayButton)
        self.present(alertcontroller, animated: true)
    }
}
