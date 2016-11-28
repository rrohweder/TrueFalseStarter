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
    var questionData: Questions.QuestionAnswer
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
        questionData = questions.getUniqueRandomQuestion()
        questionField.text = questionData.question
        // hide all input controls
        trueButton.isHidden = true
        falseButton.isHidden = true
        AButton.isHidden = true
        BButton.isHidden = true
        CButton.isHidden = true
        DButton.isHidden = true
//        numberInputControl.isHidden = true
//        textInputControl.ishidden = true
        // unhide the needed input control
        switch questionData.answerType {
            case Questions.answerTypes.trueFalse:
                trueButton.isHidden = false
                falseButton.isHidden = false
            case Questions.answerTypes.letter:
                AButton.isHidden = false
                BButton.isHidden = false
                CButton.isHidden = false
                DButton.isHidden = false
            case Questions.answerTypes.number:
//                numberInputControl.isHidden = false
                AButton.isHidden = false // until I get a number input in place
            
            case Questions.answerTypes.text:
//                textInputControl.ishidden = false
                AButton.isHidden = false // until I get a number input in place
            default:
                // error - unexpected answerType
                print("unexpected answerType: \"\(questionData.answerType)\"")
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
    
    
//    @IBAction func AButton(_ sender: AnyObject) {
//        letterButtonPressed = "A"
//    }
//    
//    @IBAction func BButton(_ sender: AnyObject) {
//        letterButtonPressed = "B"
//    }
//    
//    @IBAction func CButton(_ sender: AnyObject) {
//        letterButtonPressed = "C"
//    }
//    
//    @IBAction func DButton(_ sender: AnyObject) {
//        letterButtonPressed = "D"
//    }
    
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
//        let selectedQuestionDict = questions[indexOfSelectedQuestion].
//        let correctAnswer = selectedQuestionDict["Answer"]
//        
//        if (sender === trueButton &&  correctAnswer == "True") || (sender === falseButton && correctAnswer == "False") {
//            correctQuestions += 1
//            questionField.text = "Correct!"
//        } else {
//            questionField.text = "Sorry, wrong answer!"
//        }
        
        
        switch sender {
            case trueButton: questionField.text = "trueButton"
            case falseButton: questionField.text = "falseButton"
            case AButton: questionField.text = "AButton"
            case BButton: questionField.text = "BButton"
            case CButton: questionField.text = "CButton"
            case DButton: questionField.text = "DButton"
            default: questionField.text = sender.description
            
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

