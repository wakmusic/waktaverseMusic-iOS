//
//  HeaderView1.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2022/10/02.
//

import SwiftUI

struct AlbumHeader: View {

    @EnvironmentObject var playState: PlayState
    @Binding var newSongs: [NewSong]
    var body: some View {

        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("이달의 신곡").bold().foregroundColor(Color.primary)
                Spacer()

                NavigationLink {
                    NewSongMoreView(newsongs: $newSongs).environmentObject(playState)
                } label: {
                    Text("더보기").foregroundColor(.gray)
                }

            }
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

struct NewsHeader: View {

    @Binding var news: [NewsModel]

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("NEWS").font(.system(size: 35, weight: .bold, design: .rounded)).foregroundColor(Color.primary)
                Spacer()

                NavigationLink {
                    NewsMoreView(news: $news)
                } label: {
                    Text("더보기").foregroundColor(.gray)
                }

            }
            Divider()
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
    }
}
