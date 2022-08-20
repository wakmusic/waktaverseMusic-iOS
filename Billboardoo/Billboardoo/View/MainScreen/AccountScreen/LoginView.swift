//
//  LoginView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/19.
//

import SwiftUI
import PopupView

struct LoginView: View  {
    let window = UIScreen.main.bounds
    @State var showAelrt = false
    var body: some View {
        
        
        
        VStack{
            
            LoginButton(text: "트위치계정 로그인", image: "twitch", textColor: .primary, buttonColor: .twitch,url: ApiCollections.tiwtch,showAlert:$showAelrt)
                .alert("서비스 준비중입니다.", isPresented: $showAelrt) {
                    
                    Button(role: .cancel) {
                       
                    } label: {
                        Text("확인")
                    }
                }
            
            LoginButton(text: "네이버계정 로그인", image: "naver", textColor: .primary, buttonColor:.naver,url:ApiCollections.naver,showAlert:$showAelrt)
                .alert("서비스 준비중입니다.", isPresented: $showAelrt) {
                    
                    Button(role: .cancel) {
                       
                    } label: {
                        Text("확인")
                    }
                }
            
            LoginButton(text: "구글아이디 로그인", image: "google", textColor: .primary, buttonColor:.normal,url:ApiCollections.google,showAlert:$showAelrt)
                .alert("서비스 준비중입니다.", isPresented: $showAelrt) {
                    
                    Button(role: .cancel) {
                       
                    } label: {
                        Text("확인")
                    }
                }
            
            
            
        }.padding(.horizontal)
        
        
        
        
        
    }
}

struct LoginButton: View {
    
    var text:String
    var image:String
    var textColor:Color
    var buttonColor:Color
    var url: String
    @Binding var showAlert:Bool
    
    
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

