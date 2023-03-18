import UIKit

final class MovieQuizPresenter {
    
    var currentQuestionIndex: Int = 0
    private var questionsAmount: Int = 10
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel( //return to be returned at the beginning in case
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.question,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount) ")
    }
}
