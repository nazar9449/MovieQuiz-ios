//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by assistant on 13.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
