//
//  AccountView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/19.
//

import SwiftUI

struct AccountView: View {

    let songs: String = "PiM4okVJSkGCdRCa9"
    let bugsheets: String = "1IrPOaQhtD9vHLEfdc1qyqSNNzou2Mmo49aQ0p7C4qic"
    var body: some View {
        NavigationView {

            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("로그인 서비스는 현재 준비중입니다.")

                    }
                } header: {
                    Text("내 계정").font(.headline).foregroundColor(.gray)
                }

                Section {
                    NavigationLink {
                        WebView(urlToLoad: Const.URL.sheets + bugsheets )
                    } label: {
                        Text("버그 제보")

                    }

                    NavigationLink {
                        WebView(urlToLoad: Const.URL.form + songs)
                    } label: {
                        Text("노래 추가, 수정 요청")

                    }
                } header: {
                    Text("건의사항").font(.headline).foregroundColor(.gray)
                }

                Section {
                    NavigationLink {
                        SettingScreenView()
                    } label: {
                        Text("화면 설정")

                    }
                } header: {
                    Text("환경설정").font(.headline).foregroundColor(.gray)
                }

            }

            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
        }

        .navigationViewStyle(.stack)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
