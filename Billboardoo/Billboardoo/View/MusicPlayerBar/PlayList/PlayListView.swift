//
//  PlayListView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/01.
//

import SwiftUI
import UIKit
import Kingfisher

struct PlayListView: View {
    
    @State var editMode: Bool = false
    @EnvironmentObject var playState:PlayState
    @State private var multipleSelection = Set<UUID>() // 다중 선택 셋
    @State var draggedItem: DetailSong? // 현재 드래그된 노래
    
    
    var body: some View {
        
        if (playState.playList.count == 0)
        {
            Text("Empty")
        }
        else
        {
            ScrollView {
                LazyVStack(spacing:5){
                    if(editMode == true) //editMode true일 때만 보여줌
                    {
                        //상위 편집 컨트롤 뷰
                        TopControlView(editMode: $editMode,playList: $playState.playList,currentIndex: $playState.currentPlayIndex,multipleSelection: $multipleSelection).environmentObject(playState)
                            .padding()
                        Spacer()
                    }
                    
                    
                    ForEach(playState.playList,id: \.self.id) { song in
                        
                        HStack{
                            ItemCell(editMode: $editMode, song: song, multipleSelection: $multipleSelection).environmentObject(playState)
                            
                            
                            
                            if(editMode == true)
                            {
                                Spacer()
                                Image(systemName:"arrow.up.and.down").foregroundColor(Color("PrimaryColor"))
                                Spacer()
                            }
                        }
                        
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(song.song_id == playState.currentSong?.song_id ? Color("PrimaryColor") : .clear,lineWidth: 2).foregroundColor(.clear)) //재생중인 리스트 항목에 stroke 설정
                        
                        
                        
                        .onDrag{
                            self.draggedItem = song //드래그 된 아이템 저장
                            return NSItemProvider(item: nil, typeIdentifier: song.title)
                        }
                        
                        .onDrop(of:[song.title] , delegate: MyDropDelegate(currentItem: song, currentIndex:$playState.currentPlayIndex, editMode: $editMode, playList:$playState.playList, draggedItem: $draggedItem))
                        
                        
                    }
                }
            }
            .frame(width:UIScreen.main.bounds.width)
            .padding(.all)
            
            
            
        }
        
        
    }
    
    
    
    
}

struct ItemCell: View {
    
    @Binding var editMode:Bool //현재 편집 상태
    var song:DetailSong // 해당 셀 노래
    @Binding var multipleSelection:Set<UUID> // 다중 선택 셋
    @State var draggedItem: DetailSong? // 드래그 된 아이템
    @EnvironmentObject var playState:PlayState
    
    
    
    var body: some View {
        HStack {
            if(editMode == true) //true일 때만 , 체크와 move 아이콘 나옴
            {
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
                        .padding(.leading)
                    
                }
                
            }
            
            HStack{
                
                KFImage(URL(string: song.image)!)
                    .resizable()
                    .frame(width:50,height: 50)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                VStack(alignment:.leading){
                    Text(song.title).modifier(PlayBarTitleModifier())
                    Text(song.artist).modifier(PlayBarArtistModifer())
                }
                Spacer(minLength: 0)
                
                
                Button {
                    withAnimation(.spring()) {
                        // 플레이리스트 재생 버튼 눌렀을 때 강제 재생
                        playState.currentSong = song
                        playState.youTubePlayer.load(source: .url(song.url)) //강제 재생
                        playState.currentPlayIndex = playState.playList.firstIndex(of: song) ?? 0
                    }
                } label: {
                    Image(systemName: "play.fill")
                        .padding(.leading)
                }.foregroundColor(Color("PrimaryColor"))
                
                
                
                
            }
            
            .padding(.all)
            .onLongPressGesture(minimumDuration: 0.8) {
                withAnimation(.spring()) {
                    editMode = true
                }
                
            }
            
            
            
            
        }
            
        
    }
    
}

struct ItemCell_Previewr: PreviewProvider {
    static var previews: some View {
        ItemCell(editMode:.constant(false),song:DetailSong(song_id: "fgSXAKsq-Vo", title: "리와인드 (RE:WIND)", artist: "이세계아이돌", image: "https://i.imgur.com/pobpfa1.png", url: "https://youtu.be/fgSXAKsq-Vo", last: 1,views: 213),multipleSelection: .constant(Set<UUID>())).environmentObject(PlayState())
    }
}


struct MyDropDelegate : DropDelegate {
    
    let currentItem: DetailSong
    @Binding var currentIndex:Int
    @Binding var editMode:Bool
    @Binding var playList:[DetailSong]
    @Binding var draggedItem: DetailSong?
    
    
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
        print("MyDropDelegate - dropExited() called")
    }
    
    //드랍 처리 (드랍을 놓을 때 작동)
    func performDrop(info: DropInfo) -> Bool {
        
        print("MyDropDelegate - performDrop() called")
        return true
    }
    
    // 드랍 변경
    func dropUpdated(info: DropInfo) -> DropProposal? {
        // print("MyDropDelegate - dropUpdated() called")
        return nil
    }
    
    // 드랍 유효 여부
    func validateDrop(info: DropInfo) -> Bool {
        print("MyDropDelegate - validateDrop() called")
        return true
    }
    
    //드랍 시작
    
    func dropEntered(info: DropInfo) {
        print("MyDropDelegate - dropEntered() called")
        
        if editMode == false {return}
        
        guard let draggedItem = self.draggedItem else {
            return
        }
        
        if draggedItem != currentItem { //현재 드래그 아이템과 현재 내 아이템과 다르면
            let from = playList.firstIndex(of: draggedItem)!
            let to = playList.firstIndex(of: currentItem)!
            
            
            withAnimation {
                //from에서 to로 이동 ,  to > from일 때는 to+1  아니면 to로
                let nowPlaySong:DetailSong = self.playList[currentIndex] // 현재 재생중인 곳
                self.playList.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to+1 : to)
                //move 함
                self.currentIndex = playList.firstIndex(of: nowPlaySong) ?? 0
                // 옮긴 후 재생이 멈추지 않게 현재 재생중인 곳의 인덱스로 변경
            }
            
        }
        
        
    }
    
    
}

struct TopControlView: View {
    
    @Binding var editMode:Bool
    @Binding var playList:[DetailSong]
    @Binding var currentIndex:Int
    @Binding var multipleSelection:Set<UUID>
    @EnvironmentObject var playState:PlayState
    @State var isShowAlert: Bool = false
    var body: some View {
        HStack(alignment:.center){
            
            VStack(alignment:.center){
                
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
                    Image(systemName: multipleSelection.count == playList.count ? "checkmark.circle.fill" : "circle")
                }
                
                
                
                Text("전체").font(.caption)
            }.padding(.vertical,3).foregroundColor(Color("PrimaryColor"))
            
            
            Text("\(multipleSelection.count)").font(.title2).foregroundColor(Color("PrimaryColor"))
            
            Spacer()
            Button {
                if(multipleSelection.count != 0) //선택된게 있다면
                {
                    isShowAlert = true
                }
                
                
            } label: {
                Image(systemName: "trash")
            }
            .alert("삭제하시겠습니까?", isPresented: $isShowAlert) {
                
                Button(role: .cancel) {
                    print("Cancel")
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
                                let nowPlaySong:DetailSong = playState.currentSong!
                                currentIndex = playList.firstIndex(of: nowPlaySong) ?? 0 //현재 재생중인 노래로
                                
                            }
                            multipleSelection.removeAll() // 멀티셋 비우고
                        }
                        
                    }
                } label: {
                    Text("에")
                }
                
                
                
            }
            Button {
                withAnimation(.spring()) {
                    editMode = false
                    multipleSelection.removeAll()// 완료 눌렀을 때 선택 셋 비우기
                }
            } label: {
                Text("완료")
            }
            
            
        }
    }
}


