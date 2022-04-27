//
//  CompositedImage.swift
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

public struct CompositedImage: View {
    @SwiftUI.Environment(\.surveyTintColor) var surveyTint: Color
    let imageName: String
    let layerCount: Int
    let bundle: Bundle?
    
    public init(_ imageName: String, bundle: Bundle? = nil, layers: Int = 2) {
        self.imageName = imageName
        self.layerCount = layers
        self.bundle = bundle
    }
    
    public var body: some View {
        ZStack {
            ForEach(0 ..< layerCount, id:\.self) { layer in
                Image("\(imageName).\(layer)", bundle: bundle)
            }
        }
        .foregroundColor(surveyTint)
    }
}

struct LayeredImageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CompositedImage("survey", bundle: .module, layers: 4)
            CompositedImage("survey", bundle: .module, layers: 4)
                .surveyTintColor(.red)
        }
    }
}
