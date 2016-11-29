//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {

    // rlr: create an instance of the Questions class
    var questions = Questions()
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var letterButtonPressed: Character = "?"
    
    var gameSound: SystemSoundID = 0
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!

    // my new buttons
    @IBOutlet weak var AButton: UIButton!
    @IBOutlet weak var BButton: UIButton!
    @IBOutlet weak var CButton: UIButton!
    @IBOutlet weak var DButton: UIButton!

    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        questionField.text = questions.getUniqueRandomQuestion()
        
        // hide all input controls
        trueButton.isHidden = true
        falseButton.isHidden = true
        AButton.isHidden = true
        BButton.isHidden = true
        CButton.isHidden = true
        DButton.isHidden = true

// these are not ready yet
//        numberInput.isHidden = true
//        textInputControl.ishidden = true
        
        // unhide the needed input control
        switch questions.getQuestionType() {
            case .trueFalse:
                trueButton.isHidden = false
                falseButton.isHidden = false
            case .letter:
                AButton.isHidden = false
                BButton.isHidden = false
                CButton.isHidden = false
                DButton.isHidden = false
            case .number:
//                numberInput.isHidden = false
                AButton.isHidden = false // until I get a number input in place
            
            case .text:
//                textInputControl.ishidden = false
                AButton.isHidden = false // until I get a text input in place
            default:
                // error - unexpected answerType
                print("unexpected answerType")
        }
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        trueButton.isHidden = true
        falseButton.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    // I want a click of the AButton to be handled by checkAnswer() (below)
    @IBAction func AButton(_ sender: AnyObject) {
        letterButtonPressed = "A"
    }
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        var isCorrect: Bool = false

        // Increment the questions asked counter
        questionsAsked += 1
        
        switch sender {
            case trueButton:
                if questions.checkAnswer(type: Questions.answerTypes.trueFalse, boolAnswer: true, letterAnswer: " ", numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }

            case falseButton:
                if questions.checkAnswer(type: Questions.answerTypes.trueFalse, boolAnswer: false, letterAnswer: " ", numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case AButton:
                if questions.checkAnswer(type: Questions.answerTypes.letter, boolAnswer: true, letterAnswer: "A", numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case BButton:
                if questions.checkAnswer(type: Questions.answerTypes.letter, boolAnswer: true, letterAnswer: "B", numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case CButton:
                if questions.checkAnswer(type: Questions.answerTypes.letter, boolAnswer: true, letterAnswer: "C", numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case DButton: questionField.text = "DButton"
                if questions.checkAnswer(type: Questions.answerTypes.letter, boolAnswer: true, letterAnswer: "D", numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            default: questionField.text = sender.description
            
        }

        if isCorrect {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

