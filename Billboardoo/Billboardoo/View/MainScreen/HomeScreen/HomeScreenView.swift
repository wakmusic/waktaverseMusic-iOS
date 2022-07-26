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
    
    @StateObject var viewModel:HomeScreenViewModel
    
    init(){
        
        _viewModel = StateObject.init(wrappedValue: HomeScreenViewModel())
     
    }
    
    
   
    
    var body: some View {
        ZStack(alignment: .leading)
        {
            ScrollView(.vertical, showsIndicators: false) {
                MainHeader()
                Spacer()
                ChartHeader(title: "Title")
                Spacer()
                RadioButtonGroup { _ in}
                FiveRowSongGridView(displayChart: $viewModel.nowDisplayChart)
                
                
            }
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
            .frame(width: window.width*0.4, height: window.height*0.04) //
    }
}

struct SettinButton: View {
    var body: some View {
        NavigationLink {
            SettingScreenView() //Destination
        } label: {
            //보여질 방식, 버튼 이미지
            Image(systemName: "gearshape.fill")
                .resizable()
                .foregroundColor(Color("PrimaryColor"))
                .frame(width: window.width*0.07, height: window.height*0.04)
        }
        
    }
}


struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
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
        
        
        var cancelBag = Set<AnyCancellable>()
        var now:[SimpleViwer]  {
            get{
                return nowDisplayChart
            }
        }
        
        @Published var nowDisplayChart: [SimpleViwer] = [SimpleViwer]()
        @Published var topToalChart: [SimpleViwer] = [SimpleViwer]()
        @Published var topTimeChart: [SimpleViwer] = [SimpleViwer]()
        @Published var topDailyTChart: [SimpleViwer] = [SimpleViwer]()
        @Published var topWeeklyToalChart : [SimpleViwer] = [SimpleViwer]()
        @Published var topMonthlyToalChart : [SimpleViwer] = [SimpleViwer]()
        
        
        init()
        {
            print("HomeScreenViewModel is Init")
            fetChTopChart(category: .total)
            fetChTopChart(category: .time)
            fetChTopChart(category: .daily)
            fetChTopChart(category: .weekly)
            fetChTopChart(category: .monthly)
        }
        
        func fetChTopChart(category:TopCategory)
        {
            Repository.shared.fetchTop100(category: category)
                .sink { completion in
                    
                    switch completion
                    {
                    case .failure(let err_):
                        
                        print("\(category) is Error")
                        
                    
                    case .finished:
                        print("\(category) is Finished ")
                    }
                } receiveValue: { [weak self] (datas:[SimpleViwer]) in
                    
                    guard let self = self else {return}
                    switch category {
                    case .total:
                        self.topToalChart = datas
                        self.nowDisplayChart = datas
                    case .time:
                        self.topTimeChart = datas
                    case .daily:
                        self.topDailyTChart = datas
                    case .weekly:
                        self.topWeeklyToalChart = datas
                    case .monthly:
                        self.topMonthlyToalChart = datas
                    }
                    
                }.store(in: &cancelBag)
        }
        
        
        
    }
}
