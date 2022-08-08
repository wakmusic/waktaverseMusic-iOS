//
//  ChartMoreView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/06.
//

import SwiftUI
import Combine

struct ChartMoreView: View {
    @State var index:Int = 0 //애니메이션 때문에 ChartMoreView에서는 index 사용 후 Disapper에서 BindingIndex로 값 전달
    @Binding var Bindingindex:Int
    @EnvironmentObject var playState:PlayState
    @GestureState private var dragOffset = CGSize.zero // 스와이프하여 뒤로가기를 위해
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // 스와이프하여 뒤로가기를 위해
    @StateObject var viewModel:ChartViewModel = ChartViewModel()
    
    
    // MARK: For Smooth Sliding Effect
    
    
    
    
    
    var body: some View {
        
        VStack
        {
            ScrollView(.vertical,showsIndicators: false)
            {
                
                HeaderView()
                
                
                LazyVStack(alignment:.center,pinnedViews:[.sectionHeaders])
                {
                    Section {
                        ForEach(viewModel.currentShowCharts,id:\.self.id){ songs in
                            
                            Text(songs.title)
                        }
                        
                    } header: {
                        PinnedHeaderView(selectedIndex: $index).background(Color("forcedBackground")) //header 위로 올렸을 때 가리기 위함
                        
                    }
                    
                }
                
            }.onAppear(perform: {
                //초기에 이전 화면 정보와 같게 하기 위해
                
                index = Bindingindex
                
                switch index{
                case 0:
                    viewModel.fetchChart(.total)
                case 1:
                    viewModel.fetchChart(.time)
                    
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
            .onChange(of: index, perform: { newValue in
                switch newValue{
                case 0:
                    viewModel.fetchChart(.total)
                case 1:
                    viewModel.fetchChart(.time)
                    
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
                Bindingindex = index //닫힐 때 저장된 인덱스 보냄
            })
            .coordinateSpace(name: "SCROLL")
        }.navigationBarBackButtonHidden(true) //백 버튼 없애고
            .navigationBarHidden(true) //Bar 제거
        .ignoresSafeArea(.container,edges:.vertical)
        .padding(.vertical,50)
        
        
            .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                
                if(value.translation.width > 100) // 왼 오 드래그가 만족할 때
                {
                    self.presentationMode.wrappedValue.dismiss() //뒤로가기
                }
                
                
            }))
        
    }
}


struct HeaderView: View{
    
    var body: some View{
        
        GeometryReader{ proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY //SCROLL 프레임의 최소Y(가장 위쪽 Y좌표)
            let size = proxy.size
            let hegith = (size.height+minY)
            Image("mainChartLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:size.width,height:hegith,alignment: .center)
                .opacity(0.3)
                .overlay(content: {
                    ZStack(alignment:.center)
                    {
                        VStack{
                            //텍스트 크기를 proxy를 기준으로 변경
                            Text("BILLBOARDOO CHART").font(.system(size: proxy.size.height/8, weight: .light, design: .default))
                            Text("HOT 100").font(.system(size: proxy.size.height/6, weight: .bold, design: .monospaced))
                        }
                        
                    }
                })
            //.offset(y:-minY)
            
            
        }
        .frame(height:UIScreen.main.bounds.height/7) //frame 전체의 /6
    }
}


struct PinnedHeaderView:View{
    
    @Binding var selectedIndex:Int
    @Namespace var animation
    
    var body: some View{
        
        let types: [String] = ["누적","시간","일간","주간","월간"]
        VStack(spacing:10) {
            ScrollView(.horizontal,showsIndicators: false)
            {
                HStack(spacing:20)
                {
                    ForEach(types.indices, id: \.self){ idx in
                        
                        VStack(spacing:12){
                            
                            Text(types[idx])
                                .fontWeight(.semibold)
                                .foregroundColor(selectedIndex == idx ? Color("PrimaryColor") : .gray)
                            
                            ZStack{
                                if (selectedIndex == idx) {
                                    RoundedRectangle(cornerRadius: 4 , style:  .continuous).fill( Color("PrimaryColor")).matchedGeometryEffect(id: "TAB", in: animation)
                                        
                                }
                                else{
                                    RoundedRectangle(cornerRadius: 4 , style:  .continuous) .fill(.clear)
                                        
                                }
                            }
                            
                            .frame(height:4 )
                        }
                        .frame(width:UIScreen.main.bounds.width/6) // 중간에 넣기위해 width를 6등ㅂ으로
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(){
                                if(selectedIndex != idx)
                                {
                                    
                                    selectedIndex = idx
                                }
                                
                            }
                        }
                    }
                }
            }
            
            HStack{
                ImageButton(text: "셔플 재생", imageSource: "jingboy")
                ImageButton(text: "100곡 전체 듣기", imageSource: "jingboy")
            }.padding(.vertical)
        }.padding(.horizontal)
        
    }
}



struct ChartItemView: View {
    
    
    var body: some View {
        
        
        Text("전체 듣기")
        
    }
    
}


struct ImageButton: View {
    
    var text:String
    var imageSource:String
    var body: some View{
        
        
        ZStack(alignment:.center) {
            
            Text(text).font(.system(size: 20, weight: .black, design: .rounded)).foregroundColor(.white).zIndex(2.0)
            Image(imageSource)
                .resizable()
                .frame(width: 150, height: 45, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .clipShape(Capsule())
            LinearGradient(colors: [.clear,.black.opacity(0.7)], startPoint: .leading, endPoint: .trailing).clipShape(Capsule())
                .frame(width: 150, height: 45)
            
            
        }.onTapGesture {
            print("100곡 전체 들어")
        }
        
    }
}

extension ChartMoreView{
    
    final class ChartViewModel:ObservableObject{
        @Published var currentShowCharts:[DetailSong] = [DetailSong]()
        var cancelBag = Set<AnyCancellable>()
        
        
        func fetchChart(_ category:TopCategory)
        {
            Repository.shared.fetchTop100(category: category).sink { completion in
                
                switch completion{
                case .failure(let err):
                    print("\(Date()) \(#file) \(#function) \(#line)")
                case.finished:
                    print("chart: \(category) finish")
                    
                }
                
            } receiveValue: { [weak self] (data:[DetailSong]) in
                
                guard let self = self else {return}
                
                self.currentShowCharts = data
                
                
            }.store(in: &cancelBag)
            
        }
    }
}

