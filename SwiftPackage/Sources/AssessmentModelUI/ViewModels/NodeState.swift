//
//  NodeState.swift
//
//
//  Copyright © 2022 Sage Bionetworks. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2.  Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission. No license is granted to the trademarks of
// the copyright holders even if such marks are included in this software.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import SwiftUI
import AssessmentModel
import JsonModel

/**
 * The state objects are all simple objects without any business or navigation logic. This is done because
 * SwiftUI  @EnvironmentObject observables have to be castable using NSClassFromString.
 */

public protocol NodeState {
    var node: Node { get }
    var result: ResultData { get }
}

public protocol StepState : NodeState {
    var step: Step { get }
}

extension StepState {
    public var node: Node { step }
}

public protocol BranchState : NodeState {
    var branchNode: BranchNode { get }
    var branchNodeResult: BranchNodeResult { get }
}

extension BranchState {
    public var node: Node { branchNode }
    public var result: ResultData { result }
}

public final class AssessmentState : ObservableObject, BranchState {
    public var branchNode: BranchNode { assessment }
    public var branchNodeResult: BranchNodeResult { assessmentResult }
    
    @Published var isFinished: Bool = false
    @Published var showingPauseActions: Bool = false
    
    public let assessment: Assessment
    public let assessmentResult: AssessmentResult
    
    var navigator: Navigator!
    
    public init(_ assessment: Assessment, restoredResult: AssessmentResult? = nil) {
        self.assessment = assessment
        var result = restoredResult ?? assessment.instantiateAssessmentResult()
        result.startDate = Date()
        self.assessmentResult = result
    }
}

public final class InstructionState : ObservableObject, StepState {
    
    @Published public var image: Image?
    
    @Published public var title: String?
    @Published public var subtitle: String?
    @Published public var detail: String?

    public let step: Step
    public let result: ResultData
    
    public init(_ instruction: Step) {
        self.step = instruction
        self.result = instruction.instantiateResult()
        if let contentNode = instruction as? ContentNode {
            self.title = contentNode.title
            self.subtitle = contentNode.subtitle
            self.detail = contentNode.detail
            if let imageInfo = contentNode.imageInfo as? FetchableImage {
                self.image = Image(imageInfo.imageName, bundle: imageInfo.bundle)
            }
        }
    }
}

/// State object for a question.
public final class QuestionState : ObservableObject, StepState {
    public var step: Step { question }
    public var result: ResultData { answerResult }
    
    public let question: QuestionStep
    public let answerResult: AnswerResult
    public let canPause: Bool
    public let skipStepText: Text?
    
    @Published public var title: String
    @Published public var subtitle: String?
    @Published public var detail: String?
    
    @Published public var hasSelectedAnswer: Bool = false
    
    public init(_ question: QuestionStep, answerResult: AnswerResult? = nil, canPause: Bool = true, skipStepText: Text? = nil) {
        self.question = question
        var result = answerResult ?? question.instantiateAnswerResult()
        result.startDate = Date()
        self.answerResult = result
        self.title = question.title ?? question.subtitle ?? question.detail ?? ""
        self.subtitle = question.title == nil ? nil : question.subtitle
        self.detail = question.title == nil && question.subtitle == nil ? nil : question.detail
        self.canPause = canPause
        self.skipStepText = skipStepText
    }
}

extension BranchNodeResult {
    func copyResult<T>(with identifier: String) -> T? {
        stepHistory.last { $0.identifier == identifier }.flatMap { $0.deepCopy() as? T }
    }
}

extension ResourceInfo {
    var bundle: Bundle? {
        self.factoryBundle as? Bundle ?? self.bundleIdentifier.flatMap { Bundle(identifier: $0) }
    }
}