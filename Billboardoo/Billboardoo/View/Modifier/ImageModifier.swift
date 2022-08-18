//
//  ImageModifier.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/30.
//

import SwiftUI

struct PlayBarSongImageModifier:ViewModifier{
    let window = UIScreen.main.bounds
    func body(content: Content) -> some View {
        
        content.frame(width: window.width/9, height: window.width/9)
    }
}

struct PlayBarButtonImageModifier:ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        content
            .scaledToFit() //원래 종횡비를 유지합니다 
            .frame(width: window.width/20, height: window.width/20).foregroundColor(Color.primary)
            
    }
}

struct FullScreenButtonImageModifier:ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        content
            .scaledToFit() //원래 종횡비를 유지합니다
            .frame(width: window.width/15, height: window.width/15).foregroundColor(Color.primary)
            .padding(.horizontal)
        
    }
}


