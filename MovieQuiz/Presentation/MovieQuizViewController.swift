import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionTitle: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Private variables and constants
    var alertPresenter: AlertPresenter?
//    private var statisticService: StatisticService?
    private var presenter: MovieQuizPresenter!
    
    // MARK: Private functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        buttonsOn()
        hideBorderOfImage()
    }
    
    func show(quiz result: QuizResultsViewModel) {
            let message = presenter.makeResultsMessage()
            
            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)
                
            let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    
                    self.presenter.restartGame()
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
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
        
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // border is either red or green
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // turning on the indicator
        activityIndicator.startAnimating() //starting the animation
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // in the future one func could be used to toggle the status of the activity indicator
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator() // hiding loading indicator
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
//        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()

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
