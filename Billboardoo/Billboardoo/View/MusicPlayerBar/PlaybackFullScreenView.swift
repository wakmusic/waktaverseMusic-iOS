//
//  PlaybackFullScreenView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import SwiftUI
import Kingfisher
import UIKit
import PopupView

struct PlaybackFullScreenView: View {
    
    var animation: Namespace.ID //화면전환을 위한 애니메이션 Identify
    @EnvironmentObject var playState:PlayState
    var titleModifier = FullScreenTitleModifier()
    var artistModifier = FullScreenArtistModifer()
    @GestureState  private var dragOffset = CGSize.zero // 스와이프하여 뒤로가기를 위해
    
    
    let window = UIScreen.main.bounds
    var body: some View {
        let window = UIScreen.main.bounds
        let standardLen = window.width > window.height ? window.width : window.height
        
        if let currentSong = playState.nowPlayingSong
        {
            //if let artwork = bringAlbumImage(url: currentSong.image)
            
            ZStack{
                HStack(alignment:.top){
                    VStack() {
                        
                        //Spacer(minLength: 0)
                        /*
                         .aspectRatio(contentMode: .fit) == scaledToFit() ⇒ 이미지의 비율을 유지 + 이미지의 전체를 보여준다.
                         .aspectRatio(contentMode: .fill) ⇒ 이미지의 비율을 유지 + 이미지가 잘리더라도 꽉채움
                         */
                        //                    Image(uiImage: artwork)
                        
                        
                        Group{ //그룹으로 묶어 조건적으로 보여준다.
                            if playState.isPlayerListViewPresented {
                                
                                PlayListView().environmentObject(playState).padding(.top,UIDevice.current.hasNotch ? 30 : 0) //notch에 따라 패팅 top 줌 (
                                
                                    
                            }
                            
                            else
                            {
                                Spacer()
                                KFImage(URL(string: currentSong.image.convertFullThumbNailImageUrl())!)
                                    .placeholder({
                                        Image("placeHolder")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: standardLen*0.4, height: standardLen*0.4)
                                            .transition(.opacity.combined(with: .scale))
                                    })
                                    .resizable()
                                    .frame(width:standardLen*0.4,height: standardLen*0.4)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                                    .scaleEffect(0.8)
                                    .shadow(color: .primary.opacity(0.2), radius: 30, x: -60, y: 60)
                                    .gesture(DragGesture().onEnded({ value in
                                        
                                        //위에서 꺼지는 작업이 아닐 때
                                        //width가  (왼->오) + (backWard)
                                        //width가. (오->왼) - (forWard)
                                        
                                        let tranlationWidth = value.translation.width
                                        
                                        if tranlationWidth > 100 {
                                            withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.85)) {
                                                playState.backWard()
                                            }
                                        }
                                        
                                        if tranlationWidth < -100 {
                                            withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.85)) {
                                                playState.forWard()
                                            }
                                        }
                                        
                                    }))
                                    
                                //각 종 애니메이션
                                
                                VStack(alignment: .center){ //리스트 보여주면 .leading
                                    Text(currentSong.title)
                                        .modifier(titleModifier)
                                    
                                    Text(currentSong.artist)
                                        .modifier(artistModifier)
                                }
                            }
                            
                            
                        }
                        
                        
                        
                        
                     
                            
                          
                        
                            
                            
                          
                            
                
                       
                        
                        
                        
                        
                        Spacer(minLength: 0)
                        
                        
                   
                        
                        
                        ProgressBar().padding(.horizontal)
                        
                        
                
                        PlayBar().environmentObject(playState)
                            .padding(.bottom,20) //밑에서 띄우기
                            .padding(.horizontal)
                         
                        
                        
                        
                        
                    }.frame(width:window.width) // notch 없는 것들 오른쪽 치우침 방지..
                }
                
                
                .background(
                 
                    
                    //                    Rectangle().foregroundColor(Color(artwork.averageColor ?? .clear)) //평균 색깔 출후 바탕에 적용
                    //                        .saturation(0.5) //포화도
                    //                        .background(.ultraThinMaterial) // 백그라운드는 blur 처리
                    //                        .edgesIgnoringSafeArea(.all)
                    
                    // playList 백그라운드 색 해결 못해서 주석 ..
                    //.ultraThinMaterial
                    
            )
            }
//            .popup(isPresented: $showVolume, type: .toast, position: .bottom, animation: .easeOut, autohideIn: nil, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: true, backgroundColor:.black.opacity(0.4)) {
//                VolumeSheet().environmentObject(playState)
//            }
            
            
            
        }
        
        
    }
}


struct PlayBar: View {
    
    
    var buttonModifier: FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    @EnvironmentObject var playState:PlayState
    @State var isLike:Bool = false
    
    var body: some View {
        HStack()
        {
          
            Button {  //리스트 버튼을 누를 경우 animation과 같이 toggle
                withAnimation(.easeInOut) {
                    playState.isPlayerListViewPresented.toggle()
                   
                }
                
            }label: {
                Image(systemName: "music.note.list")
                    
                    .modifier(buttonModifier)
            }
         
           Spacer()
            
            
            Button {
                playState.backWard()
                //토스트 메시지 필요
            } label: {
                Image(systemName: "backward.fill")
                   
                    .modifier(buttonModifier)
                
            }
            
            Spacer()
            
            PlayPuaseButton().environmentObject(playState)
            
            Spacer()
            
            
            
            Button {
                playState.forWard()
                //토스트 메시지 필요
            } label: {
                Image(systemName: "forward.fill")
                    
                    .modifier(buttonModifier)
                
            }
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut)
                {
                    isLike.toggle()
                }
                //토스트 메시지 필요
            } label: {
                Image(systemName:  isLike == true ? "heart.fill" : "heart")
                    
                    .modifier(buttonModifier)
            }
          
            
        
           
            
            
            
            
            
        }
        //.foregroundColor(Color.primary)
    }
}




struct ProgressBar: View{
    
    @EnvironmentObject var playState:PlayState
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @State var playtime:String = "00:00"
    @State var endtime:String = "00:00"
    
    
    var body: some View{
        
        if playState.nowPlayingSong != nil {
            VStack {
                
                //Sldier 설정 및 바인딩
             
                    Slider(value:$playState.currentProgress,in: 0...playState.endProgress) { change in
                        //onEditChanged
                        if(change == false) //change == true는 slider를 건들기 시작할 때 false는 slider를 내려 놓을 때
                        {
                            playState.youTubePlayer.seek(to: playState.currentProgress, allowSeekAhead: true) //allowSeekAhead = true 서버로 요청
                        }
                    }.onAppear {
                        // 슬라이더 볼 사이즈 수정
                        let progressCircleConfig = UIImage.SymbolConfiguration(scale: .medium)
                        UISlider.appearance()
                            .setThumbImage(UIImage(systemName: "circle.fill",
                                                   withConfiguration: progressCircleConfig), for: .normal)
                }
                
                  
                   
               

                
                HStack{
                    
                    Text(playtime).modifier(FullScreenTimeModifer())
                    Spacer()
                    Text(endtime).modifier(FullScreenTimeModifer())
                }
                
            }.onReceive(timer) { _ in
                
                playState.youTubePlayer.getCurrentTime { completion in
                    switch completion{
                    case .success(let time):
                        playState.currentProgress = time
                        playtime = playState.convertTimetoString(time)
                        endtime = playState.convertTimetoString(playState.endProgress)
                       
                    case.failure(_):
                        print("\(#function) \(#line) Error 발생")
                    }
                }
            }
        }
    }
}






