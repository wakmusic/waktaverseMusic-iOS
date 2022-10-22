//
//  ChartMoreView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/06.
//
import SwiftUI
import Combine
import Kingfisher
import Foundation

// MARK: 차트 더보기를 눌렀을 때 나오는 뷰 입니다.
struct ChartMoreView: View {
    @State var index: Int = 0 // 애니메이션 때문에 ChartMoreView에서는 index 사용 후 Disapper에서 BindingIndex로 값 전달
    @Binding var Bindingindex: Int
    @EnvironmentObject var playState: PlayState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // 스와이프하여 뒤로가기를 위해
    @StateObject var viewModel: ChartViewModel = ChartViewModel()
    @Binding var musicCart: [SimpleSong]
    let hasNotch: Bool = UIDevice.current.hasNotch

    var body: some View {

        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                HeaderView()
                Spacer()
            } // 이세돌 배경

            VStack(spacing: 0) {
                ScrollView {
                    Spacer(minLength: ScreenSize.height / 6)
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(viewModel.currentShowCharts.indices, id: \.self) { index in
                                ChartItemView(rank: index+1, song: viewModel.currentShowCharts[index], musicCart: $musicCart)
                            }

                        } header: {
                            PinnedHeaderView(selectedIndex: $index, chart: $viewModel.currentShowCharts, updateTime: $viewModel.updateTime).environmentObject(playState)
                                .background(Color.forced) // 필터 ~ 업데이트 시간 부분까지

                        }

                    } // LazyVStack
                    .background(Color.forced) // 차트 아이템 부분
                    .animation(.ripple(), value: viewModel.currentShowCharts)
                        .onChange(of: index, perform: { newValue in
                            switch newValue {
                            case 0:
                                viewModel.fetchChart(.total)

                            case 1:
                                viewModel.fetchChart(.hourly)

                            case 2:
                                viewModel.fetchChart(.daily)

                            case 3:
                                viewModel.fetchChart(.weekly)

                            case 4:
                                viewModel.fetchChart(.monthly)

                            default:
                                print("Default")
                            }

                        })
                }
            }
            .onAppear(perform: {
                // 초기에 이전 화면 정보와 같게 하기 위해
                index = Bindingindex

                switch index {
                case 0:
                    viewModel.fetchChart(.total)

                case 1:
                    viewModel.fetchChart(.hourly)

                case 2:
                    viewModel.fetchChart(.daily)

                case 3:
                    viewModel.fetchChart(.weekly)

                case 4:
                    viewModel.fetchChart(.monthly)

                default:
                    print("Default")
                }
            })
            .onDisappear(perform: {
                Bindingindex = index // 닫힐 때 저장된 인덱스 보냄
            })

        } // ZStack
        .navigationBarBackButtonHidden(true) // 백 버튼 없애고
        .navigationBarHidden(true) // Bar 제거
        // .ignoresSafeArea(.container,edges:.vertical)
            .padding(1) // safeArea 방지

            .gesture(DragGesture().onEnded({ value in
                if(value.translation.width > 100) // 왼 오 드래그가 만족할 때
                {
                    musicCart.removeAll()
                    self.presentationMode.wrappedValue.dismiss() // 뒤로가기
                }
            }))

    } // body

}

struct HeaderView: View {
    var body: some View {

        Image("mainChartLogo")
            .resizable()
            .scaledToFit()
            // .aspectRatio(contentMode: .fit)
            .frame(width: ScreenSize.width, height: ScreenSize.height/6)
            .opacity(0.3)
            .overlay(alignment: .center) {
                VStack {
                    // 텍스트 크기를 proxy를 기준으로 변경
                    Text("WAKTAVERSE MUSIC").font(.system(size: ScreenSize.height/30, weight: .light, design: .default))
                    Text("HOT 100").font(.custom("GmarketSansTTFBold", size: ScreenSize.height/21))
                }
            }
    }
}

struct PinnedHeaderView: View {

    @Binding var selectedIndex: Int
    @Namespace var animation
    @EnvironmentObject var playState: PlayState
    @Binding var chart: [RankedSong]
    @Binding var updateTime: Int

    var body: some View {

        let types: [String] = ["누적", "시간", "일간", "주간", "월간"]

        VStack(spacing: 20) {
            // - MARK: TAB bar
            HStack(spacing: 5) {
                ForEach(types.indices, id: \.self) { idx in

                    VStack(spacing: 12) {

                        Text(types[idx])
                            .font(.system(size: 15)) //
                            .foregroundColor(selectedIndex == idx ? Color.primary : .gray)

                        ZStack { // 움직이는 막대기
                            if selectedIndex == idx {
                                RoundedRectangle(cornerRadius: 4, style: .continuous).fill( Color.primary).matchedGeometryEffect(id: "TAB", in: animation)

                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous) .fill(.clear)

                            }
                        }

                        .frame(height: 4)
                    }
                    .frame(width: ScreenSize.width/6) // 중간에 넣기위해 width를 6등분
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            if selectedIndex != idx {

                                selectedIndex = idx
                            }

                        }
                    }
                }
            }

            // - MARK: 셔플 및 전체 듣기
            HStack(spacing: 0) {

                RoundedRectangleButton(width: ScreenSize.width/2.5, height: ScreenSize.width/15, text: "전체 재생", color: .tabBar, textColor: .primary, imageSource: "play.fill")
                    .onTapGesture {
                        playState.playList.removeAll() // 전부 지운후
                        playState.playList.list = castingFromRankedToSimple(rankedList: chart)  // 현재 해당 chart로 덮어쓰고
                        playState.play(at: playState.playList.first) // 첫번째 곡 재생
                        playState.playList.currentPlayIndex = 0 // 인덱스 0으로 맞춤
                    }
                Spacer()

                RoundedRectangleButton(width: ScreenSize.width/2.5, height: ScreenSize.width/15, text: "셔플 재생", color: .tabBar, textColor: .primary, imageSource: "shuffle")
                    .onTapGesture {
                        playState.playList.removeAll() // 전부 지운후
                        playState.playList.list = castingFromRankedToSimple(rankedList: chart) // 현재 해당 chart로 덮어쓰고
                        playState.playList.list.shuffle()  // 셔플 시킨 후
                        playState.play(at: playState.playList.first) // 첫번째 곡 재생
                        playState.playList.currentPlayIndex = 0 // 인덱스 0으로 맞춤
                    }

            }.padding(.horizontal)

            HStack {
                Spacer()
                Image(systemName: "checkmark").foregroundColor(Color.primary).font(.caption)
                Text(updateTime.convertUpdatedTime()).font(.caption)

            }.padding(.trailing, 5)
        }
        .frame(height: ScreenSize.height/6)
        .padding(.vertical, 10)

    }
}

struct ChartItemView: View {

    var rank: Int
    var song: RankedSong
    @EnvironmentObject var playState: PlayState
    @Binding var musicCart: [SimpleSong]
    @State var isSelected: Bool = false

    var body: some View {
        let simpleSong = SimpleSong(song_id: song.song_id, title: song.title, artist: song.artist)

        HStack {
            RankView(now: rank, last: song.last)

            KFImage(URL(string: song.song_id.albumImage()))
                .placeholder({
                    Image("PlaceHolder")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .transition(.opacity.combined(with: .scale))
                })
                // 대부분 500*500 or 480*360 으로 들어옴
                .downsampling(size: CGSize(width: 200, height: 200)) // 약 절반 사이즈
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 45, height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.vertical, 5)

            VStack(alignment: .leading, spacing: 8) {
                Text(song.title).font(.caption2).bold().lineLimit(1)
                Text(song.artist).font(.caption2).lineLimit(1)
            }.frame(maxWidth: .infinity, alignment: .leading)

            // -Play and List Button

            Text(song.views.convertViews()).font(.caption2).lineLimit(1).padding(.trailing, 5)

        }
        .contentShape(Rectangle()) // 빈곳을 터치해도 탭 인식할 수 있게, 와 대박 ...
        .onTapGesture {

            isSelected.toggle()
            if musicCart.contains(simpleSong) {
                musicCart = musicCart.filter({$0 != simpleSong})
            } else {
                musicCart.append(simpleSong)
            }
        }

        .background( musicCart.contains(simpleSong) == true ? Color.tabBar : .clear)
        .foregroundColor(.primary)

    }

}

func castingFromRankedToSimple(rankedList: [RankedSong]) -> [SimpleSong] {
    var simpleList: [SimpleSong] = [SimpleSong]()

    for rSong in rankedList {
        simpleList.append(SimpleSong(song_id: rSong.song_id, title: rSong.title, artist: rSong.artist))
    }

    return simpleList
}
