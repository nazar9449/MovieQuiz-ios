import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // message for successful loading
    func didFailToLoadData(with error: Error) //message of loading error
}
