//
//  HomeScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/21.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        ZStack(alignment: .leading)
        {
            ScrollView(.vertical, showsIndicators: false) {
                MainHeader()
                Spacer()
                ChartHeader(title: "Title")
                Spacer()
                RadioButtonGroup { _ in}
                
                
            }
        }
    }
}

struct NavigationLogo: View {
    let window = UIScreen.main.bounds.size
    var body: some View {
        Image("mainLogoWhite")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("PrimaryColor"))
            .frame(width: window.width*0.4, height: window.height*0.04 ) //
    }
}

struct SettinButton: View {
    var body: some View {
        NavigationLink {
            SettingScreenView() //Destination
        } label: {
            //보여질 방식, 버튼 이미지
            Image(systemName: "gearshape.fill")
                .resizable()
                .foregroundColor(Color("PrimaryColor"))
                .frame(width: window.width*0.07, height: window.height*0.04)
        }
        
    }
}


struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}

struct MainHeader: View {
    var body: some View {
        HStack(alignment: .top) {
            NavigationLogo()
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
    }
}
