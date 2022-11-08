//
//  LikertScaleViewModelTests.swift
//
//

import Foundation
@testable import AssessmentModelUI
@testable import AssessmentModel
import JsonModel
import ResultModel
import XCTest

class LikertScaleViewModelTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLikertScale_Initial() {
        let example = SimpleQuestionStepObject(
            identifier: "example",
            inputItem: IntegerTextInputItemObject(formatOptions: .init(minimumValue: 0, maximumValue: 4, minimumLabel: "Not at all", maximumLabel: "Very much")),
            title: "How much do you like apples?",
            uiHint: .NumberField.likert.uiHint
        )
        
        let questionState = QuestionState(example, answerResult: nil)
        let questionViewModel = IntegerQuestionViewModel()
        questionViewModel.onAppear(questionState)
        guard let viewModel = questionViewModel.inputViewModel else {
            XCTFail("Expected the question view model to build the input view model.")
            return
        }
        
        XCTAssertEqual(0, viewModel.minValue)
        XCTAssertEqual(4, viewModel.maxValue)
        XCTAssertEqual(0, viewModel.fraction)
        XCTAssertNil(viewModel.value)
        XCTAssertFalse(questionState.hasSelectedAnswer)
        XCTAssertEqual("On a scale of 0 to 4", questionState.subtitle)
        XCTAssertEqual("0 = Not at all\n4 = Very much", questionState.detail)
        XCTAssertEqual(viewModel.dots.count, 5)
        XCTAssertEqual(0, viewModel.dots.first?.value)
        XCTAssertEqual(4, viewModel.dots.last?.value)
        viewModel.dots.forEach {
            XCTAssertFalse($0.selected, "\($0.value) should not be selected.")
        }
        
        // Select a value
        viewModel.value = 2
        XCTAssertEqual(0.5, viewModel.fraction, accuracy: 0.01)
        XCTAssertEqual(.integer(2), questionState.answerResult.jsonValue)
        XCTAssertTrue(questionState.hasSelectedAnswer)
        viewModel.dots[0...2].forEach {
            XCTAssertTrue($0.selected, "\($0.value) should be selected.")
        }
        viewModel.dots[3...].forEach {
            XCTAssertFalse($0.selected, "\($0.value) should be selected.")
        }
    }
    
    func testLikertScale_WithValue() {
        let example = SimpleQuestionStepObject(
            identifier: "example",
            inputItem: IntegerTextInputItemObject(formatOptions: .init(minimumValue: 0, maximumValue: 4, minimumLabel: "Not at all", maximumLabel: "Very much")),
            title: "How much do you like apples?",
            uiHint: .NumberField.likert.uiHint
        )
        
        let questionState = QuestionState(example, answerResult: AnswerResultObject(identifier: example.identifier, value: .integer(2)))
        let questionViewModel = IntegerQuestionViewModel()
        questionViewModel.onAppear(questionState)
        guard let viewModel = questionViewModel.inputViewModel else {
            XCTFail("Expected the question view model to build the input view model.")
            return
        }
        
        XCTAssertEqual(0, viewModel.minValue)
        XCTAssertEqual(4, viewModel.maxValue)

        XCTAssertEqual("On a scale of 0 to 4", questionState.subtitle)
        XCTAssertEqual("0 = Not at all\n4 = Very much", questionState.detail)
        XCTAssertEqual(viewModel.dots.count, 5)
        XCTAssertEqual(0, viewModel.dots.first?.value)
        XCTAssertEqual(4, viewModel.dots.last?.value)
        
        XCTAssertEqual(0.5, viewModel.fraction, accuracy: 0.01)
        XCTAssertEqual(2, viewModel.value)
        XCTAssertTrue(questionState.hasSelectedAnswer)
        XCTAssertEqual(.integer(2), questionState.answerResult.jsonValue)
        XCTAssertTrue(questionState.hasSelectedAnswer)
        viewModel.dots[0...2].forEach {
            XCTAssertTrue($0.selected, "\($0.value) should be selected.")
        }
        viewModel.dots[3...].forEach {
            XCTAssertFalse($0.selected, "\($0.value) should be selected.")
        }
    }
}
