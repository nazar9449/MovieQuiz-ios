import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
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
    
    private var correctAnswers: Int = 0
    
    private func show(quiz result: QuizResultsViewModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(title: result.title, // заголовок всплывающего окна
                                      message: result.text, // текст во всплывающем окне
                                      preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet

        // создаём для него кнопки с действиями
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
            
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
        return QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                                 question: model.question,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questions.count) ")
      }
    
    private func showAnswerResult(isCorrect: Bool) {
//            print("Jan, you've answered")
        
        if isCorrect {
            correctAnswers += 1
        }
//            currentQuestionIndex += 1
        let _: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
            imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
            imageView.layer.borderWidth = 2 // толщина рамки
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // border is either red or green
            imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // запускаем задачу через 1 секунду
            // код, который вы хотите вызвать через 1 секунду,
            // в нашем случае это просто функция
                self.showNextQuestionOrResults()
        }
//            showNextQuestionOrResults()
//            show(quiz: viewModel)
    }
    
    private func showNextQuestionOrResults(){
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers) из 10"
                        let viewModel = QuizResultsViewModel(
                            title: "Этот раунд окончен!",
                            text: text,
                            buttonText: "Сыграть ещё раз")
                        show(quiz: viewModel)
//            let viewModel: QuizResultsViewModel
//            show(quiz: viewModel)
//            let viewModel: QuizResultsViewModel = convert(model: questions[currentQuestionIndex])
//            show(show: viewModel)
//            show(show: ViewModel)
//            print("Results")
        }
        else {
            currentQuestionIndex += 1
            let viewModel: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
            show(quiz: viewModel)
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = questions[currentQuestionIndex]
//        let convertedQuestion = convert(model: currentQuestion)
//        show (show: QuizStepViewModel(image: convertedQuestion.image, question: convertedQuestion.question, questionNumber: convertedQuestion.questionNumber))
//
        
        let viewModel: QuizStepViewModel = convert(model: questions[currentQuestionIndex])
        show(quiz: viewModel)
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 1 // толщина рамки
        imageView.layer.borderColor = UIColor.white.cgColor // делаем рамку белой
        imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
        
        
        
//        myNewLabel.text = "Nazik"
//        myNewLabel.font = UIFont(name:"YSDisplay-Medium", size:20)
        textLabel.font = UIFont(name:"YSDisplay-Bold", size:23)
//        buttonYes.layer.cornerRadius = 15
//        buttonYes.backgroundColor = .blue
        yesButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name:"YSDisplay-Medium", size: 20)
        questionTitle.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
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


    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let answerGiven = false
        showAnswerResult(isCorrect: answerGiven == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let answerGiven = true
        if currentQuestion.correctAnswer == true {
            
//            print("you answered right. your correctAnswered counter is now \(correctAnswers)")
        }
        showAnswerResult(isCorrect: answerGiven == currentQuestion.correctAnswer)
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var questionTitle: UILabel!
    
}

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
