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
    
    @StateObject var viewModel:HomeScreenViewModel //StateObject로 선언 View에 종속하지않기위해
    
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
                RadioButtonGroup { (prev:Int, now:Int) in
                    
                    if(prev != now) //이전 값과 다를 경우에만 fetch
                    {
                        // 하위 뷰인 라이도 버튼의 선택된 버튼 index의 따라 다른 차트를 가져옴
                        switch now{
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
                }
                FiveRowSongGridView(nowChart: $viewModel.nowChart) //nowChart 넘겨주기
                
                
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
        
        @Published var nowChart:[SimpleSong] = [SimpleSong]()
        var cancelBag = Set<AnyCancellable>()
        
        init()
        {
            fetchTop20(category: .total) //초기화  chart는 누적으로 지정
        }
        
        func fetchTop20(category:TopCategory)
        {
            Repository.shared.fetchTop20(category: category)
                .sink { completion in
                    
                    switch completion
                    {
                    case .failure(let err_):
                        
                        print("\(category) is Error")
                        
                        
                    case .finished:
                        print("\(category) is Finished ")
                    }
                } receiveValue: { [weak self] (datas:[SimpleSong]) in
                    
                    guard let self = self else {return}
                    
                    self.nowChart = datas  //chart 갱신
                    
                }.store(in: &cancelBag)
        }
        
        
        
    }
}
