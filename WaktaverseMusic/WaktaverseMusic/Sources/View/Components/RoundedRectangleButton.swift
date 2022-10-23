//
//  RoundedRectangleButton.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation
import SwiftUI

struct RoundedRectangleButton: View {

    let width, height: CGFloat
    let text: String
    let color, textColor: Color
    let imageSource: String

    var body: some View {

        HStack {
            Image(systemName: imageSource).font(.caption)
            Text(text).font(.caption).bold()
        }
        .foregroundColor(textColor)
        .frame(width: width, height: height)
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .background(RoundedRectangle(cornerRadius: 5).fill(color))
    }
}
