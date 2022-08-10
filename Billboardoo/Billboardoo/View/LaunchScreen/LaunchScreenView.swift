//
//  LaunchScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/19.
//

import SwiftUI

struct LaunchScreenView: View {
    
    let window = UIScreen.main.bounds.size
    var body: some View {
        //        ZStack(alignment: .center) {
        //            LinearGradient(gradient: Gradient(colors: [Color("PrimaryColor"), .white]),
        //                                        startPoint: .top, endPoint: .bottom)
        //                        .edgesIgnoringSafeArea(.all)
        //            Image("mainLogoWhite")
        //        }
        
        
        
        ZStack {
            Color.black
            Image("LaunchImage")
                .resizable()
                .aspectRatio(contentMode: .fit).padding(.horizontal)
                //.frame(width:window.width/10,height:window.height/10)
               
            
                
        }
        .ignoresSafeArea()
        
  

       
        
        
        
        
        //애니메이션 삽입
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
