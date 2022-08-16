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
    @State var isUnMute:Bool = true
    @Binding var editMode:Bool
    var titleModifier = FullScreenTitleModifier()
    var artistModifier = FullScreenArtistModifer()
    
    
    let window = UIScreen.main.bounds
    var body: some View {
        let window = UIScreen.main.bounds
        let standardLen = window.width > window.height ? window.width : window.height
        
        if let currentSong = playState.nowPlayingSong
        {
            //if let artwork = bringAlbumImage(url: currentSong.image)
            
            ZStack {
                HStack{
                    VStack {
                        
                        //Spacer(minLength: 0)
                        /*
                         .aspectRatio(contentMode: .fit) == scaledToFit() ⇒ 이미지의 비율을 유지 + 이미지의 전체를 보여준다.
                         .aspectRatio(contentMode: .fill) ⇒ 이미지의 비율을 유지 + 이미지가 잘리더라도 꽉채움
                         */
                        //                    Image(uiImage: artwork)
                        
                        
                        Group{ //그룹으로 묶어 조건적으로 보여준다.
                            if playState.isPlayerListViewPresented {
                                
                                PlayListView(editMode: $editMode).environmentObject(playState).padding(.top,UIDevice.current.hasNotch ? 30 : 0) //notch에 따라 패팅 top 줌 (
                                
                                    
                            }
                            
                            else
                            {
                                KFImage(URL(string: currentSong.image)!)
                                    .resizable()
                                    .frame(width:standardLen*0.5,height: standardLen*0.5)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding()
                                    .scaleEffect(playState.isPlaying == .playing ? 0.8 : 0.6)
                                    .shadow(color: .black.opacity(playState.isPlaying == .playing ? 0.2:0.0), radius: 30, x: -60, y: 60)
                                //각 종 애니메이션
                            }
                            
                            
                        }
                        
                        
                        
                        
                        HStack{
                            
                            if playState.isPlayerListViewPresented { //ListView가 켜지면 작은 썸네일 보이게
                                KFImage(URL(string: currentSong.image)!)
                                    .resizable()
                                    .frame(width:standardLen*0.1,height: standardLen*0.1)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.horizontal)
                                    
                                    
                                    
                            }
                          
                            //  이미지 와 함께 중앙정렬 -> PlayList 꾸미러 가자
                            
                            
                            
                            VStack(alignment: playState.isPlayerListViewPresented ? .leading : .center){ //리스트 보여주면 .leading
                                Text(currentSong.title)
                                    .font(.custom("PretendardVariable-Regular", size: 18)).bold()
                                
                                Text(currentSong.artist)
                                    .modifier(artistModifier)
                            }
                            
                        }
                        .padding(.trailing, playState.isPlayerListViewPresented ? standardLen*0.1 : 0) //리스트 보여줄 때는 이미지 width만큼 padding
                        .padding(.bottom,30)
                        
                        
                        
                        
                        Spacer(minLength: 0)
                        
                        ProgressBar().padding(.horizontal)
                        
                        Spacer(minLength: 0)
                        
                        
                        
                        PlayBar(isUnMute: $isUnMute,editMode: $editMode).environmentObject(playState)
                            .padding(.vertical,playState.isPlayerListViewPresented ? 40 : 60) //밑에서 띄우기
                            .padding(.horizontal)
                        
                        
                        
                        
                    }
                }
                
                .frame(width: window.width, height: window.height)
                .padding(.horizontal)
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
    @Binding var isUnMute:Bool
    @Binding var editMode:Bool
    
    var body: some View {
        HStack
        {
            
            Button {  //리스트 버튼을 누를 경우 animation과 같이 toggle
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.85)) {
                    playState.isPlayerListViewPresented.toggle()
                    if(playState.isPlayerListViewPresented == false) //만약 리스트 꺼지면 editmode 역시 자동으로 꺼짐
                    {
                        editMode = false
                    }
                }
                
            }label: {
                Image(systemName: "music.note.list")
                    .resizable()
                    .modifier(buttonModifier)
            }
            
            
            Spacer()
            
            Button {
                playState.backWard()
                //토스트 메시지 필요
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .modifier(buttonModifier)
                
            }
            
            PlayPuaseButton().environmentObject(playState)
            
            
            
            
            Button {
                playState.forWard()
                //토스트 메시지 필요
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .modifier(buttonModifier)
                
            }
            
            Spacer()
            
            Button {
                isUnMute.toggle()
                if(isUnMute)
                {
                    playState.youTubePlayer.unmute()
                }
                else
                {
                    playState.youTubePlayer.mute()
                }
            } label: {
                Image(systemName: isUnMute ? "speaker.wave.3.fill" : "speaker.slash.fill")
                    .resizable()
                    .modifier(buttonModifier)
                
            }
            
            
            
            
            
        }
        //.foregroundColor(Color("PrimaryColor"))
    }
}




struct ProgressBar: View{
    
    @EnvironmentObject var playState:PlayState
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @State var playtime:String = "00:00"
    @State var endtime:String = "00:00"
    
    
    var body: some View{
        
        if let currentSong = playState.nowPlayingSong {
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
                    let progressCircleConfig = UIImage.SymbolConfiguration(scale: .small)
                    UISlider.appearance()
                        .setThumbImage(UIImage(systemName: "circle.fill",
                                               withConfiguration: progressCircleConfig), for: .normal)
                }
//                ProgressView(value: playState.currentProgress, total: 100)
                
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
                        //print("\(playState.currentProgress)  \(playState.endProgress)")
                    case.failure(let err):
                        print("currentProgress Error")
                    }
                }
            }
        }
    }
}

func bringAlbumImage(url:String) ->UIImage?
{
    let url = URL(string: url)
    let data = try? Data(contentsOf: url!)
    return UIImage(data: data!)
}





