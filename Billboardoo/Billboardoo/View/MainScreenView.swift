//
//  MainScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import SwiftUI
let window = UIScreen.main.bounds.size
struct MainScreenView: View {
    @EnvironmentObject var setting:Setting
    @State var isLoading: Bool = true
    
    
    var body: some View {
        NavigationView {
            
            if isLoading
            {
                LaunchScreenView().onAppear
                {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        withAnimation { isLoading.toggle() }
                    }
                }
            }
            else
            {
                
                
                //인터넷 처리
                VStack
                {
                    Text("Hello")
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        
                        NavigationLogo()
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SettinButton()
                    }
                }
            }
            
            
            
            
            
            
            
        }
    }
    
}



//- MARK: Preview

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

//- MARK: SubView

struct NavigationLogo: View {
    var body: some View {
        Image("mainLogoWhite")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("PrimaryColor"))
            .frame(width: window.width*0.3, height: window.height*0.045 , alignment: .center) //
            .aspectRatio(contentMode: .fit)
    }
}

struct SettinButton: View {
    var body: some View {
        NavigationLink {
            SettingScreenView() //Destination
        } label: {
            //보여질 방식, 버튼 이미지
            Image(systemName: "gearshape.fill")
                .foregroundColor(Color("PrimaryColor"))
        }
        
    }
}

//- MARK: Function


