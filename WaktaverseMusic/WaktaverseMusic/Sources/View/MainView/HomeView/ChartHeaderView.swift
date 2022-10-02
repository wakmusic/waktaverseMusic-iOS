import SwiftUI
import Foundation

struct ChartHeaderView: View {

    @Binding var chartIndex: Int
    @Binding var musicCart: [SimpleSong]
    @EnvironmentObject var playState: PlayState

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {
            HStack {
                switch chartIndex {
                case 0:
                    Text("빌보두 누적 Top 100").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                case 1:
                    Text("빌보두 실시간 Top 100").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                case 2:
                    Text("빌보두 일간 Top 100").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                case 3:
                    Text("빌보두 주간 Top 100").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                case 4:
                    Text("빌보두 월간 Top 100").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                default:
                    Text("빌보두 누적 Top 100").font(.custom("PretendardVariable-Regular", size: 17)).bold().foregroundColor(Color.primary)
                }
                Spacer()

                NavigationLink {
                    ChartMoreView(Bindingindex: $chartIndex, musicCart: $musicCart).environmentObject(playState)
                } label: {
                    Text("더보기").foregroundColor(.gray)
                }

            }
        }.padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}
