//
//  PlayList.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import Foundation
import Combine
import YouTubePlayerKit

enum PlayerState {
    case play
    case stop
    case pause
}



class PlayState:ObservableObject {

    static let shared = PlayState()
    @Published var currentPlayIndex:Int
    @Published var isPlaying:PlayerState
    @Published var volum:Int
    @Published var playList:[SimpleSong]?
    @Published var currentProgress: Float = 0
    @Published var isPlayerViewPresented = false
    @Published var youTubePlayer = YouTubePlayer(configuration: .init(autoPlay:false))
    @Published var currentSong:SimpleSong? = nil
    
    var nowPlayingSong: SimpleSong? {
        return playList?[currentPlayIndex] ?? nil
    }
    
    init()
    {
        self.currentPlayIndex = 0
        self.isPlaying = .stop
        self.volum = 50
        self.playList =
        [SimpleSong(song_id: "fgSXAKsq-Vo", title: "리와인드 (RE:WIND)", artist: "이세계아이돌", image: "https://i.imgur.com/pobpfa1.png", url: "https://youtu.be/fgSXAKsq-Vo", last: 1),SimpleSong(song_id: "DPEtmqvaKqY", title: "팬서비스", artist: "고세구", image: "https://i.ytimg.com/vi/DPEtmqvaKqY/hqdefault.jpg", url: "https://youtu.be/DPEtmqvaKqY", last: 2),SimpleSong(song_id: "JY-gJkMuJ94", title: "겨울봄", artist: "이세계아이돌", image: "https://i.imgur.com/8Y10Qq9.png", url: "https://youtu.be/JY-gJkMuJ94", last: 3),SimpleSong(song_id: "6hEvgKL0ClA", title: "Promise", artist: "릴파", image: "https://i.ytimg.com/vi/6hEvgKL0ClA/hqdefault.jpg", url: "https://youtu.be/6hEvgKL0ClA", last: 4),SimpleSong(song_id: "08meo6qrhFc", title: "왁맥송 #Shorts", artist: "우왁굳", image: "https://i.ytimg.com/vi/08meo6qrhFc/hqdefault.jpg", url: "https://youtu.be/08meo6qrhFc", last: 5),SimpleSong(song_id: "rFxJjpSeXHI", title: "SCIENTIST", artist: "주르르 (ft. 아이네)", image: "https://i.ytimg.com/vi/rFxJjpSeXHI/hqdefault.jpg", url: "https://youtu.be/rFxJjpSeXHI", last: 6),SimpleSong(song_id: "Empfi8q0aas", title: "이세돌 싸이퍼", artist: "이세계아이돌, 뢴트게늄", image: "https://i.ytimg.com/vi/Empfi8q0aas/hqdefault.jpg", url: "https://youtu.be/Empfi8q0aas", last: 7)]
    }
    
    
    
    
    
    
}
