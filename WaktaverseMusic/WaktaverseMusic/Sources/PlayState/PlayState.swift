//
//  PlayList.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/29.
//

import Foundation
import Combine
import YouTubePlayerKit

final class PlayState: ObservableObject {

    static let shared = PlayState()

    @Published var currentPlayIndex: Int // 현재 재생중인 노래 인덱스 번호
    @Published var playList: [SimpleSong]
    @Published var currentProgress: Double = 0
    @Published var endProgress: Double = 0
    @Published var youTubePlayer = YouTubePlayer(configuration: .init(autoPlay: false, showControls: false, showRelatedVideos: false))
    @Published var isPlaying: YouTubePlayer.PlaybackState // 커스텀이 아닌 실제 State로 변경
    @Published var currentSong: SimpleSong?

    var subscription = Set<AnyCancellable>()

    func convertTimetoString(_ dtime: Double) -> String {
        let convertInt = lround(dtime)-1 >= 0 ? lround(dtime)-1 : 0
        let min: String = "\(convertInt/60)".count == 1 ? "0\(convertInt/60):" : "\(convertInt/60):"
        let sec: String = "\(convertInt%60)".count == 1 ? "0\(convertInt%60)" : "\(convertInt%60)"

        return min+sec
    }

    init() {
        self.currentPlayIndex = 0
        self.isPlaying = .unstarted
        self.playList = [SimpleSong]()

        youTubePlayer.playbackStatePublisher.sink { [weak self] state in
            guard let self = self else { return }
            if self.isPlaying != state { // 만약 현재상태와 다를 때
                self.isPlaying = state // state를 저장하고

                // 노래할당이 끝난 후
                if state == .ended { // 만약 끝났을 때 다음 곡으로 넘겨준다.
                    self.forWard()
                }
            }
        }.store(in: &subscription)

        youTubePlayer.durationPublisher.sink { [weak self] time in
            guard let self = self else { return }
            self.endProgress = time
        }.store(in: &subscription)
    }

    func forWard() {
        if self.currentPlayIndex ==  playList.count-1 {
            self.currentPlayIndex = 0
        } else {
            self.currentPlayIndex += 1
        }
        play()
    }

    func backWard() {
        if self.currentPlayIndex ==  0 {
            self.currentPlayIndex = playList.count-1
        } else {
            self.currentPlayIndex -= 1
        }
        play()
    }

    private func play() {
        guard let currentSong = currentSong else { return }
        self.youTubePlayer.load(source: .url(currentSong.url)) // 바로 load
    }

    private func uniqueIndex(of item: SimpleSong) -> Int {
        // 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 -1 리턴
        let index = playList.enumerated().compactMap { $0.element == item ? $0.offset : nil }.first ?? -1
        return index
    }

    func uniqueAppend(item: SimpleSong) {

        let uniqueIndex = uniqueIndex(of: item)
        if uniqueIndex == -1 { // 재생목록에 없으면
            self.playList.append(item) // 재생목록에 추가
            self.currentPlayIndex = self.playList.count - 1 // index를 가장 마지막으로 옮김
        } else {
            self.currentPlayIndex = uniqueIndex
        }
        currentSong = item
    }

    func appendList(item: SimpleSong) {
        if uniqueIndex(of: item) == -1 { // 재생목록에 없으면
            self.playList.append(item) // 재생목록에 추가
        }
    }

}
