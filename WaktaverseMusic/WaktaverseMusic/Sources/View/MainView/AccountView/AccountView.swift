//
//  AccountView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/19.
//

import SwiftUI

struct AccountView: View {

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
                    VStack(alignment: .leading) {
                        NavigationLink {
                            SettingScreenView()
                        } label: {
                            Text("버그 제보")

                        }
                        
                        NavigationLink {
                            SettingScreenView()
                        } label: {
                            Text("곡 건의사항")

                        }

                    }
                } header: {
                    Text("건의사항").font(.headline).foregroundColor(.gray)
                }

                Section {
                    VStack(alignment: .leading) {
                        NavigationLink {
                            SettingScreenView()
                        } label: {
                            Text("화면 설정")

                        }

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
