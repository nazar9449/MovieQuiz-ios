import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
// MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var questionTitle: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    //MARK: - Private variables and constants
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    
// MARK: Private functions
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // unhide
        activityIndicator.startAnimating() // start
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
                                image: UIImage(named: model.image) ?? UIImage(),
                                question: model.question,
                                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount) ")
      }
// MARK: Possible mistake in the function below
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }


    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        if isCorrect {
            correctAnswers += 1
        }
            imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 // толщина рамки
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // border is either red or green
            yesButton.isEnabled = false
            noButton.isEnabled = false
//            imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
//            questionFactory?.requestNextQuestion()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in // запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция
                guard let self = self else {return}
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
                self.showNextQuestionOrResults()
        }
    }
    
// MARK: Possible mistake in the function above
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            let totalAccuracyPercentage = (String(format: "%.2f", statisticService.totalAccuracy) + "%")
            let bestGameDate = statisticService.bestGame.date.dateTimeString
            let totalGamesCount = statisticService.gamesCount
            let currentCorrectRecord = statisticService.bestGame.correct
            let currentTotalRecord = statisticService.bestGame.total
            let totalAccuracy = statisticService.totalAccuracy
            
//            let text = correctAnswers == questionsAmount ?
//            "Поздравляем, Вы ответили на 10 из 10!" :
//            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз"
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(totalGamesCount)
Рекорд: \(currentCorrectRecord)/ \(currentTotalRecord) (\(bestGameDate)
Средняя точность: \(String(format: "%.2f", totalAccuracy))%
""",
                                        buttonText: "Сыграть ещё раз",
                                        completion: {[weak self] _ in
                guard let self = self else {return}
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
                
                
            })
                imageView.layer.borderWidth = 0 // толщина рамки

                alertPresenter?.present(alert: alertModel, presentingViewController: self
                )
            
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            imageView.layer.borderWidth = 0 // толщина рамки
        }
    }
    
    
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_nczip2zt") else { return }
        var request = URLRequest(url: url) //создаём запрос
        
        request.httpBody = Data() //
        request.httpMethod = "POST"
        request.setValue("test", forHTTPHeaderField: "Test")
         
        let session = URLSession.shared
        
        alertPresenter = AlertPresenter()
        statisticService = StatisticServiceImplementation()
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()

        yesButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
        questionTitle.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    
    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    // Для состояния "Результат квиза"

    // Для состояния "Результат вопроса"
    struct QuestionResultViewModel {
        let result: Bool
    }
    


    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let answerGiven = false
        showAnswerResult(isCorrect: answerGiven == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let answerGiven = true
        showAnswerResult(isCorrect: answerGiven == currentQuestion.correctAnswer)
    }
    

    
}
