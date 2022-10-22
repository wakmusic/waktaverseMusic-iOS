//
//  HeaderView1.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2022/10/02.
//

import SwiftUI

struct ChartHeaderView: View {

    @Binding var chartIndex: Int
    @Binding var musicCart: [SimpleSong]
    @EnvironmentObject var playState: PlayState

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {
            HStack {
                switch chartIndex {
                case 0:
                    Text("누적 Top 20").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                case 1:
                    Text("실시간 Top 20").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                case 2:
                    Text("일간 Top 20").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                case 3:
                    Text("주간 Top 20").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                case 4:
                    Text("월간 Top 20").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                default:
                    Text("누적 Top 20").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                }
                Spacer()

                NavigationLink {
                    ChartMoreView(Bindingindex: $chartIndex, musicCart: $musicCart).environmentObject(playState)
                } label: {
                    Text("더보기").foregroundColor(.gray)
                }

            }
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

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
                    NewsMoreView()
                } label: {
                    Text("더보기").foregroundColor(.gray)
                }

            }
            Divider()
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
    }
}
