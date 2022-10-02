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
    let width = UIScreen.main.bounds.width

    var body: some View {
        ZStack(alignment: .leading) {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {

                    RadioButtonGroup(selectedId: $viewModel.selectedIndex, musicCart: $musicCart) { (_, _) in

                    }.environmentObject(playState)

                    FiveRowSongGridView(nowChart: $viewModel.nowChart).environmentObject(playState) // nowChart 넘겨주기
                        .onChange(of: viewModel.selectedIndex) { newValue in

                            switch newValue {
                            case 0:
                                viewModel.fetchTop20(category: .total)
                            case 1:
                                viewModel.fetchTop20(category: .time)
                            case 2:
                                viewModel.fetchTop20(category: .daily)
                            case 3:
                                viewModel.fetchTop20(category: .weekly)
                            case 4:
                                viewModel.fetchTop20(category: .monthly)
                            default:
                                viewModel.fetchTop20(category: .total)
                            }

                        }
                        .animation(.easeInOut, value: viewModel.nowChart)

                    NewSongOfTheMonthView().environmentObject(playState)

                    NewsView().environmentObject(playState)

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
        Image("mainLogoWhite")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color.primary)
            .aspectRatio(contentMode: .fit)
            .frame(width: device == .phone ? width*0.5 : width*0.4, height: device == .phone ? width*0.3 : width*0.3)

    }
}
