//
//  SearchView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/16.
//

import SwiftUI
import Combine
import Kingfisher
import PopupView

struct SearchView: View {

    @StateObject private var viewModel: SearchViewModel = SearchViewModel(initalValue: "", delay: 0.3)
    @EnvironmentObject var playState: PlayState
    @Binding var musicCart: [SimpleSong]
    @AppStorage("isDarkMode") var isDarkMode: Bool = UserDefaults.standard.bool(forKey: "isDarkMode")

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

        }.popup(isPresented: $viewModel.showBottomSheet, type: .toast, position: .bottom, animation: .easeInOut, closeOnTap: true, closeOnTapOutside: true, backgroundColor: .black.opacity(0.2)) {
            SearchBottomSheetView(viewModel: viewModel, isDarkMode: $isDarkMode)
        }

    }

}

struct SearchBarView: View {

    @ObservedObject var viewModel: SearchViewModel

    var body: some View {

        HStack {
            /*Image(systemName: "magnifyingglass")
             .foregroundColor( viewModel.currentValue.isEmpty ? .searchBaraccentColor : .primary)*/
            Button {
                viewModel.showBottomSheet.toggle()
            } label: {
                HStack(spacing: 2) {
                    Text(viewModel.type == .title ? "노래명"
                         : viewModel.type == .artist ? "가수명"
                         : "조교명"
                    )
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }.padding(.horizontal, 5)
            }

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
                .shadow(color: Color.primary.opacity(0.3), radius: 10, x: 0, y: 0)
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

struct SearchBottomSheetView: View {

    @ObservedObject var viewModel: SearchViewModel
    @Binding var isDarkMode: Bool

    var body: some View {
        ZStack {
            if isDarkMode {
                BlurView().clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))

            } else {
                Color.white.clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
            }

            VStack {
                Color.primary
                    .opacity(0.2)
                    .frame(width: 30, height: 6)
                    .clipShape(Capsule())
                    .padding(.top, 15)
                    .padding(.bottom, 10)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        SheetItemView(name: "노래명", isSelected: viewModel.type == .title, isDarkMode: $isDarkMode)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if viewModel.type != .title {
                                    viewModel.currentValue = ""
                                    viewModel.results.removeAll()
                                    viewModel.type = .title
                                }
                            }

                        SheetItemView(name: "가수명", isSelected: viewModel.type == .artist, isDarkMode: $isDarkMode)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if viewModel.type != .artist {
                                    viewModel.currentValue = ""
                                    viewModel.results.removeAll()
                                    viewModel.type = .artist
                                }
                            }
                        SheetItemView(name: "조교명", isSelected: viewModel.type == .remix, isDarkMode: $isDarkMode)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if viewModel.type != .remix {
                                    viewModel.currentValue = ""
                                    viewModel.results.removeAll()
                                    viewModel.type = .remix
                                }
                            }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

private struct SheetItemView: View {
    let name: String
    let isSelected: Bool
    @Binding var isDarkMode: Bool

    var body: some View {
        HStack(spacing: 12) {

            Text(name.uppercased())
                .font(.system(size: 15, weight: isSelected ? .regular : .light))
                .foregroundColor(.primary)

            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor( isDarkMode ? Color(hexcode: "00F3F3") :Color(hexcode: "18E8E8"))
            }
        }
        .opacity(isSelected ? 1.0 : 0.8)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
