//
//  SearchView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/16.
//

import SwiftUI
import Combine
import Kingfisher

struct SearchView: View {

    @StateObject private var viewModel: SearchViewModel = SearchViewModel(initalValue: "", delay: 0.3)
    @EnvironmentObject var playState: PlayState
    @Binding var musicCart: [SimpleSong]

    var body: some View {

            VStack {

                SearchBarView(viewModel: viewModel).padding(10)
                ScrollViewReader { (_: ScrollViewProxy) in
                    ScrollView(.vertical, showsIndicators: false) {

                        LazyVStack(alignment: .center, spacing: 0) {
                            Section {
                                ForEach(viewModel.results, id: \.self.id) { (song: NewSong) in
                                    SongListItemView(song: song, accentColor: .primary, musicCart: $musicCart).environmentObject(playState)

                                }

                            }
                        }.onChange(of: viewModel.debouncedValue) { newValue in
                            if newValue.isEmpty {
                                viewModel.results.removeAll()
                            } else {
                                viewModel.fetchSong(newValue)
                            }

                        }

                    }.onTapGesture {

                        UIApplication.shared.endEditing()

                    }

                    .padding(5)

                }

            }

    }

}

struct SearchBarView: View {

    @ObservedObject var viewModel: SearchViewModel

    var body: some View {

        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor( viewModel.currentValue.isEmpty ? .searchBaraccentColor : .primary)

            TextField("검색어를 입력해주세요", text: $viewModel.currentValue)
                .foregroundColor(Color.primary)
                .disableAutocorrection(true) // 자동완성 끄기

            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.primary)
                .opacity(viewModel.currentValue.isEmpty ? 0.0 : 1.0)

                .onTapGesture {
                    UIApplication.shared.endEditing()
                    viewModel.currentValue = ""
                }.frame(alignment: .trailing)

        }
        .font(.headline)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.searchBarBackground)
                .shadow(color: Color.primary.opacity(0.5), radius: 10, x: 0, y: 0)
        )

    }

}

struct SongListItemView: View {

    var song: NewSong
    @EnvironmentObject var playState: PlayState
    var accentColor: Color
    @Binding var musicCart: [SimpleSong]

    var body: some View {
        let simpleSong = SimpleSong(song_id: song.song_id, title: song.title, artist: song.artist)

        HStack {

            KFImage(URL(string: song.song_id.albumImage()))
                .placeholder({
                    Image("PlaceHolder")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .transition(.opacity.combined(with: .scale))
                })
                .downsampling(size: CGSize(width: 200, height: 200)) // 약 절반 사이즈
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                Text(song.title).foregroundColor(accentColor).font(.caption2).bold().lineLimit(1)
                Text(song.artist).foregroundColor(accentColor).font(.caption2).lineLimit(1)
            }.frame(maxWidth: .infinity, alignment: .leading)

            // -Play and List Button

            Text(song.date.convertReleaseTime()).foregroundColor(accentColor).font(.caption2).lineLimit(1)

            Spacer()

        }.contentShape(Rectangle()).padding(.vertical, 5).onTapGesture {

            if musicCart.contains(simpleSong) {
                musicCart = musicCart.filter({$0 != simpleSong})
            } else {
                musicCart.append(simpleSong)
            }
        }

        .background(musicCart.contains(simpleSong) == true ? Color.tabBar : .clear)

    }

}
