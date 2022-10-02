//
//  NewSongOfTheMonth.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/11.
//

import SwiftUI
import Foundation
import Combine
import Kingfisher

// MARK: 이달의 신곡 뷰 입니다.
struct NewSongOfTheMonthView: View {

    @EnvironmentObject var playState: PlayState
    @ObservedObject var viewModel: HomeViewModel

    private let rows = [GridItem(.fixed(150), spacing: 10), GridItem(.fixed(150), spacing: 10)]

    var body: some View {
        AlbumHeader(newSongs: $viewModel.newSongs).environmentObject(playState)
        Divider()
        ScrollView(.horizontal, showsIndicators: false) {

            VStack(alignment: .center) {
                if viewModel.newSongs.count == 0 {
                    HStack { Text("이달의 신곡이 아직 없습니다.").modifier(PlayBarTitleModifier())}.frame(width: UIScreen.main.bounds.width)
                } else {
                    LazyHGrid(rows: rows, spacing: 10) {
                        TwoRowGrid
                    }
                }
            }

        }
    }
}

extension NewSongOfTheMonthView {

    var TwoRowGrid: some View {

        // viewModel.newSongs[0..<6] - > ArraySlice -> Array(Arraylice)
        // (viewModel.newSongs.count < 6 ? viewModel.newSongs: Array(viewModel.newSongs[0..<6])

        ForEach(viewModel.newSongs, id: \.self.id) { song in
            let simpleSong = SimpleSong(song_id: song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url)
            VStack {

                KFImage(URL(string: song.image.convertFullThumbNailImageUrl())!)
                    .placeholder {
                        Image("placeHolder")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .transition(.opacity.combined(with: .scale))
                    }
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .overlay {
                        ZStack {
                            Button {

                                if playState.currentSong != simpleSong {
                                    playState.currentSong =  simpleSong // 강제 배정
                                    playState.youTubePlayer.load(source: .url(simpleSong.url)) // 강제 재생
                                    playState.uniqueAppend(item: simpleSong) // 현재 누른 곡 담기
                                }

                            } label: {
                                Image(systemName: "play.fill").foregroundColor(.white)
                            }

                        }.frame(width: 85, height: 85, alignment: .topTrailing)
                    }
                    .frame(width: 100, height: 100, alignment: .center)

                VStack(alignment: .leading) {
                    Text(song.title).font(.system(size: 13, weight: .semibold, design: Font.Design.default)).lineLimit(1).frame(width: 100, alignment: .leading)
                    Text(song.artist).font(.caption).lineLimit(1).frame(width: 100, alignment: .leading)
                    Text(song.date.convertReleaseTime()).font(.caption2).lineLimit(1).foregroundColor(.gray).frame(width: 100, alignment: .leading)
                }.frame(width: 100)

            }.padding().onTapGesture {

                if playState.currentSong != simpleSong {
                    playState.currentSong =  simpleSong // 강제 배정
                    playState.youTubePlayer.load(source: .url(simpleSong.url)) // 강제 재생
                    playState.uniqueAppend(item: simpleSong) // 현재 누른 곡 담기
                }
            }

        }

    }
}
