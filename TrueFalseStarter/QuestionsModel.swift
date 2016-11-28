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
        case letter
        case number
        case text
    }
    
    struct QuestionAnswer {
        let question: String
        let answerType: answerTypes
        let trueFalseAnswer: Bool
        let letterAnswer: Character
        let numAnswer: Int
        let textAnswer: String
    }
    
    // an array of QuestionAnswer structs
    let questionsArray = [
    
        QuestionAnswer(
            question:"Is this fun, or what?",
            answerType:answerTypes.trueFalse,
            trueFalseAnswer:true,
            letterAnswer: " ",
            numAnswer: 0,
            textAnswer:""),

        QuestionAnswer(
            question:"Which letter is expressed as Charlie by the military? A, B, C or D",
            answerType:answerTypes.letter,
            trueFalseAnswer:false,
            letterAnswer:" ",
            numAnswer:0,
            textAnswer:""),
    
        QuestionAnswer(
            question:"How many projects are there in the TeamTreehouse TechDegree?\n6\n9\n12\n18",
            answerType:answerTypes.number,
            trueFalseAnswer:false,
            letterAnswer:" ",
            numAnswer:12,
            textAnswer:""),
        
        QuestionAnswer(
            question:"What is the most famous line from the movie The Sixth Sense?",
            answerType:answerTypes.text,
            trueFalseAnswer:false,
            letterAnswer:" ",
            numAnswer:12,
            textAnswer:"I see dead people"),
        
    ]
    
    var indexOfSelectedQuestion: Int
    var questionsUsed = [Int]()

    func getUniqueRandomQuestion() -> QuestionAnswer {
        
        // repeat until the new random number hasn't already been used
        repeat {
            indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questionsArray.count)
        } while (questionsUsed.contains(indexOfSelectedQuestion))
        
        questionsUsed.append(indexOfSelectedQuestion)
        return questionsArray[indexOfSelectedQuestion]

    }
    
    init() {
        
        indexOfSelectedQuestion = 0
        questionsUsed.append(0)

    }
// }
}
