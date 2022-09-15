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
import YouTubePlayerKit

struct MiniPlayer: View {
    
    
    @EnvironmentObject var playState:PlayState
    @EnvironmentObject var player:VideoPlayerViewModel
    var titleModifier = FullScreenTitleModifier()
    var artistModifier = FullScreenArtistModifer()
    var animation: Namespace.ID
    
    
    let window = UIScreen.main.bounds
    var body: some View {
        let window = UIScreen.main.bounds
        let standardLen = window.width > window.height ? window.width : window.height
        let miniWidth:CGFloat = window.width * 0.3
        let miniHeight:CGFloat = (miniWidth*9)/16
        let defaultHeight:CGFloat = (window.width * 9)/16
        let hasNotch:Bool = UIDevice.current.hasNotch
        if let currentSong = playState.nowPlayingSong
        {
            
            
            VStack(spacing:player.isMiniPlayer ? 0 : nil) {
                
                //Spacer(minLength: 0)
                /*
                 .aspectRatio(contentMode: .fit) == scaledToFit() ⇒ 이미지의 비율을 유지 + 이미지의 전체를 보여준다.
                 .aspectRatio(contentMode: .fill) ⇒ 이미지의 비율을 유지 + 이미지가 잘리더라도 꽉채움
                 */
                //
              
               
                if(!player.isMiniPlayer && !player.isPlayerListViewPresented)
                {
                    if(window.height <= 600)
                    {
                        Spacer(minLength: window.height*0.2)
                    }
                    else
                    {
                        Spacer(minLength: window.height*0.3)
                    }
                   
                    
                }
         
                
                HStack(){
                    
                    YoutubeView().environmentObject(playState).frame(maxWidth:player.isMiniPlayer ? miniWidth : player.isPlayerListViewPresented ? 0 : window.width ,maxHeight: player.isMiniPlayer ? miniHeight : player.isPlayerListViewPresented ? 0 : defaultHeight )
                    
                    if(player.isMiniPlayer) //미니 플레이어 시 보여질 컨트롤러
                    {
                        VStack(alignment: .leading){ //리스트 보여주면 .leading
                            Text(currentSong.title)
                                .modifier(PlayBarTitleModifier())

                            Text(currentSong.artist)
                                .modifier(PlayBarArtistModifer())
                        }
                        Spacer()
                        
                        HStack(spacing:20){
                            PlayPuaseButton().environmentObject(playState)
                            
                            
                            Image(systemName: "xmark").modifier(PlayBarButtonImageModifier()).onTapGesture {
                                playState.playList.removeAll()
                        }
                       
                        }.padding(.horizontal)
                        
                    }
                    
                    
                }.frame(maxWidth: player.isPlayerListViewPresented ? 0 : window.width,maxHeight: player.isMiniPlayer ? miniHeight : player.isPlayerListViewPresented ? 0 : defaultHeight ,alignment: .leading)
                
                
                
                
                VStack{
                    Group{ //그룹으로 묶어 조건적으로 보여준다.
                        
                        if player.isPlayerListViewPresented {
                            
                            PlayListView().environmentObject(playState).padding(.top,UIDevice.current.hasNotch ? 30 : 0) //notch에 따라 패팅 top 줌 (
                            
                            
                        }
                        
                        else
                        {
                            
                            
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
                        .padding(.bottom,hasNotch ? 40 :  20) //밑에서 띄우기
                        .padding(.horizontal)
                }.frame(width: player.isMiniPlayer ? 0 : window.width , height: player.isMiniPlayer ? 0 : nil) // notch 없는 것들 오른쪽 치우침 방지..
                    .opacity(player.isMiniPlayer ? 0 : 1)
                
                

                
            }.frame(maxHeight: player.isMiniPlayer ? miniHeight : .infinity) // notch 없는 것들 오른쪽 치우침 방지..
            
            
            
            .background(
                
                VStack(spacing:0)
                {
                   
                    BlurView()
                        .onTapGesture {
                            withAnimation(.spring())
                            {
                                player.isMiniPlayer = false
                                
                            }
                        }
                   
                }
                
            )
            .edgesIgnoringSafeArea(.all)
            .offset(y:player.offset)
            .gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:)))
            
            
            
            
            
            
            
            
        }
        
        
    }
    
    func onChanged(value: DragGesture.Value)
    {
        if value.translation.height > 0 && !player.isMiniPlayer {
            player.offset = value.translation.height
        }
    }
    
    func onEnded(value: DragGesture.Value)
    {
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.96))
        {
            
            if value.translation.height > window.height/3
            {
                player.isMiniPlayer  = true
                player.isPlayerListViewPresented = false
            }
            player.offset = 0
        }
    }
}


struct PlayBar: View {
    
    
    var buttonModifier: FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    @EnvironmentObject var playState:PlayState
    @EnvironmentObject var player:VideoPlayerViewModel
    @State var isLike:Bool = false
    
    var body: some View {
        HStack()
        {
            
            Button {  //리스트 버튼을 누를 경우 animation과 같이 toggle
                withAnimation(.easeInOut) {
                    player.isPlayerListViewPresented.toggle()
                    
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






