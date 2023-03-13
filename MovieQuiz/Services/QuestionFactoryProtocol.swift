//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by assistant on 12.03.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
