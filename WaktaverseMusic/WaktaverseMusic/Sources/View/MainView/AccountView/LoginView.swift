//
//  LoginView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/19.
//

import SwiftUI
import PopupView

struct LoginView: View {
    @State var showAelrt = false
    var body: some View {

        VStack {

        }.padding(.horizontal)

    }
}

struct LoginButton: View {

    var text: String
    var image: String
    var textColor: Color
    var buttonColor: Color
    var url: String
    @Binding var showAlert: Bool

    var body: some View {

        Button {
            showAlert = true
        } label: {
            Label {
                Text(text)
                    .font(.system(size: 15))
                    .foregroundColor(textColor)
            } icon: {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)

            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.gray, lineWidth: 1)
            )
        }
        .background(buttonColor) // If you have this
        .cornerRadius(6)
    }

}
