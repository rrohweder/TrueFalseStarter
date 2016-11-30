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
        
        switch sender {
            case trueButton:
                if questions.checkAnswer(type: Questions.answerTypes.trueFalse, boolAnswer: true, selectedAnswer: 0, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }

            case falseButton:
                if questions.checkAnswer(type: Questions.answerTypes.trueFalse, boolAnswer: false, selectedAnswer: 0, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case aButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 0, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case bButton:
                bButton.setTitleColor(UIColor.yellow, for: UIControlState.normal)
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 1, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case cButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 2, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case dButton: questionField.text = "DButton"
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 3, numberAnswer: 0, textAnswer: "" ) {
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

