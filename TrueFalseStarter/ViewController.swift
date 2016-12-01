//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

/*
I am succeeding at turning the correct T/F answer green, but not the ABCD correct answer,
nor at changing the selected (wrong) button red.  Is it because it is in a different state?
*/

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

    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!


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
        aButton.isHidden = true
        bButton.isHidden = true
        cButton.isHidden = true
        dButton.isHidden = true

// these are not ready yet
//        numberInput.isHidden = true
//        textInputControl.ishidden = true
        
        // unhide the needed input control
        switch questions.getQuestionType() {
            case .trueFalse:
                trueButton.isHidden = false
                falseButton.isHidden = false
            case .multipleChoice:
                aButton.setTitle(questions.getMultiChoiceAnswers()[0], for: UIControlState.normal)
                aButton.isHidden = false
                bButton.setTitle(questions.getMultiChoiceAnswers()[1], for: UIControlState.normal)
                bButton.isHidden = false
                cButton.setTitle(questions.getMultiChoiceAnswers()[2], for: UIControlState.normal)
                cButton.isHidden = false
                dButton.setTitle(questions.getMultiChoiceAnswers()[3], for: UIControlState.normal)
                dButton.isHidden = false

            // default: not needed - using all enum types
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
        
    @IBAction func checkAnswer(_ sender: UIButton) {
        var isCorrect: Bool = false

        // Increment the questions asked counter
        questionsAsked += 1
        print(sender.state)
        switch sender {
            case trueButton:
                if questions.checkAnswer(type: Questions.answerTypes.trueFalse, boolAnswer: true, selectedAnswer: 0, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
                if (isCorrect == false) {
                    // trueButton.titleLabel?.textColor = UIColor.red
                    trueButton.setTitleColor(UIColor.red, for:UIControlState.highlighted)
                }

            case falseButton:
                if questions.checkAnswer(type: Questions.answerTypes.trueFalse, boolAnswer: false, selectedAnswer: 0, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
                if (isCorrect == false) {
                    // falseButton.titleLabel?.textColor = UIColor.red
                    falseButton.setTitleColor(UIColor.red, for:UIControlState.highlighted)
                }
            
            case aButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 0, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
                if (!isCorrect) {
                    aButton.tintColor = UIColor.red
                    // setTitleColor(UIColor.red, for: UIControlState.normal)
                }
            
            case bButton:
                 if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 1, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
                 if (!isCorrect) {
                    bButton.tintColor = UIColor.red
                }
            
            case cButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 2, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                    
                }
                if (!isCorrect) {
                    cButton.tintColor = UIColor.red
                }
            
            case dButton: questionField.text = "DButton"
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 3, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
                if (!isCorrect) {
                    dButton.tintColor = UIColor.red
                }
            
            default: questionField.text = sender.description
        }

        if isCorrect {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }

// highlight the right answer...  STUPID: executes, but does not change the color
        var typeOfAnswer: Questions.answerTypes
        var boolAnswer: Bool
        let correctAnswer: Int
        (typeOfAnswer, boolAnswer, correctAnswer) = questions.getCorrectAnswer()
        if (typeOfAnswer == Questions.answerTypes.trueFalse) {
            if (boolAnswer == true) {
                trueButton.titleLabel?.textColor = UIColor.green
            } else {
                falseButton.titleLabel?.textColor = UIColor.green
            }
        } else {
            switch correctAnswer {
                case 0: aButton.titleLabel?.textColor = UIColor.green
                case 1: bButton.titleLabel?.textColor = UIColor.green
                case 2: cButton.titleLabel?.textColor = UIColor.green
                case 3: dButton.titleLabel?.textColor = UIColor.green
                default: print("selectedAnswer is outside # questions range.")
            }
        }
        
        loadNextRoundWithDelay(seconds: 2)
        
// STUPID: these execute, but do not change the color
       
        // reset text color for all buttons
        // less code than tracking correct & incorrect
        trueButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        falseButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        aButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        bButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        dButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        
        
        
        
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

