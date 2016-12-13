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

    var questions = Questions()
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var letterButtonPressed: Character = "?"

    var gameSounds = [String: SystemSoundID]()
    var GameSoundID: SystemSoundID = 0

    @IBOutlet weak var questionField: UILabel!

    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!

    @IBOutlet weak var playAgainButton: UIButton!

//      let timeOutButton = UIButton()  commented-out until I can cancel a timer

    var currentQuizType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameSounds()
        
        // Start game
        playGameSounds(soundName: "Start")
        questionField.text = "Which type of quiz would you like to take?"
        aButton.setTitle("Text", for: UIControlState.normal)
        bButton.setTitle("Math", for: UIControlState.normal)
        cButton.isHidden = true
        dButton.isHidden = true
        playAgainButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        questionField.text = questions.getUniqueRandomQuestion()
        
        resetBackgroundColor()
        // hide all input controls
        playAgainButton.isHidden = true
        aButton.isHidden = true
        bButton.isHidden = true
        cButton.isHidden = true
        dButton.isHidden = true
    
        
        // unhide the needed input control
        switch questions.getQuestionType() {
            case .trueFalse:
                aButton.setTitle(questions.getMultiChoiceAnswers()[0], for: UIControlState.normal)
                aButton.isHidden = false
                bButton.setTitle(questions.getMultiChoiceAnswers()[1], for: UIControlState.normal)
                bButton.isHidden = false
            case .multipleChoice, .math:
                aButton.setTitle(questions.getMultiChoiceAnswers()[0], for: UIControlState.normal)
                aButton.isHidden = false
                bButton.setTitle(questions.getMultiChoiceAnswers()[1], for: UIControlState.normal)
                bButton.isHidden = false
                cButton.setTitle(questions.getMultiChoiceAnswers()[2], for: UIControlState.normal)
                cButton.isHidden = false
                dButton.setTitle(questions.getMultiChoiceAnswers()[3], for: UIControlState.normal)
                dButton.isHidden = false
                // default not needed - using all enum types
        }
        
/* disable timer until I find-out how to kill it when the user answers the question.
        let delay = Int64(NSEC_PER_SEC * UInt64(15))  // hard coded while I see if I can get it to work
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.checkAnswer(self.timeOutButton)
         }
*/
    }
    
    func displayScore() {
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
        
    @IBAction func checkAnswer(_ sender: UIButton) {
        
        // sort of overloading this...
        if sender.currentTitle == "Math" || sender.currentTitle == "Text" {
            currentQuizType = (sender.currentTitle)!
            if currentQuizType == "Math" {
                questions.loadMathQuestionSet()
            } else {
                questions.loadTextQuestionSet()
            }
            displayQuestion()
            return
        }

        var isCorrect: Bool = false
        let correctAnswer: Int = questions.getCorrectAnswer()
        // var userTimedOut: Bool = false

        // Increment the questions asked counter
        questionsAsked += 1

        switch sender {
            case aButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 0, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                    aButton.backgroundColor = UIColor.green
                } else {
                    aButton.backgroundColor = UIColor.red
                }
            
            case bButton:
                 if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 1, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                    bButton.backgroundColor = UIColor.green
                } else {
                    bButton.backgroundColor = UIColor.red
                }
        
            case cButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 2, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                    cButton.backgroundColor = UIColor.green
                } else {
                    cButton.backgroundColor = UIColor.red
                }
        
            case dButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 3, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                    dButton.backgroundColor = UIColor.green
                } else {
                    dButton.backgroundColor = UIColor.red
                }
/*  leave out until I can cancel a timer.
            case timeOutButton:
                userTimedOut = true
*/
            
            default: print("unexpected sender value")
                // user did not answer in time - sender == nil
                // isCorrect is already set to false.
        }
        
        if isCorrect {
            correctQuestions += 1
            questionField.text = "Correct!"
            playGameSounds(soundName: "Correct")
        } else {
            /* until I learn how to cancel timer
            if (userTimedOut) {
                questionField.text = "Sorry, not quick enough!"
                playGameSounds(soundName: "TimedOut")
            } else {
             */
                questionField.text = "Sorry, wrong answer!"
                playGameSounds(soundName: "Incorrect")
                switch correctAnswer {
                    case 0: aButton.backgroundColor = UIColor.green
                    case 1: bButton.backgroundColor = UIColor.green
                    case 2: cButton.backgroundColor = UIColor.green
                    case 3: dButton.backgroundColor = UIColor.green
                    default: print("unexpected correctAnswer value")
                }
            
/*
            }
*/ 
        }
    
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
            playGameSounds(soundName: "End")
            
            resetBackgroundColor()

            questionField.text = "Which type of quiz would you like to take?"
            aButton.setTitle("Text", for: UIControlState.normal)
            bButton.setTitle("Math", for: UIControlState.normal)
            cButton.isHidden = true
            dButton.isHidden = true
            playAgainButton.isHidden = true
            questionsAsked = 0
            correctQuestions = 0

            
            
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        questionsAsked = 0
        correctQuestions = 0
        // resetBackgroundColor()
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

    func loadGameSounds() {

        var pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        var soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &GameSoundID)
        gameSounds["Start"] = GameSoundID

        pathToSoundFile = Bundle.main.path(forResource: "Crash-Cymbal-1", ofType: "wav")
        soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &GameSoundID)
        gameSounds["End"] = GameSoundID

        pathToSoundFile = Bundle.main.path(forResource: "GoodJob", ofType: "m4a")
        soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &GameSoundID)
        gameSounds["Correct"] = GameSoundID

        pathToSoundFile = Bundle.main.path(forResource: "Oops", ofType: "m4a")
        soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &GameSoundID)
        gameSounds["Incorrect"] = GameSoundID

        pathToSoundFile = Bundle.main.path(forResource: "TimedOut", ofType: "m4a")
        soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &GameSoundID)
        gameSounds["TimedOut"] = GameSoundID
    }
  
    func playGameSounds(soundName: String) {
        AudioServicesPlaySystemSound(gameSounds[soundName]!)
    }

    
    func selectQuizType() -> String {
        return "Math"
    }

    func resetBackgroundColor() {
        aButton.backgroundColor = UIColor(red:12/255.0, green: 121/255.0, blue: 150/255.0, alpha: 1.0)
        bButton.backgroundColor = UIColor(red:12/255.0, green: 121/255.0, blue: 150/255.0, alpha: 1.0)
        cButton.backgroundColor = UIColor(red:12/255.0, green: 121/255.0, blue: 150/255.0, alpha: 1.0)
        dButton.backgroundColor = UIColor(red:12/255.0, green: 121/255.0, blue: 150/255.0, alpha: 1.0)
    }

}

