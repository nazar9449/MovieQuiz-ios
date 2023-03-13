import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private var alertPresenter: AlertPresenter = AlertPresenter()
    
// MARK: Private functions
    
    private func show(quiz result: QuizResultsViewModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: "OK", style: .default) {[weak self] _ in
            guard let self = self else {return}
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
            
        }

        // добавляем в алерт кнопки
        alert.addAction(action)

        // показываем всплывающее окно
        self.present(alert, animated: true, completion: nil)
        
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
// MARK: - Possible mistake below
    
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
    
// MARK: - Possible Mistake above
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questionsAmount - 1 {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, Вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз"
            
            let alertModel = AlertModel(title: "The round is finished", message: text, buttonText: "Play one more time") {[weak self] _ in
                guard let self = self else {return}
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            alertPresenter.showAlert(in: self, with: alertModel)
//                        let viewModel = QuizResultsViewModel(
//                            title: "Этот раунд окончен!",
//                            text: text,
//                            buttonText: "Сыграть ещё раз")
//                        imageView.layer.borderWidth = 0 // толщина рамки
//                        show(quiz: viewModel)
            
            
        }
        else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            imageView.layer.borderWidth = 0 // толщина рамки
        }
    }
    
    
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
//        show(quiz: viewModel)
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
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var questionTitle: UILabel!
    
}
