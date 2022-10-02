//
//  RadioButtonGroup.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/21.
//

import SwiftUI

// - MARK: RadioButton
struct RadioButton: View {
    let id: Int
    let title: String
     let callback: (Int) -> Void
    let selectedId: Int
    init(
        title: String,
        id: Int,
         callback: @escaping (Int) -> Void,
        selectedID: Int
    ) {
        self.title = title
        self.id = id
        self.selectedId = selectedID
         self.callback = callback
    }

    var body: some View {

        Button {

            self.callback(id)
        } label: {

            Text(title).font(.custom("PretendardVariable-Regular", size: 15)).padding(.vertical, 2).padding(.horizontal, 6) // 자간 간격 4 만큼

            // 글자 색
                .foregroundColor(self.selectedId != self.id ? Color.primary:Color("normal"))
            // .padding()
            // 배경색
                .background(self.selectedId != self.id ? Color("normal")  : Color.primary)
                .cornerRadius(10)
            // 테두리 설정
                .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color.primary))
        }
        // 최종 크기

    }
}

// - MARK: Group
struct RadioButtonView: View {
    let items: [String] = ["누적", "시간", "일간", "주간", "월간"]

    @Binding var selectedId: Int
    @Binding var musicCart: [SimpleSong]
    let callback: ((Int, Int)) -> Void

    func radioGroupCallback(id: Int) {
        callback((selectedId, id)) // 콜백 (이전 선택,현재 선택) 을 튜블 형태로
        selectedId = id // 선택된 아이디 변경
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) { // 버튼간 간격

                ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                    RadioButton(title: item, id: idx, callback: self.radioGroupCallback, selectedID: self.selectedId) // 버튼 설정
                }
            }.frame(width: ScreenSize.width, alignment: .center)
        }

    }

}
