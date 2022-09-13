//
//  PlayList.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import Foundation
import Combine
import YouTubePlayerKit





class PlayState:ObservableObject {
    
    static let shared = PlayState()
    
    @Published var currentPlayIndex:Int
    @Published var isPlaying:YouTubePlayer.PlaybackState // 커스텀이 아닌 실제 State로 변경
    @Published var playList:[SimpleSong]
    @Published var currentProgress: Double = 0
    @Published var endProgress:Double = 0
    @Published var isPlayerViewPresented = false //false = Bar , true = FullScreen
    @Published var isPlayerListViewPresented = false //false = Image  ,true = PlayList
    @Published var youTubePlayer = YouTubePlayer(configuration: .init(autoPlay:false,showControls: false,showRelatedVideos: false))
    @Published var currentSong:SimpleSong? = nil
    
    
    
    var nowPlayingSong: SimpleSong? {
        
        get {
            if playList.count == 0
            {
                return nil
            }
            return playList[currentPlayIndex]
        }
        
    }
    
    func convertTimetoString(_ dtime:Double) ->String{
        
        let convertInt = lround(dtime)-1 >= 0 ? lround(dtime)-1 : 0
        
        let min:String = "\(convertInt/60)".count == 1 ? "0\(convertInt/60):" : "\(convertInt/60):"
        
        let sec:String = "\(convertInt%60)".count == 1 ? "0\(convertInt%60)" : "\(convertInt%60)"
        
        return min+sec
        
        
    }
    
    
    
    init()
    {
        self.currentPlayIndex = 0
        self.isPlaying = .unstarted
        self.playList = [SimpleSong]()
        
    }
    
    func forWard(){
        
        
        
        
        if(self.currentPlayIndex ==  playList.count-1)
        {
            self.currentPlayIndex = 0
        }
        else
        {
            self.currentPlayIndex += 1
        }
        
        
        
        
        
    }
    
    func backWard(){
        
        
        
        if(self.currentPlayIndex ==  0)
        {
            self.currentPlayIndex = playList.count-1
        }
        else
        {
            self.currentPlayIndex -= 1
        }
        
        
        
    }
    
    func isAlreadyHave(_ item:SimpleSong) -> Int
    {
        
    
        for (index,song) in playList.enumerated() { //이미 재생목록에 있으면  추가안함
            
            if(song==item)
            {
                return index
            }
        }
        
        
        
        return -1
    }
    
    func uniqueAppend(item:SimpleSong){
        
        let isHave = isAlreadyHave(item)
        if(isHave == -1)
        {
            self.playList.append(item)
            self.currentPlayIndex = self.playList.count - 1 //index 가장 뒤로 옮김
        }
        else
        {
            self.currentPlayIndex = isHave
        }
        currentSong = item
    
        
        //없으면 추가
        
    
    }
    
    func appendList(item:SimpleSong)
    {
        let isHave = isAlreadyHave(item)
        
        if(isHave == -1) //없다면
        {
            self.playList.append(item)
        }
    
   
        
    }
    
    
    
    
    
    
    
}
