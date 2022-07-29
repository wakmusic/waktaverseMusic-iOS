
import SwiftUI

struct PlayPuaseButton: View {
    
    @EnvironmentObject var  playState:PlayState
    
    var body: some View {
        
        
        Button {
            
            if playState.isPlaying == .stop || playState.isPlaying == .pause { //stop 또는 pause 상태일 때 눌리면 play
                playState.isPlaying = .play
            }
            else{ // play 때 눌리면 pause
                playState.isPlaying = .pause
            }
            
        } label: {
            if playState.isPlaying == .stop || playState.isPlaying == .pause{ //stop or puase 일 때는 재생버튼
                
                withAnimation(Animation.spring(response: 0.6, dampingFraction: 0.7))
                {
                    Image(systemName: "play.fill")
                        .foregroundColor(Color("PrimaryColor"))
                }
            }
            else{ //재생 중일 때는 puase 버튼
                withAnimation(Animation.spring(response: 0.6, dampingFraction: 0.7))
                {
                    Image(systemName: "pause.fill")
                        .foregroundColor(Color("PrimaryColor"))
                }
                
            }
            
            
        }
        
        
    }
}
