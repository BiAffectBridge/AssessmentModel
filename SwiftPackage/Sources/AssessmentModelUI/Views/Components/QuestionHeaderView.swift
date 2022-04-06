//
//  QuestionHeaderView.swift
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
import SharedMobileUI

extension Color {
    fileprivate static let progressBackground: Color = .init(hex: "#A7A19C")!
}

struct QuestionHeaderView : View {
    @EnvironmentObject var assessmentState: AssessmentState
    @EnvironmentObject var questionState: QuestionState
    @EnvironmentObject var pagedNavigation: PagedNavigationViewModel
    
    public var body: some View {
        ZStack(alignment: .top) {
            progressBar()
            HStack {
                exitButton()
                Spacer()
                skipButton()
                    .font(.defaultSkipQuestionButtonFont)
                    .padding(.trailing, 15)
            }
            .accentColor(.sageBlack)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    func progressBar() -> some View {
        let fraction: CGFloat = CGFloat(pagedNavigation.currentIndex) / CGFloat(pagedNavigation.pageCount > 0 ? pagedNavigation.pageCount : 1)
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.progressBackground)
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: geometry.size.width * fraction)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 4)
        }
    }
    
    @ViewBuilder
    func exitButton() -> some View {
        if questionState.canPause {
            Button(action: { assessmentState.showingPauseActions = true }) {
                Image("pause", bundle: .module)
            }
        }
        else {
            Button(action: { assessmentState.isFinished = true }) {
                Image("close", bundle: .module)
            }
        }
    }
    
    @ViewBuilder
    func skipButton() -> some View {
        if let text = questionState.skipStepText {
            Button(action: {
                questionState.answerResult.jsonValue = nil
                pagedNavigation.goForward()
            }, label: { text.underline() })
        }
        else {
            EmptyView()
        }
    }
}
