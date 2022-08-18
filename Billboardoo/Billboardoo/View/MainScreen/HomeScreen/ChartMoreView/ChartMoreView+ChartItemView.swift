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
                        ForEach(viewModel.currentShowCharts.indices,id:\.self){ index in
                            
                            ChartItemView(rank: index+1, song: viewModel.currentShowCharts[index])
                        }
                        
                    } header: {
                        PinnedHeaderView(selectedIndex: $index,chart:$viewModel.currentShowCharts,updateTime: $viewModel.updateTime).background(Color("forcedBackground")).environmentObject(playState) //header 위로 올렸을 때 가리기 위함
                        
                    }
                    
                }
                
            }.onAppear(perform: {
                //초기에 이전 화면 정보와 같게 하기 위해
                
                index = Bindingindex
                
                switch index{
                case 0:
                    viewModel.fetchChart(.total)
                    viewModel.fetchUpdateTime(.total)
                case 1:
                    viewModel.fetchChart(.time)
                    viewModel.fetchUpdateTime(.time)
                    
                case 2:
                    viewModel.fetchChart(.daily)
                    viewModel.fetchUpdateTime(.daily)
                    
                case 3:
                    viewModel.fetchChart(.weekly)
                    viewModel.fetchUpdateTime(.weekly)
                case 4:
                    viewModel.fetchChart(.monthly)
                    viewModel.fetchUpdateTime(.monthly)
                default:
                    print("Default")
                }
            })
            .onChange(of: index, perform: { newValue in
                switch newValue{
                case 0:
                    viewModel.fetchChart(.total)
                    viewModel.fetchUpdateTime(.total)
                case 1:
                    viewModel.fetchChart(.time)
                    viewModel.fetchUpdateTime(.time)
                    
                case 2:
                    viewModel.fetchChart(.daily)
                    viewModel.fetchUpdateTime(.daily)
                    
                case 3:
                    viewModel.fetchChart(.weekly)
                    viewModel.fetchUpdateTime(.weekly)
                case 4:
                    viewModel.fetchChart(.monthly)
                    viewModel.fetchUpdateTime(.monthly)
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
            .padding(.vertical,20) // 가리기 위한 패딩
        
        
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
                            Text("BILLBOARDOO CHART").font(.system(size: proxy.size.height/5, weight: .light, design: .default))
                            Text("HOT 100").font(.custom("LeferiPoint-Special", size: proxy.size.height/3)).bold()
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
    @EnvironmentObject var playState:PlayState
    @Binding var chart:[RankedSong]
    @Binding var updateTime:Int
    
    var body: some View{
        
        let types: [String] = ["누적","시간","일간","주간","월간"]
        VStack(spacing:10) {
            ScrollView(.horizontal,showsIndicators: false)
            {
                
                // - MARK: TAB bar
                HStack(spacing:5)
                {
                    ForEach(types.indices, id: \.self){ idx in
                        
                        VStack(spacing:12){
                            
                            Text(types[idx])
                                .font(.system(size: 15)) //
                                .foregroundColor(selectedIndex == idx ? Color.primary : .gray)
                            
                            ZStack{ //움직이는 막대기
                                if (selectedIndex == idx) {
                                    RoundedRectangle(cornerRadius: 4 , style:  .continuous).fill( Color.primary).matchedGeometryEffect(id: "TAB", in: animation)
                                    
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
            // - MARK: 셔플 및 전체 듣기
            HStack{
                ImageButton(text: "셔플 재생", imageSource: "angelGosegu").onTapGesture {
                    playState.playList.removeAll() //전부 지운후
                    playState.youTubePlayer.stop() // stop
                    playState.playList = castingFromRankedToSimple(rankedList: chart) // 현재 해당 chart로 덮어쓰고
                    
                    shuffle(playlist: &playState.playList)  //셔플 시킨 후
                    
                    playState.currentPlayIndex = 0 // 인덱스 0으로 맞춤
                    playState.youTubePlayer.load(source: .url(chart[0].url)) //첫번째 곡 재생
                    playState.youTubePlayer.play()
                    
                }
                ImageButton(text: "100곡 전체 듣기", imageSource: "jingboy").onTapGesture {
                    playState.playList.removeAll() //전부 지운후
                    playState.youTubePlayer.stop() // stop
                    playState.playList = castingFromRankedToSimple(rankedList: chart)  // 현재 해당 chart로 덮어쓰고
                    playState.currentPlayIndex = 0 // 인덱스 0으로 맞춤
                    playState.youTubePlayer.load(source: .url(chart[0].url)) //첫번째 곡 재생
                    playState.youTubePlayer.play()
                    
                    
                }
            }.padding(.top)
            
            HStack{
                Spacer()
                Image(systemName: "checkmark").foregroundColor(Color.primary).font(.caption)
                Text(convertTimeStamp(updateTime)).font(.caption)
                
            }
        }.padding(.bottom).padding(.horizontal)
        
    }
}



struct ChartItemView: View {
    
    
    var rank:Int
    var song:RankedSong
    @EnvironmentObject var playState:PlayState
    @State var showAlert = false
    var body: some View {
        
        
        HStack{
            RankView(now: rank, last: song.last)
            
            KFImage(URL(string: song.image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:45,height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 10,style: .continuous))
            
            VStack(alignment:.leading,spacing: 8)
            {
                Text(song.title).font(.caption2).bold().lineLimit(1)
                Text(song.artist).font(.caption2).lineLimit(1)
            }.frame(maxWidth: .infinity ,alignment: .leading)
            
            
            
            
            // -Play and List Button
            
            Text(convertViews(song.views)).font(.caption2).lineLimit(1)
            
            
            
            
            
            
            
            Menu { //메뉴
                
                
                Button(role:.cancel) {
                    showAlert = playState.appendList(item: SimpleSong(song_id: song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url))
                } label: {
                    Label {
                        Text("담기")
                    } icon: {
                        Image(systemName: "text.badge.plus")
                    }
                    
                    
                }
                
                Button {
                    let simpleSong = SimpleSong(song_id:song.song_id, title: song.title, artist: song.artist, image: song.image, url: song.url)
                    playState.currentSong = simpleSong//강제 배정
                    playState.youTubePlayer.load(source: .url(song.url)) //강제 재생
                    playState.uniqueAppend(item: simpleSong) //현재 누른 곡 담기
                } label: {
                    Label {
                        Text("재생")
                    } icon: {
                        Image(systemName: "play.fill")
                    }
                    
                }
                
                
                
            } label: {
                Image(systemName: "ellipsis").font(.title2)
            }.foregroundColor(Color.primary)
            
            
            Spacer()
            
        }.alert("이미 재생목록에 포함되어있습니다.", isPresented: $showAlert) {
            Text("확인")
        }
        
        
    }
    
}

struct ChartItemVIew_Previews: PreviewProvider {
    static var previews: some View {
        ChartItemView(rank: 3, song: RankedSong(song_id: "fgSXAKsq-Vo", title: "리와인드", artist: "이세계아이돌", image:"https://i.imgur.com/pobpfa1.png", url: "https://youtu.be/fgSXAKsq-Vo", last: 2, views: 8557785)).environmentObject(PlayState())
    }
}




struct ImageButton: View {
    
    let window = UIScreen.main.bounds
    var text:String
    var imageSource:String
    let device = UIDevice.current.userInterfaceIdiom
    var body: some View{
        
        
        ZStack(alignment:.center) {
            
        
            Text(text).font(.system(size: device == .phone ? 15 : 20, weight: .black, design: .rounded)).foregroundColor(.white).zIndex(2.0)
            Image(imageSource)
                .resizable()
                .frame(width: device == .phone ?  window.width/2.5 : window.width/6, height: device == .phone ? window.width/8 : window.width/18, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .clipShape(Capsule())
            LinearGradient(colors: [.clear,.black.opacity(0.7)], startPoint: .leading, endPoint: .trailing).clipShape(Capsule())
                .frame(width: device == .phone ?  window.width/2.5 : window.width/6, height: device == .phone ? window.width/8 : window.width/18)
            
            
        }
        
    }
}

extension ChartMoreView{
    
    final class ChartViewModel:ObservableObject{
        @Published var currentShowCharts:[RankedSong] = [RankedSong]()
        @Published var updateTime:Int = 0
        var subscription = Set<AnyCancellable>()
        
        
        func fetchChart(_ category:TopCategory)
        {
            Repository.shared.fetchTop100(category: category).sink { completion in
                
                switch completion{
                case .failure(let err):
                    print("\(Date()) \(#file) \(#function) \(#line)")
                case.finished:
                    print("chart: \(category) finish")
                    
                }
                
            } receiveValue: { [weak self] (data:[RankedSong]) in
                
                guard let self = self else {return}
                
                self.currentShowCharts = data
                
                
            }.store(in: &subscription)
            
        }
        
        func fetchUpdateTime(_ category:TopCategory)
        {
            Repository.shared.fetchUpdateTimeStmap(category: category).sink { completion in
                
                switch completion
                {
                case .failure(let err):
                    print("\(Date()) \(#file) \(#function) \(#line)")
                case.finished:
                    print("chart: \(category) update time  finish")
                }
                
            } receiveValue: { [weak self] time in
                
                guard let self = self else {return}
                
                self.updateTime = time
            }.store(in: &subscription)
            
        }
    }
}


func convertViews(_ views:Int) -> String // 조회수 변환 함수
{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal

    let result = numberFormatter.string(from: NSNumber(value: views))!
    
    return "\(result)회"
    
    
}

func convertTimeStamp(_ time:Int) -> String{
    let dateFormater : DateFormatter = DateFormatter()
    dateFormater.dateFormat = "yyyy.MM.dd hh:mm"
        
   return dateFormater.string(from: Date(timeIntervalSince1970:TimeInterval(time)))
                        
}


func castingFromRankedToSimple(rankedList:[RankedSong]) ->[SimpleSong]
{
    var simpleList:[SimpleSong] = [SimpleSong]()
    
    
    for rSong in rankedList {
        simpleList.append(SimpleSong(song_id: rSong.song_id, title: rSong.title, artist: rSong.artist, image: rSong.image, url: rSong.url))
    }
    
    return simpleList
}


func shuffle(playlist:inout [SimpleSong]){
    
    
    for i in 0..<playlist.count - 1 { // 0 ~ n-2
        let randomIndex = Int.random(in: i..<playlist.count)
          
        let temp = playlist[i]
        playlist[i] = playlist[randomIndex]
        playlist[randomIndex] = temp
    }
}
