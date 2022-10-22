//
//  NetworkView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/09/04.
//

import SwiftUI

struct NetworkView: View {
    var body: some View {
        ZStack {
            Color.forced
            VStack {
                Image(systemName: "wifi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ScreenSize.width/6, height: ScreenSize.width/6)
                    .foregroundColor(.gray.opacity(0.5))

                Text("네트워크 연결에 문제가 있습니다.").font(.custom("PretendardVariable-Regular", size: 15))
                    .foregroundColor(.gray)
                Text("연결을 확인해주세요.").font(.custom("PretendardVariable-Regular", size: 15))
                    .foregroundColor(.gray)

                Button {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } label: {
                    Text("네트워크 확인")
                        .font(.custom("PretendardVariable-Regular", size: 18))
                        .foregroundColor(.blue)

                        .padding(EdgeInsets(top: 5, leading: 3, bottom: 5, trailing: 3))
                }
                .frame(width: ScreenSize.width/2.5)
                .background(Color.normal)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 13).stroke(Color.blue))

            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct NetworkView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView()
    }
}

struct NetworkView_Dark_Previews: PreviewProvider {
    static var previews: some View {
        NetworkView().preferredColorScheme(.dark)
    }
}
