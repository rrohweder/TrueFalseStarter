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
/* might add these later:
        case number
        case text
 */
    }
    
    struct QuestionAnswer {
        let question: String
        let answerType: answerTypes
        let trueFalseAnswer: Bool
        let answerOptions: [String]
        let multiChoiceAnswer: Int
/* might add these later:
        let numAnswer: Int
        let textAnswer: String
*/
    }
    
    // an array of QuestionAnswer structs
    let questionsArray = [
        
        QuestionAnswer(
            question: "Only female koalas can whistle",
            answerType:answerTypes.trueFalse,
            trueFalseAnswer:false,
            answerOptions: [],
            multiChoiceAnswer: 0
            // numAnswer: 0,
            // textAnswer:""
        ),

        QuestionAnswer(
            question: "Blue whales are technically whales",
            answerType:answerTypes.trueFalse,
            trueFalseAnswer:true,
            answerOptions: [],
            multiChoiceAnswer: 0
            // numAnswer: 0,
            // textAnswer:""
        ),
            
        QuestionAnswer(
            question: "Camels are cannibalistic",
            answerType:answerTypes.trueFalse,
            trueFalseAnswer:false,
            answerOptions: [],
            multiChoiceAnswer: 0
            // numAnswer: 0,
            // textAnswer:""
        ),
        
        QuestionAnswer(
            question: "All ducks are birds",
            answerType:answerTypes.trueFalse,
            trueFalseAnswer:true,
            answerOptions: [],
            multiChoiceAnswer: 0
            // numAnswer: 0,
            // textAnswer:""
        ),
        
        QuestionAnswer(
            question:"This was the only US President to serve more than two consecutive terms:",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions: ["George Washington","Franklin D. Roosevelt","Woodrow Wilson","Andrew Jackson"],
            multiChoiceAnswer: 1
            // numAnswer: 0,
            // textAnswer:""
        ),
        
        QuestionAnswer(
            question:"Which of the following countries has the most residents?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions: ["Nigeria","Russia","Iran","Vietnam"],
            multiChoiceAnswer: 0
            // numAnswer: 0,
            // textAnswer:""
            ),

        QuestionAnswer(
            question:"In what year was the United Nations founded?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions:["1918","1919","1945","1954"],
            multiChoiceAnswer: 2
            // numAnswer:0,
            // textAnswer:""
        ),
 
        QuestionAnswer(
            question:"The Titanic departed from the United Kingdom, where was it supposed to arrive?",
            answerType: answerTypes.multipleChoice,
            trueFalseAnswer: false,
            answerOptions: ["Paris","Washington D.C.","New York City","Boston"],
            multiChoiceAnswer: 2
            // numAnswer: 0,
            // textAnswer: ""
        ),
        
        QuestionAnswer(
            question:"Which nation produces the most oil?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions:["Iran","Iraq","Brazil","Canada"],
            multiChoiceAnswer: 3
            // numAnswer: 0,
            // textAnswer:""
        ),
 
        QuestionAnswer(
            question:"Which country has most recently won consecutive World Cups in Soccer?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions:["Italy","Brazil","Argetina","Spain"],
            multiChoiceAnswer: 1
            // numAnswer: 0,
            // textAnswer:""
        ),

        QuestionAnswer(
            question:"Which of the following rivers is longest?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions:["Yangtze","Mississippi","Congo","Mekong"],
            multiChoiceAnswer: 1
            // numAnswer: 0,
            // textAnswer:""
        ),

        QuestionAnswer(
            question:"Which city is the oldest?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions:["Mexico City","Cape Town","San Juan","Sydney"],
            multiChoiceAnswer: 0
            // numAnswer: 0,
            // textAnswer:""
        ),

        QuestionAnswer(
            question:"Which country was the first to allow women to vote in national elections?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions:["Poland","United States","Sweden","Senegal"],
            multiChoiceAnswer: 0
            // numAnswer: 0,
            // textAnswer:""
        ),

        QuestionAnswer(
            question:"Which of these countries won the most medals in the 2012 Summer Games?",
            answerType:answerTypes.multipleChoice,
            trueFalseAnswer:false,
            answerOptions:["France","Germany","Japan","Great Britian"],
            multiChoiceAnswer: 3
            // numAnswer: 0,
            // textAnswer:""
        )

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
            
/* might add these later:
            case .number:
                if questionsArray[indexOfSelectedQuestion].numAnswer == numberAnswer {
                    return true
                }
            case .text:
                if questionsArray[indexOfSelectedQuestion].textAnswer == textAnswer {
                    return true
                }
 */
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
