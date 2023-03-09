import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // something. result of the quiz
    }

    private func show(show step: QuizStepViewModel) {
        // something. filling image, index and question
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.question,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count) ")
      }

    private let questions: [QuizQuestion] = [QuizQuestion(image: "The Godfather", question: "Рейтинг этого                                              фильма больше чем 6?", correctAnswer: true),
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
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    
    
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





