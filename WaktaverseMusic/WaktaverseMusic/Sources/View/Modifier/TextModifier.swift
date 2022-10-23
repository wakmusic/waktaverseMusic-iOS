//
//  SwiftUIView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/30.
//

import SwiftUI

struct FullScreenTitleModifier: ViewModifier {
    let device = UIDevice.current.userInterfaceIdiom
    let window = UIScreen.main.bounds

    func body(content: Content) -> some View {

        content.font(.custom("PretendardVariable-Bold", size: device ==  . phone ? 20 : 23)).lineLimit(1)

    }
}

struct FullScreenArtistModifer: ViewModifier {
    let device = UIDevice.current.userInterfaceIdiom
    let window = UIScreen.main.bounds

    func body(content: Content) -> some View {

        content.font(.custom("PretendardVariable-Regular", size: device ==  . phone ? 15 : 20)).foregroundColor(.secondary)
            .lineLimit(1) // 1줄 제한

    }
}

struct FullScreenTimeModifer: ViewModifier {
    let device = UIDevice.current.userInterfaceIdiom
    let window = UIScreen.main.bounds

    func body(content: Content) -> some View {
        content.font(.custom("PretendardVariable-Regular", size: 15)).lineLimit(1).foregroundColor(Color.primary)
            .lineLimit(1) // 1줄 제한

    }
}

struct PlayBarTitleModifier: ViewModifier {
    let window = UIScreen.main.bounds
    let device = UIDevice.current.userInterfaceIdiom

    func body(content: Content) -> some View {
        content.font(.custom("PretendardVariable-Bold", size: device ==  . phone ? 15 : 25)).lineLimit(1)

    }
}

struct PlayBarArtistModifer: ViewModifier {
    let window = UIScreen.main.bounds
    let device = UIDevice.current.userInterfaceIdiom

    func body(content: Content) -> some View {

        content.font(.custom("PretendardVariable-Regular", size: device ==  . phone ? 13 : 28)).foregroundColor(.secondary)
            .lineLimit(1)
    }
}
