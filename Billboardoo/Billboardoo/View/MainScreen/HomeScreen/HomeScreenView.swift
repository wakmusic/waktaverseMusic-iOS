//
//  HomeScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/21.
//

import SwiftUI
import Combine
import Alamofire


struct HomeScreenView: View {
    @ScaledMetric var scale: CGFloat = 15
    @StateObject var viewModel:HomeScreenViewModel //StateObject로 선언 View에 종속하지않기위해
    @EnvironmentObject var playState:PlayState
    
    
    init(){
        _viewModel = StateObject.init(wrappedValue: HomeScreenViewModel())
        
    }
    
    
    
    
    var body: some View {
        ZStack(alignment: .leading)
        {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    //                    MainHeader()
                    //                    Spacer()
                    
                    RadioButtonGroup(selectedId:$viewModel.selectedIndex) { (prev:Int, now:Int) in
                        
                        print("")
                        
                    }.environmentObject(playState)
                    
                    FiveRowSongGridView(nowChart: $viewModel.nowChart).environmentObject(playState) //nowChart 넘겨주기
                        .onChange(of: viewModel.selectedIndex) { newValue in
                            
                            
                            switch newValue{
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
                            default :
                                viewModel.fetchTop20(category: .total)
                            }
                            
                            
                        }
                    
                    NewSongOfTheMonthView().environmentObject(playState)
                    
                    NewsView()
                    
                    if(playState.nowPlayingSong != nil) // 플레이어 바 나올 때 그 만큼 올리기 위함
                    {
                        
                        Spacer(minLength: 30)
                        
                        
                    }
                    
                    
                    
                } //ScrollView
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                        NavigationLogo()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SettinButton()
                    }
                }
                .padding(.vertical)
            }.navigationViewStyle(.stack) //Naivi
            
            
        }
    }
}

struct NavigationLogo: View {
    let window = UIScreen.main.bounds.size
    var body: some View {
        Image("mainLogoWhite")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("PrimaryColor"))
            .frame(width: window.width*0.4, height: window.height*0.04)
        
    }
}

struct SettinButton:View {
    let window = UIScreen.main.bounds.size
    //@ScaledMetric(relativeTo: .headline)
    //var scale: CGFloat =
    var body: some View{
        
        NavigationLink(destination: SettingScreenView(), label: {
            Image(systemName: "gearshape.fill")
                .resizable()
                .scaledToFill()
            //                .frame(width: window.width*scale, height: window.height*scale)
                .foregroundColor(Color("PrimaryColor"))
        })
        
        
    }
}


struct MainHeader: View {
    var body: some View {
        HStack(alignment: .top) {
            NavigationLogo()
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
    }
}


extension HomeScreenView{
    
    final class HomeScreenViewModel:ObservableObject{
        @Published var selectedIndex:Int = 0
        @Published var nowChart:[RankedSong] = [RankedSong]()
        var cancelBag = Set<AnyCancellable>()
        
        init()
        {
            fetchTop20(category: .total) //초기화  chart는 누적으로 지정
        }
        
        func fetchTop20(category:TopCategory)
        {
            Repository.shared.fetchTop20(category: category)
                .sink { completion in
                    
                    
                } receiveValue: { [weak self] (datas:[RankedSong]) in
                    
                    guard let self = self else {return}
                    
                    self.nowChart = datas  //chart 갱신
                    
                }.store(in: &cancelBag)
        }
        
        
        
    }
}
