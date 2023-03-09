import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentQuestion = questions[currentQuestionIndex]
//        let convertedQuestion = convert(model: currentQuestion)
//        show (show: QuizStepViewModel(image: convertedQuestion.image, question: convertedQuestion.question, questionNumber: convertedQuestion.questionNumber))
//
        
        let viewModel: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
        show(quiz: viewModel)
        
//        myNewLabel.text = "Nazik"
//        myNewLabel.font = UIFont(name:"YSDisplay-Medium", size:20)
//        questionLabel.font = UIFont(name:"YSDisplay-Bold", size:23)
//        buttonYes.layer.cornerRadius = 15
//        buttonYes.backgroundColor = .blue
//        buttonYes.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
    }

    struct ViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // Для состояния "Вопрос задан"
    struct QuizStepViewModel {
        let image:             UIImage
        let question:          String
        let questionNumber:    String
    }

    // Для состояния "Результат квиза"
    struct QuizResultsViewModel {
        let title:             String
        let text:              String
        let buttonText:        String
    }

    // Для состояния "Результат вопроса"
    struct QuestionResultViewModel {
        let result: Bool
    }

    struct QuizQuestion {
        let image:              String
        let question:           String
        let correctAnswer:      Bool
    }
    
    private func show(show result: QuizResultsViewModel) {
//smth
    }

//    private func show(show step: QuizStepViewModel) {
//        // something. filling image, index and question
//    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.question,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count) ")
      }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect == true {
            print("Jan, answer is correct")
            currentQuestionIndex += 1
            let viewModel: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
            show(quiz: viewModel)
            
        }
        else {
            print("Jan, answer is incorrect")
            currentQuestionIndex += 1
            let viewModel: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
            show(quiz: viewModel)

        }
    }

    private let questions: [QuizQuestion] = [QuizQuestion(image: "The Godfather", question: "Рейтинг этого                                              фильма больше чем 9?", correctAnswer: true),
                                             QuizQuestion(image: "The Dark Knight", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "Kill Bill", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "Avengers", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "Deadpool", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "The Green Knight", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
                                             QuizQuestion(image: "Old", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                             QuizQuestion(image: "The Ice Age Adventures of Buck Wild", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                             QuizQuestion(image: "Tesla", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
                                             QuizQuestion(image: "Vivarium", question: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)]

    private var currentQuestionIndex: Int = 0
    



    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let answerGiven = false
        showAnswerResult(isCorrect: answerGiven == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let answerGiven = true
        showAnswerResult(isCorrect: answerGiven == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    /*
     Mock-данные
     Картинка: The Godfather
     Настоящий рейтинг: 9,2
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА


     Картинка: The Dark Knight
     Настоящий рейтинг: 9
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА


     Картинка: Kill Bill
     Настоящий рейтинг: 8,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА


     Картинка: The Avengers
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА


     Картинка: Deadpool
     Настоящий рейтинг: 8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА


     Картинка: The Green Knight
     Настоящий рейтинг: 6,6
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: ДА


     Картинка: Old
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ


     Картинка: The Ice Age Adventures of Buck Wild
     Настоящий рейтинг: 4,3
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ


     Картинка: Tesla
     Настоящий рейтинг: 5,1
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ


     Картинка: Vivarium
     Настоящий рейтинг: 5,8
     Вопрос: Рейтинг этого фильма больше чем 6?
     Ответ: НЕТ
     */

    
    
    
    
}





