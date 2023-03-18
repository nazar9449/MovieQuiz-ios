import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel( //return to be returned at the beginning in case
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.question,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount) ")
    }
}
