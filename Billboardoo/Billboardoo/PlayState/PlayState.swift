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
    @Published var volume:Int = 0
    @Published var playList:[DetailSong]
    @Published var currentProgress: Double = 0
    @Published var endProgress:Double = 0
    @Published var isPlayerViewPresented = false //false = Bar , true = FullScreen
    @Published var isPlayerListViewPresented = false //false = Image  ,true = PlayList
    @Published var youTubePlayer = YouTubePlayer(configuration: .init(autoPlay:false))
    @Published var currentSong:DetailSong? = nil
    
    
    
    var nowPlayingSong: DetailSong? {
        
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
        self.playList = [DetailSong]()
        //        [DetailSong(song_id: "fgSXAKsq-Vo", title: "리와인드 (RE:WIND)", artist: "이세계아이돌", image: "https://i.imgur.com/pobpfa1.png", url: "https://youtu.be/fgSXAKsq-Vo", last: 1),DetailSong(song_id: "DPEtmqvaKqY", title: "팬서비스", artist: "고세구", image: "https://i.ytimg.com/vi/DPEtmqvaKqY/hqdefault.jpg", url: "https://youtu.be/DPEtmqvaKqY", last: 2),DetailSong(song_id: "JY-gJkMuJ94", title: "겨울봄", artist: "이세계아이돌", image: "https://i.imgur.com/8Y10Qq9.png", url: "https://youtu.be/JY-gJkMuJ94", last: 3),DetailSong(song_id: "6hEvgKL0ClA", title: "Promise", artist: "릴파", image: "https://i.ytimg.com/vi/6hEvgKL0ClA/hqdefault.jpg", url: "https://youtu.be/6hEvgKL0ClA", last: 4),DetailSong(song_id: "08meo6qrhFc", title: "왁맥송 #Shorts", artist: "우왁굳", image: "https://i.ytimg.com/vi/08meo6qrhFc/hqdefault.jpg", url: "https://youtu.be/08meo6qrhFc", last: 5),DetailSong(song_id: "rFxJjpSeXHI", title: "SCIENTIST", artist: "주르르 (ft. 아이네)", image: "https://i.ytimg.com/vi/rFxJjpSeXHI/hqdefault.jpg", url: "https://youtu.be/rFxJjpSeXHI", last: 6),DetailSong(song_id: "Empfi8q0aas", title: "이세돌 싸이퍼", artist: "이세계아이돌, 뢴트게늄", image: "https://i.ytimg.com/vi/Empfi8q0aas/hqdefault.jpg", url: "https://youtu.be/Empfi8q0aas", last: 7)]
        
        youTubePlayer.getVolume { result in
            
            do{
                try self.volume = result.get() // 초기 volumn 설정
            }
            catch{
                print(error)
            }
        }
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
    
    func isAlreadyHave(_ item:DetailSong) -> Int
    {
        
    
        for (index,song) in playList.enumerated() { //이미 재생목록에 있으면  추가안함
            
            if(song==item)
            {
                return index
            }
        }
        
        
        
        return -1
    }
    
    func uniqueAppend(item:DetailSong){
        
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
        //없으면 추가
        
    
    }
    
    func appendList(item:DetailSong) -> Bool
    {
        let isHave = isAlreadyHave(item)
        
        if(isHave == -1) //없다면
        {
            self.playList.append(item)
            print("\(self.currentPlayIndex) \(self.playList)")
            return false
        }
        print("\(self.currentPlayIndex) \(self.playList)")
        return true
        
        
        
    }
    
    
    
    
    
    
    
}
