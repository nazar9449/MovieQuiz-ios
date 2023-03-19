import XCTest
@testable import MovieQuiz // importing app for testing


final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] // finding the first poster
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        let index1 = indexLabel.label

        
        app.buttons["Yes"].tap() // finding the "Yes" button and tapping it
        sleep(3)
        
        let secondPoster = app.images["Poster"] // finding the poster one more time
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let index2 = indexLabel.label

        
        XCTAssertFalse(firstPosterData == secondPosterData) //comparing two screenshots
        XCTAssertFalse(index1 == index2)
        XCTAssertEqual(index2, "2/10 ")
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] // finding the first poster
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        
        let index1 = indexLabel.label

        
        app.buttons["No"].tap() // finding the "Yes" button and tapping it
        sleep(3)
        
        let secondPoster = app.images["Poster"] // finding the poster one more time
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let index2 = indexLabel.label

        
        XCTAssertFalse(firstPosterData == secondPosterData) //comparing two screenshots
        XCTAssertFalse(index1 == index2)
        XCTAssertEqual(index2, "2/10 ")
    }
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }

        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10 ")
    }
}
