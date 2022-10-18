//
//  CardView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/13.
//

import SwiftUI
import Kingfisher

struct CardView: View {

    var artist: Artist
    @Binding var selectedArtist: String
    let device = UIDevice.current.userInterfaceIdiom
    let url = "\(Const.URL.base)\(Const.URL.static)\(Const.URL.artist)/card/"
    var body: some View {

        VStack(spacing: 0) {
            KFImage(URL(string: "\(url)\(artist.artistId!).png")!)
                    .placeholder({
                        Image("cardholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .mask(Circle())

                    .shadow(color: Color(hexcode: artist.color!), radius: 6, x: 0, y: 7)
                    .shadow(color: Color(hexcode: artist.color!), radius: 2, x: 0, y: -1)

                Text(artist.name!).font(.custom("PretendardVariable-Bold", size: device ==  . phone ? 15 : 25)).foregroundColor(.primary).lineLimit(1)
                    .padding(.bottom, 10)
            }

            .frame(width: device == .phone ? ScreenSize.width/4 : ScreenSize.width/7, height: device == .phone ? ScreenSize.width/4 : ScreenSize.width/10)
            .onTapGesture {
                    selectedArtist = artist.artistId!
            }

            .scaleEffect(selectedArtist == artist.artistId ? 0.9 : 0.8)
            .animation(.easeInOut, value: selectedArtist)

    }
}
