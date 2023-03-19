import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticService!
    
    func showNextQuestionOrResults(){
        if self.isLastQuestion() {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            let bestGameDate = statisticService.bestGame.date.dateTimeString
            let totalGamesCount = statisticService.gamesCount
            let currentCorrectRecord = statisticService.bestGame.correct
            let currentTotalRecord = statisticService.bestGame.total
            let totalAccuracy = statisticService.totalAccuracy
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: """
Ваш результат: \(correctAnswers)/\(self.questionsAmount)
Количество сыгранных квизов: \(totalGamesCount)
Рекорд: \(currentCorrectRecord)/ \(currentTotalRecord) (\(bestGameDate)
Средняя точность: \(String(format: "%.2f", totalAccuracy))%
""",
                                        buttonText: "Сыграть ещё раз",
                                        completion: {[weak self] _ in
                guard let self = self else {return}
                
                self.restartGame()
                self.questionFactory?.requestNextQuestion()
                
                
            })
            viewController?.hideBorderOfImage()
            
            viewController?.alertPresenter?.present(alert: alertModel, presentingViewController: viewController!)
            
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        viewController?.hideBorderOfImage()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
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
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrectAnswer: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
}
