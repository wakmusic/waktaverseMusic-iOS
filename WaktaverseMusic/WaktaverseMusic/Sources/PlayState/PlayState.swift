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
    @Published var playList = PlayList()
    @Published var progress = PlayProgress()
    @Published var youTubePlayer = YouTubePlayer(configuration: .init(autoPlay: false, showControls: false, showRelatedVideos: false))
    @Published var isPlaying: YouTubePlayer.PlaybackState  = .unstarted // YouTubePlayer의 재생상태에 따라 변화
    @Published var currentSong: SimpleSong?

    var subscription = Set<AnyCancellable>()

    init() {
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
            self.progress.endProgress = time
        }.store(in: &subscription)
    }

}

// MARK: YouTubePlayer 컨트롤과 관련된 메소드들을 모아놓은 익스텐션입니다.
extension PlayState {

    func play() {
        guard let currentSong = currentSong else { return }
        self.youTubePlayer.load(source: .url(currentSong.url)) // 바로 load
    }

    func play(at item: SimpleSong?) {
        currentSong = item
        play()
    }
    
    // ⏩ 다음 곡으로 변경
    func forWard() {
        if self.playList.isLast { // 맨 뒤면
            self.playList.currentPlayIndex = 0 // 첫 번째로 이동
        } else {
            self.playList.currentPlayIndex += 1
        }
        currentSong = playList.list[playList.currentPlayIndex]
        play()
    }
    
    // ⏪ 이전 곡으로 변경
    func backWard() {
        if self.playList.currentPlayIndex ==  0 { // 첫 번째면
            self.playList.currentPlayIndex = playList.lastIndex // 맨 뒤로 위동
        } else {
            self.playList.currentPlayIndex -= 1
        }
        currentSong = playList.list[playList.currentPlayIndex]
        play()
    }

}

// MARK: 커스텀 타입들을 모아놓은 익스텐션입니다.
extension PlayState {
    public class PlayList: ObservableObject {
        @Published var list: [SimpleSong]
        @Published var currentPlayIndex: Int // 현재 재생중인 노래 인덱스 번호

        init() {
            list = [SimpleSong]()
            currentPlayIndex = 0
        }

        var first: SimpleSong? { return list.first }
        var last: SimpleSong? { return list.last }
        var count: Int { return list.count }
        var lastIndex: Int { return list.count - 1 }
        var isEmpty: Bool { return list.isEmpty }
        var isLast: Bool { return currentPlayIndex == lastIndex }

        func append(_ item: SimpleSong) {
            list.append(item)
        }

        func removeAll() {
            list.removeAll()
        }

        func contains(_ item: SimpleSong) -> Bool {
            return list.contains(item)
        }

        func uniqueAppend(item: SimpleSong) {
            let uniqueIndex = uniqueIndex(of: item)

            if let uniqueIndex = uniqueIndex {
                self.currentPlayIndex = uniqueIndex
            } else { // 재생 목록에 없으면
                list.append(item) // 재생목록에 추가
                self.currentPlayIndex = self.lastIndex // index를 가장 마지막으로 옮김
            }
        }

        private func uniqueIndex(of item: SimpleSong) -> Int? {
            // 해당 곡이 이미 재생목록에 있으면 재생목록 속 해당 곡의 index, 없으면 nil 리턴
            let index = list.enumerated().compactMap { $0.element == item ? $0.offset : nil }.first
            return index
        }

    }

    public struct PlayProgress {
        var currentProgress: Double = 0
        var endProgress: Double = 0
    }
}
