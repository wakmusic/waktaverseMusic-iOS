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
                    
    }
}

struct FullScreenArtistModifer: ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        
        content.font(.system(size: window.height/45,design: .serif)).foregroundColor(.secondary)
    }
}

struct PlayBarTitleModifier: ViewModifier{
    let window = UIScreen.main.bounds
    
    
    func body(content: Content) -> some View {
        content.font(.system(size: window.height/40, weight: .bold, design: .default))
    }
}

struct PlayBarArtistModifer: ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        
        content.font(.system(size: window.height/45,design: .serif)).foregroundColor(.secondary)
    }
}
