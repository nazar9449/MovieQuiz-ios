import UIKit

final class MovieQuizViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionTitle: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Private variables and constants
//    private var questionFactory: QuestionFactoryProtocol? to be deleted
//    private var currentQuestion: QuizQuestion?            to be deleted
//    private var correctAnswers: Int = 0                   to be deleted
    var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    // MARK: Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        buttonsOn()
    }
    
    func buttonsOn() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func buttonsOff() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func hideBorderOfImage() {
        imageView.layer.borderWidth = 0 // толщина рамки
    }
    
    // MARK: Possible mistake in the function below
    
    func showAnswerResult(isCorrectAnswer: Bool) {
        buttonsOff()
        if isCorrectAnswer {
            presenter.didAnswer(isCorrectAnswer: true)
        }
            imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
            imageView.layer.borderWidth = 8 // толщина рамки
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // border is either red or green
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in // запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция
            guard let self = self else {return}
            self.buttonsOn()
            self.showNextQuestionOrResults()
        }
    }
    
    // MARK: Possible mistake in the function above
    
    private func showNextQuestionOrResults(){
        if presenter.isLastQuestion() {
            guard let statisticService = statisticService else { return }
            statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
            let bestGameDate = statisticService.bestGame.date.dateTimeString
            let totalGamesCount = statisticService.gamesCount
            let currentCorrectRecord = statisticService.bestGame.correct
            let currentTotalRecord = statisticService.bestGame.total
            let totalAccuracy = statisticService.totalAccuracy
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: """
Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
Количество сыгранных квизов: \(totalGamesCount)
Рекорд: \(currentCorrectRecord)/ \(currentTotalRecord) (\(bestGameDate)
Средняя точность: \(String(format: "%.2f", totalAccuracy))%
""",
                                        buttonText: "Сыграть ещё раз",
                                        completion: {[weak self] _ in
                guard let self = self else {return}
                
                self.presenter.restartGame()                
                
            })
            imageView.layer.borderWidth = 0 // толщина рамки
            
            alertPresenter?.present(alert: alertModel, presentingViewController: self
            )
            
        } else {
            presenter.switchToNextQuestion()
            presenter.questionFactory?.requestNextQuestion()
//            to be deleted or removed?
        }
        imageView.layer.borderWidth = 0 // толщина рамки
        
    }
    

    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // turning on the indicator
        activityIndicator.startAnimating() //starting the animation
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // in the future one func could be used to toggle the status of the activity indicator
    }
    
    func showNetworkError(message: String) {
//        hideLoadingIndicator() // hiding loading indicator
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз",
                                    completion: {[weak self] _ in
            guard let self = self else {return}
            
            self.presenter.restartGame()
            
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
//        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
//        questionFactory?.loadData()
//        TO BE DELETED?
        presenter = MovieQuizPresenter(viewController: self)
        
        presenter.viewController = self
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20

        setFontsOfButtonAndLabels()


    }
    
    
    private func setFontsOfButtonAndLabels () {
        yesButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
        questionTitle.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
    }
    
//    func didLoadDataFromServer() {
//        activityIndicator.isHidden = true // hiding loading indicator
//        questionFactory?.requestNextQuestion()
//    } to be deleted
    
//    func didFailToLoadData(with error: Error) {
//        showNetworkError(message: error.localizedDescription) // let's take description as the message
//
//    } to be deleted
    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        presenter.didReceiveNextQuestion(question: question)
//    } to be deleted
    
    
    
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
