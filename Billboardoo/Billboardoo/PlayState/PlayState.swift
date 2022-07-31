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
    @Published var volum:Int
    @Published var playList:[SimpleSong]
    @Published var currentProgress: Double = 0
    @Published var isPlayerViewPresented = false //false = Bar , true = FullScreen
    @Published var youTubePlayer = YouTubePlayer(configuration: .init(autoPlay:false))
    @Published var currentSong:SimpleSong? = nil
    
    var nowPlayingSong: SimpleSong? {
        if playList.count == 0
        {
            return nil
        }
        return playList[currentPlayIndex]
    }
    
    init()
    {
        self.currentPlayIndex = 0
        self.isPlaying = .unstarted
        self.volum = 50
        self.playList = [SimpleSong]()
        //        [SimpleSong(song_id: "fgSXAKsq-Vo", title: "리와인드 (RE:WIND)", artist: "이세계아이돌", image: "https://i.imgur.com/pobpfa1.png", url: "https://youtu.be/fgSXAKsq-Vo", last: 1),SimpleSong(song_id: "DPEtmqvaKqY", title: "팬서비스", artist: "고세구", image: "https://i.ytimg.com/vi/DPEtmqvaKqY/hqdefault.jpg", url: "https://youtu.be/DPEtmqvaKqY", last: 2),SimpleSong(song_id: "JY-gJkMuJ94", title: "겨울봄", artist: "이세계아이돌", image: "https://i.imgur.com/8Y10Qq9.png", url: "https://youtu.be/JY-gJkMuJ94", last: 3),SimpleSong(song_id: "6hEvgKL0ClA", title: "Promise", artist: "릴파", image: "https://i.ytimg.com/vi/6hEvgKL0ClA/hqdefault.jpg", url: "https://youtu.be/6hEvgKL0ClA", last: 4),SimpleSong(song_id: "08meo6qrhFc", title: "왁맥송 #Shorts", artist: "우왁굳", image: "https://i.ytimg.com/vi/08meo6qrhFc/hqdefault.jpg", url: "https://youtu.be/08meo6qrhFc", last: 5),SimpleSong(song_id: "rFxJjpSeXHI", title: "SCIENTIST", artist: "주르르 (ft. 아이네)", image: "https://i.ytimg.com/vi/rFxJjpSeXHI/hqdefault.jpg", url: "https://youtu.be/rFxJjpSeXHI", last: 6),SimpleSong(song_id: "Empfi8q0aas", title: "이세돌 싸이퍼", artist: "이세계아이돌, 뢴트게늄", image: "https://i.ytimg.com/vi/Empfi8q0aas/hqdefault.jpg", url: "https://youtu.be/Empfi8q0aas", last: 7)]
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
    
    func uniqueAppend(item:SimpleSong){
        
       
        for (index,song) in playList.enumerated() { //이미 재생목록에 있으면  추가안함
            
            if(song==item)
            {
                self.currentPlayIndex = index
                return
            }
        }
        
        //없으면 추가
        self.playList.append(item)
        self.currentPlayIndex = self.playList.count - 1 //index 가장 뒤로 옮김
        
        
        
        
    }
    
    
    
    
    
}
