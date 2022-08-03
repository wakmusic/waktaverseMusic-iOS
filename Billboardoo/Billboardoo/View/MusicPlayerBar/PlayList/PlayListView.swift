//
//  PlayListView.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/01.
//

import SwiftUI
import UIKit

struct PlayListView: View {
    
    @State var editMode: Bool = false
    @EnvironmentObject var playState:PlayState
    @State private var multipleSelection = Set<UUID> ()
    @State var draggedItem: SimpleSong?
    
    var body: some View {
        
        if (playState.playList.count == 0)
        {
            Text("Empty")
        }
        else
        {
            ScrollView {
                LazyVStack(spacing:5){
                    if(editMode == true)
                    {
                        HStack{
                            Button {
                                print("Delete")
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                            Spacer()
                            Button {
                                withAnimation(.spring()) {
                                    editMode = false
                                }
                            } label: {
                                Text("Done")
                            }
                            
                            
                        }
                    }
                    
                    
                    ForEach(playState.playList,id: \.self.id) { song in
                        
                        HStack{
                            ItemCell(editMode: $editMode, song: song, dataList: $playState.playList)
                            
                            
                            
                            if(editMode == true)
                            {
                                Spacer()
                                Image(systemName:"arrow.up.and.down")
                            }
                        } .onDrag{
                            self.draggedItem = song
                            return NSItemProvider(item: nil, typeIdentifier: song.title)
                        }
                        
                        .onDrop(of:[song.title] , delegate: MyDropDelegate(currentItem: song, editMode: $editMode, dataList:$playState.playList, draggedItem: $draggedItem))
                        
                        
                    }
                }
            }.padding()
                
            
            
        }
        
        
    }
    
    
    
    
}

struct ItemCell: View {
    
    @Binding var editMode:Bool
    var song:SimpleSong
    @Binding var dataList:[SimpleSong]
    @State var selected:Bool = false
    @State var draggedItem: SimpleSong?
    
    var body: some View {
        HStack {
            if(editMode == true)
            {
                Button {
                    
                    withAnimation(.spring()) {
                        selected =  !selected
                    }
                } label: {
                    
                    Image(systemName: selected == true ? "checkmark.circle.fill" : "circle" )
                    
                }
                
            }
            
            HStack{
                VStack{
                    Text(song.title)
                    Text(song.artist)
                }
                
                Spacer(minLength: 0)
            } .onLongPressGesture(minimumDuration: 0.8) {
                withAnimation(.spring()) {
                    editMode = true
                }
                
            }
            
            
            
            
        }
        
    }
    
}


struct MyDropDelegate : DropDelegate {
    
    let currentItem: SimpleSong
    @Binding var editMode:Bool
    @Binding var dataList:[SimpleSong]
    @Binding var draggedItem: SimpleSong?
    
    
    
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
            let from = dataList.firstIndex(of: draggedItem)!
            let to = dataList.firstIndex(of: currentItem)!
            
            
            withAnimation {
                //from에서 to로 이동 ,  to > from일 때는 to+1  아니면 to로
                self.dataList.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to+1 : to)
            }
            
        }
        
        
    }
    
    
}
