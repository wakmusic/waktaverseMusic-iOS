//
//  LaunchScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/19.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
//        ZStack(alignment: .center) {
//            LinearGradient(gradient: Gradient(colors: [Color("PrimaryColor"), .white]),
//                                        startPoint: .top, endPoint: .bottom)
//                        .edgesIgnoringSafeArea(.all)
//            Image("mainLogoWhite")
//        }
      
        
        ZStack {
            Color.black
            Image("mainLogoWhite")
        }.frame(width: .infinity, height: .infinity, alignment: .center)
            .ignoresSafeArea()
            
        
       
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
