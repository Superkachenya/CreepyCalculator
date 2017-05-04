//
//  ViewController.swift
//  CreepyCalculator
//
//  Created by Danil on 22.02.17.
//  Copyright © 2017 Danil. All rights reserved.
//

import UIKit
import AVFoundation

class CreepyCalculatorVC: UIViewController {
    
    enum Operation: String {
        case add = "+"
        case substract = "-"
        case divide = "/"
        case multiply = "*"
        case empty = "Empty"
    }
    
    //MARK: Properties
    @IBOutlet weak var resultLabel: UILabel!
    
    var buttonSound: AVAudioPlayer!
    
    var runningDigit = ""
    var leftDigit = ""
    var rightDigit = ""
    var result = ""
    var currentOperation = Operation.empty
    
    //MARK: Methods
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOf: soundURL)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.localizedDescription)
        }
        
        resultLabel.text = "0"
    }
    
    //MARK: Digits
    @IBAction func actionDigitNumberPressed(_ sender: UIButton) {
        playSound()
        
        runningDigit += "\(sender.tag)"
        resultLabel.text = runningDigit
    }
    
    //MARK: Operators
    @IBAction func actionSubstractPressed(_ sender: UIButton) {
        calculate(operation: .substract)
    }
    
    @IBAction func actionAddPressed(_ sender: UIButton) {
        calculate(operation: .add)
    }
    
    @IBAction func actionDividePressed(_ sender: UIButton) {
        calculate(operation: .divide)
    }
    
    @IBAction func actionMultiplyPressed(_ sender: UIButton) {
        calculate(operation: .multiply)
    }
    
    @IBAction func actionEqualsPressed(_ sender: UIButton) {
        calculate(operation: currentOperation)
    }
    
    @IBAction func actionClearPressed(_ sender: Any) {
        playSound()
        
        runningDigit = ""
        leftDigit = ""
        rightDigit = ""
        result = ""
        resultLabel.text = "0"
        currentOperation = Operation.empty
    }
    //MARK: Private
    func playSound() {
        if buttonSound.isPlaying {
            buttonSound.stop()
        }
        buttonSound.play()
    }
    
    func calculate(operation:Operation) {
        playSound()
        
        if currentOperation != .empty {
            //A user selected an operator, but then selected another operator without first entering a number
            if runningDigit != "" {
                rightDigit = runningDigit
                runningDigit = ""
                if currentOperation == .add {
                    result = "\(Double(leftDigit)! + Double(rightDigit)!)"
                } else if currentOperation == .substract {
                    result = "\(Double(leftDigit)! - Double(rightDigit)!)"
                } else if currentOperation == .divide {
                    result = "\(Double(leftDigit)! / Double(rightDigit)!)"
                } else if currentOperation == .multiply {
                    result = "\(Double(leftDigit)! * Double(rightDigit)!)"
                }
                leftDigit = result
                resultLabel.text = result
            }
            currentOperation = operation
        } else {
            //This is the first time an operator has been pressed
            leftDigit = runningDigit
            runningDigit = ""
            currentOperation = operation
        }
    }
    
}

