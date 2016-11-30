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
        case number
        case text
    }
    
    struct QuestionAnswer {
        let question: String
        let answerType: answerTypes
        let trueFalseAnswer: Bool
        let answerOptions: [String]
        let multiChoiceAnswer: Int
        let numAnswer: Int
        let textAnswer: String
    }
    
    // an array of QuestionAnswer structs
    let questionsArray = [
    
        QuestionAnswer(
            question:"Is this fun, or what?",
            answerType:answerTypes.trueFalse,
            trueFalseAnswer:true,
            answerOptions: [],
            multiChoiceAnswer: 0,
            numAnswer: 0,
            textAnswer:""),
        
        QuestionAnswer(
            question:"No really, am I right?",
            answerType:answerTypes.trueFalse,
            trueFalseAnswer:true,
            answerOptions: [],
            multiChoiceAnswer: 0,
            numAnswer: 0,
            textAnswer:""),

        QuestionAnswer(
            question:"Which planet is closest to the sun?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions:["Pluto","Venus","Mercury","Saturn"],
            multiChoiceAnswer: 2,
            numAnswer:0,
            textAnswer:"")
 /* ,
        QuestionAnswer(
            question:"How many projects are there in the TeamTreehouse TechDegree?\n6\n9\n12\n18",
            answerType:answerTypes.number,
            trueFalseAnswer:false,
            answerOptions:" ",
            numAnswer:12,
            textAnswer:""),
        
        QuestionAnswer(
            question:"What is the most famous line from the movie The Sixth Sense?",
            answerType:answerTypes.text,
            trueFalseAnswer:false,
            answerOptions:" ",
            numAnswer:12,
            textAnswer:"I see dead people"),
 */
    ]
    
    var indexOfSelectedQuestion: Int
    var questionsUsed = [Int]()

    func getUniqueRandomQuestion() -> String {
        var attempts = 0
        // repeat until the new random number hasn't already been used
        repeat {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questionsArray.count)
            attempts = attempts + 1
        } while (questionsUsed.contains(indexOfSelectedQuestion) && (attempts < (questionsArray.count * 3)))
        
        questionsUsed.append(indexOfSelectedQuestion)
        
        return questionsArray[indexOfSelectedQuestion].question

    }
    
    func getMultiChoiceAnswers() -> [String] {
        return questionsArray[indexOfSelectedQuestion].answerOptions
    }
    
    func getQuestionType() -> answerTypes {
        return questionsArray[indexOfSelectedQuestion].answerType
    }
    
    func checkAnswer(type: answerTypes, boolAnswer: Bool, selectedAnswer: Int, numberAnswer: Int, textAnswer: String ) -> Bool {

        switch type {
            case .trueFalse:
                if questionsArray[indexOfSelectedQuestion].trueFalseAnswer == boolAnswer {
                    return true
                }
            case .multipleChoice:
                if questionsArray[indexOfSelectedQuestion].multiChoiceAnswer == selectedAnswer {
                    return true
                }
            case .number:
                if questionsArray[indexOfSelectedQuestion].numAnswer == numberAnswer {
                    return true
                }
            case .text:
                if questionsArray[indexOfSelectedQuestion].textAnswer == textAnswer {
                    return true
                }
            // default: not needed - all enum values spoken for
        }
        return false
    }
    
    init() {
        
        indexOfSelectedQuestion = 0
        questionsUsed.append(0)

    }
// }
}
