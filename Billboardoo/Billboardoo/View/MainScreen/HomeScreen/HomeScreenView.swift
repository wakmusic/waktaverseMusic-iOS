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
                    
                    NewsView().environmentObject(playState)
                    
                  
                    
                    
                    
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
            .foregroundColor(Color.primary)
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
                .foregroundColor(Color.primary)
        })
        
        
    }
}





extension HomeScreenView{
    
    final class HomeScreenViewModel:ObservableObject{
        @Published var selectedIndex:Int = 0
        @Published var nowChart:[RankedSong] = [RankedSong]()
        var subscription = Set<AnyCancellable>()
        
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
                    
                }.store(in: &subscription)
        }
        
        
        
    }
}
