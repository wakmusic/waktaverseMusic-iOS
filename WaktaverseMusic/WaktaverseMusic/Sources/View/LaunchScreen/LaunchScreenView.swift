//
//  LaunchScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/19.
//

import SwiftUI

struct LaunchScreenView: View {

    var body: some View {
        ZStack {
            Color.launchScreenColor
            Image("LaunchScreenLogo")
                .resizable()
                .aspectRatio(contentMode: .fit).padding(.horizontal)
        }
        .ignoresSafeArea()
        // 애니메이션 삽입
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .preferredColorScheme(.dark)
    }
}
