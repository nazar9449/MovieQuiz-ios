//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by assistant on 12.03.2023.
//

import Foundation

//QuestionsFactoryProtocol

class QuestionFactory {
    private let questions: [QuizQuestion] = [QuizQuestion(image: "The Godfather", question: "Рейтинг этого                                              фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "The Dark Knight", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "Kill Bill", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "Avengers", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "Deadpool", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "The Green Knight", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "Old", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                             QuizQuestion(image: "The Ice Age Adventures of Buck Wild", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                             QuizQuestion(image: "Tesla", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                             QuizQuestion(image: "Vivarium", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)]
    
    func requestNextQuestion() -> QuizQuestion? {
        guard let index = (0..<questions.count).randomElement() else {
            return nil
        }
        return questions[safe: index]
    }
    
}
