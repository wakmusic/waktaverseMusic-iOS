
import SwiftUI

struct PlayPuaseButton: View {
    
    @EnvironmentObject var  playState:PlayState
    var buttonModifier: PlayBarButtonImageModifier = PlayBarButtonImageModifier()
    var body: some View {
        
        
        Button {
            
            if playState.isPlaying != .playing { //stop 또는 pause 상태일 때 눌리면 play
                
                playState.youTubePlayer.play()
            }
            else{
                playState.youTubePlayer.pause()
            }
            
        } label: {
            
            withAnimation(Animation.spring(response: 0.6, dampingFraction: 0.7))
            {
                Image(systemName: playState.isPlaying == .playing ? "pause.fill" : "play.fill")
                    .resizable()
                    .modifier(buttonModifier)
                
            }
            
            
        }
        
        
    }
}
