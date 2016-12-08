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
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!

    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    
    let timeOutButton = UIButton()
    var currentQuizType = ""


    @IBOutlet weak var playAgainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameSounds()
        
        // Start game
        playGameSounds(soundName: "Start")
        currentQuizType = selectQuizType()
        if currentQuizType == "Math" {
            questions.loadMathQuestionSet()
        } else {
            questions.loadTextQuestionSet()
        }
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        questionField.text = questions.getUniqueRandomQuestion()
        
        // hide all input controls
        playAgainButton.isHidden = true
        trueButton.isHidden = true
        falseButton.isHidden = true
        aButton.isHidden = true
        bButton.isHidden = true
        cButton.isHidden = true
        dButton.isHidden = true
        // May add these later...
        //      numberInput.isHidden = true
        //      textInputControl.ishidden = true
        
        /*
         When the user picks the wrong answer, I was succeeding at turning the correct answer green,
         EXCEPT ON THE FIRST QUESTION. Adding these lines got it to work for the first question, but 
         I do not know why...  I tried to find an attribute on the correct-answer button that would
         tell me what I was doing wrong, but UIButton has a ton of attributes!
         */
        
         trueButton.setTitleColor(UIColor.white, for: UIControlState.normal)
         falseButton.setTitleColor(UIColor.white, for: UIControlState.normal)
         aButton.setTitleColor(UIColor.white, for: UIControlState.normal)
         bButton.setTitleColor(UIColor.white, for: UIControlState.normal)
         cButton.setTitleColor(UIColor.white, for: UIControlState.normal)
         dButton.setTitleColor(UIColor.white, for: UIControlState.normal)

        
        // unhide the needed input control
        switch questions.getQuestionType() {
            case .trueFalse:
                trueButton.isHidden = false
                falseButton.isHidden = false
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

        let delay = Int64(NSEC_PER_SEC * UInt64(15))  // STUPID: hard coded while I see if I can get it to work
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.checkAnswer(self.timeOutButton)
         }

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
        
        // this way: "checkAnswer(_ sender: UIButton? = nil)" let me call it with no arguments, 
        // but broke the switch statements below: "cannot convert value of type 'UIButton' to 
        // expected argument type '_OptionalNilComparisonType'"
        

        var isCorrect: Bool = false
        var typeOfAnswer: Questions.answerTypes
        let boolAnswer: Bool
        let correctAnswer: Int
        var userTimedOut: Bool = false

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
                 if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 1, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case cButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 2, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            
            case dButton:
                if questions.checkAnswer(type: Questions.answerTypes.multipleChoice, boolAnswer: true, selectedAnswer: 3, numberAnswer: 0, textAnswer: "" ) {
                    isCorrect = true
                }
            case timeOutButton:
                userTimedOut = true
            
            default: print("unexpected sender value")
                // user did not answer in time - sender == nil
                // isCorrect is already set to false.
        }
        
        if isCorrect {
            correctQuestions += 1
            questionField.text = "Correct!"
            playGameSounds(soundName: "Correct")
        } else {
            if (userTimedOut) {
                questionField.text = "Sorry, not quick enough!"
                playGameSounds(soundName: "TimedOut")
            } else {
                questionField.text = "Sorry, wrong answer!"
                playGameSounds(soundName: "Incorrect")
            }
        }
        
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
        
        // reset text color for all buttons
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
            playGameSounds(soundName: "End")
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
    
}

