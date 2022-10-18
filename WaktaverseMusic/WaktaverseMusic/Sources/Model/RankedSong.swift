import Foundation

struct RankedSong: Codable, Identifiable, Equatable {
    let id = UUID()
    let song_id: String
    let title: String
    let artist: String
    // let image: String
    // let url: String
    let last: Int
    let views: Int

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.song_id == rhs.song_id
    }

    private enum CodingKeys: String, CodingKey {
        case song_id = "id"
        case title, artist, last, views
        // case viewsOfficial = "views_official"

    }
}
