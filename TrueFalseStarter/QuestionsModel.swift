//
//  QuestionsModel.swift
//  TrueFalseStarter
//
//  Created by Roger Rohweder on 11/23/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameKit

class Questions {
    
    enum answerTypes {
        case trueFalse
        case multipleChoice
        case math
    }
    
    struct QuestionAnswer {
        let question: String
        let answerType: answerTypes
        let answerOptions: [String]
        let multiChoiceAnswer: Int
    }
    
    // an array of QuestionAnswer structs
    var questionSet:[QuestionAnswer] = []
        
        
    func loadTextQuestionSet() {
        questionsUsed.removeAll()
        questionSet = [
            QuestionAnswer(
                question: "Only female koalas can whistle",
                answerType:answerTypes.trueFalse,
                answerOptions: ["true","false"],
                multiChoiceAnswer: 1
            ),

            QuestionAnswer(
                question: "Blue whales are technically whales",
                answerType:answerTypes.trueFalse,
                answerOptions: ["true","false"],
                multiChoiceAnswer: 0
            ),
                
            QuestionAnswer(
                question: "Camels are cannibalistic",
                answerType:answerTypes.trueFalse,
                answerOptions: ["true","false"],
                multiChoiceAnswer: 1
            ),
            
            QuestionAnswer(
                question: "All ducks are birds",
                answerType:answerTypes.trueFalse,
                answerOptions: ["true","false"],
                multiChoiceAnswer: 0
            ),
            
            QuestionAnswer(
                question:"This was the only US President to serve more than two consecutive terms:",
                answerType:answerTypes.multipleChoice,
                answerOptions: ["George Washington","Franklin D. Roosevelt","Woodrow Wilson","Andrew Jackson"],
                multiChoiceAnswer: 1
            ),
            
            QuestionAnswer(
                question:"Which of the following countries has the most residents?",
                answerType:answerTypes.multipleChoice,
                answerOptions: ["Nigeria","Russia","Iran","Vietnam"],
                multiChoiceAnswer: 0
                ),

            QuestionAnswer(
                question:"In what year was the United Nations founded?",
                answerType:answerTypes.multipleChoice,
                answerOptions:["1918","1919","1945","1954"],
                multiChoiceAnswer: 2
            ),
     
            QuestionAnswer(
                question:"The Titanic departed from the United Kingdom, where was it supposed to arrive?",
                answerType: answerTypes.multipleChoice,
                answerOptions: ["Paris","Washington D.C.","New York City","Boston"],
                multiChoiceAnswer: 2
            ),
            
            QuestionAnswer(
                question:"Which nation produces the most oil?",
                answerType:answerTypes.multipleChoice,
                answerOptions:["Iran","Iraq","Brazil","Canada"],
                multiChoiceAnswer: 3
            ),
     
            QuestionAnswer(
                question:"Which country has most recently won consecutive World Cups in Soccer?",
                answerType:answerTypes.multipleChoice,
                answerOptions:["Italy","Brazil","Argetina","Spain"],
                multiChoiceAnswer: 1
            ),

            QuestionAnswer(
                question:"Which of the following rivers is longest?",
                answerType:answerTypes.multipleChoice,
                answerOptions:["Yangtze","Mississippi","Congo","Mekong"],
                multiChoiceAnswer: 1
            ),

            QuestionAnswer(
                question:"Which city is the oldest?",
                answerType:answerTypes.multipleChoice,
                answerOptions:["Mexico City","Cape Town","San Juan","Sydney"],
                multiChoiceAnswer: 0
            ),

            QuestionAnswer(
                question:"Which country was the first to allow women to vote in national elections?",
                answerType:answerTypes.multipleChoice,
                answerOptions:["Poland","United States","Sweden","Senegal"],
                multiChoiceAnswer: 0
            ),

            QuestionAnswer(
                question:"Which of these countries won the most medals in the 2012 Summer Games?",
                answerType:answerTypes.multipleChoice,
                answerOptions:["France","Germany","Japan","Great Britian"],
                multiChoiceAnswer: 3
            )
            ]
    }
    
    
    func loadMathQuestionSet() {
        var answer = 0
        var operatorString = "unknown operator"
        var theseAnswerOptions:[String] = []
        questionSet.removeAll()
        questionsUsed.removeAll()
        
        for _ in 0...100 {  // generate 100 problem and answers sets
            let theOperator = GKRandomSource.sharedRandom().nextInt(upperBound: 1)
            let operand1 = GKRandomSource.sharedRandom().nextInt(upperBound: 99)
            let operand2 = GKRandomSource.sharedRandom().nextInt(upperBound: 99)
            if (theOperator == 0) {
                answer = operand1 + operand2
                operatorString = "plus"
            } else {
                answer = operand1 * operand2
                operatorString = "times"
            }
            let answerButton = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
            
            for answerIndex in 0...3 {
                if answerIndex == answerButton {
                    theseAnswerOptions.append(String(answer))
                } else {
                    theseAnswerOptions.append(String(GKRandomSource.sharedRandom().nextInt(upperBound: answer * 2)))
                }
            }
            
            questionSet.append(
                QuestionAnswer(
                    question: "What is \(operand1) \(operatorString) \(operand2)?",
                    answerType: answerTypes.math,
                    answerOptions: theseAnswerOptions,
                    multiChoiceAnswer: answerButton
                )
            )
            theseAnswerOptions.removeAll()

        }
    }
    
    
    
    var indexOfSelectedQuestion: Int
    var questionsUsed = [Int]()

    func getUniqueRandomQuestion() -> String {
        var attempts = 0
        // repeat until the new random number hasn't already been used
        repeat {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questionSet.count)
            attempts = attempts + 1
        } while (questionsUsed.contains(indexOfSelectedQuestion)) && (attempts < (questionSet.count * 3))
        
        questionsUsed.append(indexOfSelectedQuestion)
        return questionSet[indexOfSelectedQuestion].question

    }
    
    func getMultiChoiceAnswers() -> [String] {
        return questionSet[indexOfSelectedQuestion].answerOptions
    }
    
    func getQuestionType() -> answerTypes {
        return questionSet[indexOfSelectedQuestion].answerType
    }
    
    func getCorrectAnswer() -> (Int) {
        return questionSet[indexOfSelectedQuestion].multiChoiceAnswer
    }
    
    func checkAnswer(type: answerTypes, boolAnswer: Bool, selectedAnswer: Int, numberAnswer: Int, textAnswer: String ) -> Bool {

        if questionSet[indexOfSelectedQuestion].multiChoiceAnswer == selectedAnswer {
            return true
        } else {
            return false
        }
    }
    
    init() {
        
        indexOfSelectedQuestion = 0
        questionsUsed.append(0)

    }
    
}
