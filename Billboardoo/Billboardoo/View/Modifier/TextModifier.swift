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
        
        content.font(.custom("PretendardVariable-Bold", size: 25)).lineLimit(1)
        
    }
}

struct FullScreenArtistModifer: ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        
        content.font(.system(size: 20,design: .serif)).foregroundColor(.secondary)
            .lineLimit(1) // 1줄 제한
        
    }
}

struct FullScreenTimeModifer: ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        content.font(.custom("PretendardVariable-Bold", size: 20)).lineLimit(1).foregroundColor(Color.primary)
            .lineLimit(1) // 1줄 제한
         
    }
}




struct PlayBarTitleModifier: ViewModifier{
    let window = UIScreen.main.bounds
    
    
    func body(content: Content) -> some View {
        content.font(.custom("PretendardVariable-Bold", size: 22)).lineLimit(1)
        
    }
}

struct PlayBarArtistModifer: ViewModifier{
    let window = UIScreen.main.bounds
    
    func body(content: Content) -> some View {
        
        content.font(.system(size: 20,design: .serif)).foregroundColor(.secondary)
            .lineLimit(1)
    }
}



