//
//  PlayListView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/01.
//

import SwiftUI
import UIKit
import Kingfisher
import ScalingHeaderScrollView

struct PlayListView: View {
    
    
    @EnvironmentObject var playState:PlayState
    @State private var multipleSelection = Set<UUID>() // 다중 선택 셋
    @State var draggedItem: SimpleSong? // 현재 드래그된 노래
    var modifier:FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    let device = UIDevice.current.userInterfaceIdiom
    let height = UIScreen.main.bounds.size.height
    let hasNotch = UIDevice.current.hasNotch
    var body: some View {
        
        
        ZStack{
            Color.forced
            
            ScalingHeaderScrollView {
                
                VStack(alignment:.leading,spacing:0){
                    Spacer()
                    Image(systemName: "xmark").font(.title).foregroundColor(.primary).padding(EdgeInsets(top: hasNotch ? 50 : 10, leading: 10, bottom: 0, trailing: 0)).onTapGesture {
                        withAnimation(.easeInOut) {
                            playState.isPlayerListViewPresented = false
                           
                        }
                
                    }
                    
                    
                    Spacer()
                    if let song = playState.currentSong{
                        VStack(alignment:.leading){
                            Text("지금 재생 중").font(.custom("PretendardVariable-Bold", size:  device ==  . phone ? 15 : 20)).foregroundColor(.primary).bold()
                            HStack{
                                NowPlaySongView(song: song)
                                Spacer()
                                
                            }
                            
                                
                                .animation(.easeIn, value: playState.currentSong)
                        }.padding(.leading,10)
                    }
                    
                    Spacer()
                    HStack{
                        TopLeftControlView(playList: $playState.playList,currentIndex: $playState.currentPlayIndex,multipleSelection: $multipleSelection).environmentObject(playState)
                        Spacer()
                        TopRightControlView(playList: $playState.playList,currentIndex: $playState.currentPlayIndex,multipleSelection: $multipleSelection).environmentObject(playState).padding(.trailing,10)
                    }
                    
                    Spacer()
                    
                    
                }.frame(height:height/3).background( Color.forced)
                
                
               
                
            } content: {
                LazyVStack(){
                    
                
                        ForEach(playState.playList,id: \.self.id) { song in
                            
                           
                            ItemCell(song: song, multipleSelection: $multipleSelection).environmentObject(playState)
                                
                                
                            .background(song.song_id == playState.currentSong?.song_id ? Color("SelectedSongBgColor") : .clear)
                            
                            
                            
                            
                            // - MARK: 드래그 앤 드랍으로 옮기기
                            .onDrag{
                                self.draggedItem = song //드래그 된 아이템 저장
                                return NSItemProvider(item: nil, typeIdentifier: song.title)
                            }
                            
                            .onDrop(of:[song.title] , delegate: MyDropDelegate(currentItem: song, currentIndex:$playState.currentPlayIndex, playList:$playState.playList, draggedItem: $draggedItem))
                            
                            
                        }
                    

                    
                    
                }
            }
            .height(min: height/3,max:height/3)
           
            
        }.padding(.top,1)
        
        
        
        
        
        
        
        
    }
    
    
    
    
}




struct ItemCell: View {
    
    var song:SimpleSong // 해당 셀 노래
    @Binding var multipleSelection:Set<UUID> // 다중 선택 셋
    @State var draggedItem: SimpleSong? // 드래그 된 아이템
    @EnvironmentObject var playState:PlayState
    var modifier:FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    let device = UIDevice.current.userInterfaceIdiom
    
    
    
    var body: some View {
        HStack {
            
            Button {
                withAnimation(.spring()) {
                    
                    
                    if(multipleSelection.contains(song.id)) //셋 안에 있을 때 눌리면  remove
                    {
                        multipleSelection.remove(song.id)
                    }
                    else //없는데 눌르면 insert
                    {
                        multipleSelection.insert(song.id)
                    }
                    
                    
                    
                }
            } label: {
                
                Image(systemName:  multipleSelection.contains(song.id) ? "checkmark.circle.fill" : "circle") //멑티 셋 안에 해당 음악 id 있을 때 는 check 없으면 빈 circle
                    .font(.system(size:  device == .phone  ? 20 : 25)).foregroundColor(Color.primary)
                
                    .padding(.leading,10)
            }
            
            
            
            HStack{
                
                
                
                VStack(alignment:.leading){
                    Text(song.title).modifier(PlayBarTitleModifier())
                    Text(song.artist).modifier(PlayBarArtistModifer())
                }
                Spacer()
                
                Image(systemName: "line.3.horizontal").font(.system(size:  device == .phone  ? 20 : 25)).foregroundColor(Color.primary)
                
                    .padding(.trailing,10)
                
                
                
                
            }
            
            .padding(.all)
            .background(song.song_id == playState.currentSong?.song_id ? Color("SelectedSongBgColor") : .clear)
            
            
            
            
            
        }
        .contentShape(Rectangle()) //행 전체 클릭시 바로 재생되기 위해
        .onTapGesture {
            playState.currentSong = song
            playState.youTubePlayer.load(source: .url(song.url)) //강제 재생
                playState.currentPlayIndex = playState.playList.firstIndex(of: song) ?? 0
        }
        
        
    }
    
}


struct MyDropDelegate : DropDelegate {
    
    let currentItem: SimpleSong
    @Binding var currentIndex:Int
    @Binding var playList:[SimpleSong]
    @Binding var draggedItem: SimpleSong?
    
    
    /*
     
     MyDropDelegate - validateDrop() called
     MyDropDelegate - dropEntered() called
     MyDropDelegate - dropExited() called
     MyDropDelegate - validateDrop() called
     MyDropDelegate - dropEntered() called
     MyDropDelegate - performDrop() called
     
     */
    
    // 드랍에서 벗어났을 때
    func dropExited(info: DropInfo) {
        
    }
    
    //드랍 처리 (드랍을 놓을 때 작동)
    func performDrop(info: DropInfo) -> Bool {
        
        
        return true
    }
    
    // 드랍 변경
    func dropUpdated(info: DropInfo) -> DropProposal? {
        
        return nil
    }
    
    // 드랍 유효 여부
    func validateDrop(info: DropInfo) -> Bool {
        
        return true
    }
    
    //드랍 시작
    
    func dropEntered(info: DropInfo) {
        
        
        
        guard let draggedItem = self.draggedItem else {
            return
        }
        
        if draggedItem != currentItem { //현재 드래그 아이템과 현재 내 아이템과 다르면
            let from = playList.firstIndex(of: draggedItem)!
            let to = playList.firstIndex(of: currentItem)!
            
            
            withAnimation {
                //from에서 to로 이동 ,  to > from일 때는 to+1  아니면 to로
                let nowPlaySong:SimpleSong = self.playList[currentIndex] // 현재 재생중인 곳
                self.playList.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to+1 : to)
                //move 함
                self.currentIndex = playList.firstIndex(of: nowPlaySong) ?? 0
                // 옮긴 후 재생이 멈추지 않게 현재 재생중인 곳의 인덱스로 변경
            }
            
        }
        
        
    }
    
    
}


struct NowPlaySongView: View {
    let song:SimpleSong
    
    var body: some View{
        HStack
        {
            KFImage(URL(string: song.image.convertFullThumbNailImageUrl())!)
                .placeholder({
                    Image("placeHolder")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .transition(.opacity.combined(with: .scale))
                })
                .resizable()
                .frame(width:50,height: 50)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            VStack(alignment:.leading){
                Text(song.title).modifier(PlayBarTitleModifier())
                Text(song.artist).modifier(PlayBarArtistModifer())
            }
            Spacer()
            
            
            
            
        }
        
    }
}


struct TopLeftControlView: View {
    
    @Binding var playList:[SimpleSong]
    @Binding var currentIndex:Int
    @Binding var multipleSelection:Set<UUID>
    @EnvironmentObject var playState:PlayState
    let device = UIDevice.current.userInterfaceIdiom
    var modifier:FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    
    var body: some View {
        HStack{
            
            Button {
                if(multipleSelection.count == playList.count) //모두 담고있으면 제거
                {
                    multipleSelection.removeAll()
                }
                else
                {
                    for song in playList{ //모두 담기
                        multipleSelection.insert(song.id) //id 담기
                    }
                }
            } label: {
                
                
                Label {
                    Text("\(multipleSelection.count)").font(.system(size:  device == .phone  ? 20 : 25)).foregroundColor(Color.primary)
                } icon: {
                    Image(systemName: multipleSelection.count == playList.count ? "checkmark.circle.fill" : "circle").font(.system(size:  device == .phone  ? 20 : 25)).foregroundColor(Color.primary).padding(.leading,10)
                }
                
                
            }
            
         
            
            
           
        }
        
        
        
        
    }
    
}

struct TopRightControlView: View {
    
    @Binding var playList:[SimpleSong]
    @Binding var currentIndex:Int
    @Binding var multipleSelection:Set<UUID>
    @EnvironmentObject var playState:PlayState
    let device = UIDevice.current.userInterfaceIdiom
    var modifier:FullScreenButtonImageModifier = FullScreenButtonImageModifier()
    @State var isShowAlert: Bool = false
    
    var body: some View{
        
        HStack{
            Button {
                if(multipleSelection.count != 0) //선택된게 있다면
                {
                    isShowAlert = true
                }
                
                
            } label: {
                Image(systemName: "trash").font(.system(size:  device == .phone  ? 20 : 25)).foregroundColor(Color.primary).padding(.trailing,10)
            }
            .alert("삭제하시겠습니까?", isPresented: $isShowAlert) {
                
                Button(role: .cancel) {
                    
                } label: {
                    Text("아니요")
                }
                
                Button(role: .destructive) {
                    
                    if(multipleSelection.count == playList.count) //전체 제거 시
                    {
                        withAnimation(Animation.spring(response: 0.6, dampingFraction: 0.7))
                        {
                            playList.removeAll() // 리스트 제거
                            multipleSelection.removeAll() // 셋 제거
                            playState.isPlayerViewPresented = false // Fullscrren 끄고
                            playState.isPlayerListViewPresented = false //리스트창 끄고
                            playState.youTubePlayer.stop() //youtubePlayer Stop
                            playState.currentSong = nil // 현재 재생 노래 비어둠
                        }
                    }
                    
                    else //전체 제거가 아닐 때
                    {
                        withAnimation(Animation.spring(response: 0.6, dampingFraction: 0.7))
                        {
                            playList = playList.filter{!multipleSelection.contains($0.id)} // 폼함되지 않은 것만 제거
                            if(multipleSelection.contains(playState.currentSong!.id)) //현재삭제 목록에 재생중인 노래가 포함됬을 때
                            {
                                currentIndex = 0 //가장 처음 인덱스로
                                
                            }
                            else
                            {
                                let nowPlaySong:SimpleSong = playState.currentSong!
                                currentIndex = playList.firstIndex(of: nowPlaySong) ?? 0 //현재 재생중인 노래로
                                
                            }
                            multipleSelection.removeAll() // 멀티셋 비우고
                        }
                        
                    }
                } label: {
                    Text("예")
                }
                
                
                
            }
           
        }
        
    }
}




