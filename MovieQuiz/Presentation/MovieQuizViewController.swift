import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionTitle: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Private variables and constants
    private var questionFactory: QuestionFactoryProtocol?
//    private var currentQuestion: QuizQuestion?
    private var correctAnswers: Int = 0
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private let presenter = MovieQuizPresenter()
    
    // MARK: Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
//    private func convert(model: QuizQuestion) -> QuizStepViewModel {
//        return QuizStepViewModel(
//            image: UIImage(data: model.image) ?? UIImage(),
//            question: model.question,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount) ")
//    }
    
    // MARK: Possible mistake in the function below
    
    func showAnswerResult(isCorrect: Bool) {
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
        if presenter.isLastQuestion() {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let bestGameDate = statisticService.bestGame.date.dateTimeString
            let totalGamesCount = statisticService.gamesCount
            let currentCorrectRecord = statisticService.bestGame.correct
            let currentTotalRecord = statisticService.bestGame.total
            let totalAccuracy = statisticService.totalAccuracy
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: """
Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
Количество сыгранных квизов: \(totalGamesCount)
Рекорд: \(currentCorrectRecord)/ \(currentTotalRecord) (\(bestGameDate)
Средняя точность: \(String(format: "%.2f", totalAccuracy))%
""",
                                        buttonText: "Сыграть ещё раз",
                                        completion: {[weak self] _ in
                guard let self = self else {return}
                
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
                
                
            })
            imageView.layer.borderWidth = 0 // толщина рамки
            
            alertPresenter?.present(alert: alertModel, presentingViewController: self
            )
            
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        imageView.layer.borderWidth = 0 // толщина рамки
        
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // turning on the indicator
        activityIndicator.startAnimating() //starting the animation
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true // in the future one func could be used to toggle the status of the activity indicator
    }
    
    private func showNetworkError(message: String) {
//        hideLoadingIndicator() // hiding loading indicator
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз",
                                    completion: {[weak self] _ in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.loadData()
            
            
        })
        imageView.layer.borderWidth = 0 // толщина рамки
        
        alertPresenter?.present(alert: alertModel, presentingViewController: self)

        
    }
    
    
    // MARK: - Lifecycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter()
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        
        presenter.viewController = self
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
//        questionFactory = QuestionFactory(delegate: self)
//        questionFactory?.requestNextQuestion()
        
        
        
        
        yesButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
        questionTitle.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)

    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // hiding loading indicator
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // let's take description as the message

    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
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
    
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
}
