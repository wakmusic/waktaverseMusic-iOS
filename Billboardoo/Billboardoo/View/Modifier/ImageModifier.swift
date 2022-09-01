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
    let device = UIDevice.current.userInterfaceIdiom
    func body(content: Content) -> some View {
        content
            .font(.system(size:  device == .phone  ? 25 : 30)).foregroundColor(Color.primary)
            
    }
}

struct FullScreenButtonImageModifier:ViewModifier{
    let window = UIScreen.main.bounds
    let device = UIDevice.current.userInterfaceIdiom
    func body(content: Content) -> some View {
        content
            .font(.system(size:  device == .phone  ? 25 : 30)).foregroundColor(Color.primary)
            .padding()
        
    }
}


