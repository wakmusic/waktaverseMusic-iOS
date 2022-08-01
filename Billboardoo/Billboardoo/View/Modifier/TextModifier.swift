//
//  SwiftUIView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/30.
//

import SwiftUI


struct FullScreenTitleModifier: ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        
        content.font(.system(size: window.height/35, weight: .bold, design: .default))
            .lineLimit(1) // 1줄 제한
            .truncationMode(.tail) //뒤에짜리기
        
    }
}

struct FullScreenArtistModifer: ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        
        content.font(.system(size: window.height/45,design: .serif)).foregroundColor(.secondary)
            .lineLimit(1) // 1줄 제한
            .truncationMode(.tail) //뒤에짜리기
    }
}

struct PlayBarTitleModifier: ViewModifier{
    let window = UIScreen.main.bounds
    
    
    func body(content: Content) -> some View {
        content.font(.system(size: window.height/40, weight: .bold, design: .default))
            .lineLimit(1) // 1줄 제한
            .truncationMode(.tail) //뒤에짜리기
    }
}

struct PlayBarArtistModifer: ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        
        content.font(.system(size: window.height/45,design: .serif)).foregroundColor(.secondary)
            .lineLimit(1) // 1줄 제한
            .truncationMode(.tail) //뒤에짜리기
    }
}
