//
//  ViewController.swift
//  Project2
//
//  Created by Grant Watson on 9/5/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries: [String] = []
    var score = 0
    var highScore = 0
    var correctAnswer = 0
    var questionCount = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark"), style: .plain, target: self, action: #selector(scoreTapped))
        
        askQuestion()
        
        let defaults = UserDefaults.standard
        if let savedHighScore = defaults.object(forKey: "highScore") as? Data {
            let decoder = JSONDecoder()
            do {
                highScore = try decoder.decode(Int.self, from: savedHighScore)
            } catch {
                print("Failed to fetch high score.")
            }
        }
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        questionCount += 1
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        let countryName = countries[correctAnswer].uppercased()
        title = "Guess: \(countryName)"
    }
    
    func resetGame(action: UIAlertAction! = nil) {
        questionCount = 0
        score = 0
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 5) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
            message = "Your score is \(score)."
        } else {
            title = "Wrong"
            score -= 1
            message = "That is the flag of \(countries[sender.tag].uppercased()). Your score is \(score)."
        }
        
        if questionCount == 10 {
            print(score)
            print(highScore)
            if score > highScore {
                let ac = UIAlertController(title: "New high score!", message: "Woah you just beat your high score of \(highScore). Awesome!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: resetGame))
                present(ac, animated: true)
                saveHighScore(score)
            } else {
                let finalAC = UIAlertController(title: "FINAL SCORE", message: "You scored \(score)", preferredStyle: .alert)
                finalAC.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetGame))
                present(finalAC, animated: true)
            }
        } else {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(ac, animated: true)
        }
        sender.transform = .identity
    }
    
    @objc func scoreTapped() {
        let score = score
        let ac = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func saveHighScore(_ score: Int) {
        let encoder = JSONEncoder()
        
        if let savedScore = try? encoder.encode(score) {
            let defaults = UserDefaults.standard
            defaults.set(savedScore, forKey: "highScore")
        } else {
            print("Failed to save high score.")
        }
    }
}

