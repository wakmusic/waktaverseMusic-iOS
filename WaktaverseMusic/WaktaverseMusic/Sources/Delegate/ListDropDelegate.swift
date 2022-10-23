//
//  ListDropDelegate.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2022/10/13.
//

import SwiftUI

struct ListDropDelegate: DropDelegate {
    let currentItem: SimpleSong
    @Binding var currentIndex: Int
    @Binding var playList: [SimpleSong]
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

    // 드랍 처리 (드랍을 놓을 때 작동)
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

    // 드랍 시작

    func dropEntered(info: DropInfo) {

        guard let draggedItem = self.draggedItem else {
            return
        }

        if draggedItem != currentItem { // 현재 드래그 아이템과 현재 내 아이템과 다르면
            let from = playList.firstIndex(of: draggedItem)!
            let to = playList.firstIndex(of: currentItem)!

            withAnimation {
                // from에서 to로 이동 ,  to > from일 때는 to+1  아니면 to로
                let nowPlaySong: SimpleSong = self.playList[currentIndex] // 현재 재생중인 곳
                self.playList.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to+1 : to)
                // move 함
                self.currentIndex = playList.firstIndex(of: nowPlaySong) ?? 0
                // 옮긴 후 재생이 멈추지 않게 현재 재생중인 곳의 인덱스로 변경
            }

        }

    }

}
