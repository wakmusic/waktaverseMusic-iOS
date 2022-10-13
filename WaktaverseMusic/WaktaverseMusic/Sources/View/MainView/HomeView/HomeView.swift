//
//  HomeScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/21.
//

import SwiftUI
import Combine
import Alamofire

struct HomeView: View {
    @ScaledMetric var scale: CGFloat = 15
    @StateObject var viewModel: HomeViewModel = HomeViewModel() // StateObject로 선언 View에 종속하지않기위해
    @EnvironmentObject var playState: PlayState
    @Binding var musicCart: [SimpleSong]

    @State var index: Int = 0

    var body: some View {
        ZStack(alignment: .leading) {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    ChartHeaderView(chartIndex: $index, musicCart: $musicCart)
                    RadioButtonGroupView(selectedId: $index, musicCart: $musicCart) { (_, _) in

                    }.environmentObject(playState)

                    FourRowSongGridView(nowChart: $viewModel.nowChart).environmentObject(playState) // nowChart 넘겨주기
                        .onChange(of: index) { newIndex in
                            viewModel.didChangeNowChart(index: newIndex)
                        }
                        .animation(.easeInOut, value: viewModel.nowChart)

                    NewSongOfTheMonthView(viewModel: viewModel).environmentObject(playState)

                    NewsView(viewModel: viewModel).environmentObject(playState)

                    Spacer(minLength: 30)

                    VStack(spacing: 10) {
                        Text("(주)빌보두왁론주식회사").font(.caption).foregroundColor(.gray)
                        Text("ⓒ Wak Entertainment Corp.").font(.caption).foregroundColor(.gray)
                        /*Image("youtube")
                            .resizable()
                            .frame(width: width/2, height: width/12)
                            .scaledToFill()*/

                    }

                    Spacer(minLength: 20)

                } // ScrollView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        NavigationLogo()
                    }

                }

            }.navigationViewStyle(.stack) // Naivi

        }
    }
}

struct NavigationLogo: View {
    let width = min(ScreenSize.width, ScreenSize.height)
    let height = max(ScreenSize.width, ScreenSize.height)
    let device = UIDevice.current.userInterfaceIdiom
    var body: some View {
        Image("MainLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: device == .phone ? width*0.5 : width*0.4, height: device == .phone ? width*0.3 : width*0.3)

    }
}
