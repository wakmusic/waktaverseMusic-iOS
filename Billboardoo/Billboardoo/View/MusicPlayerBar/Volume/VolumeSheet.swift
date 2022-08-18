//
//  VolumeSheet.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/05.
//

import SwiftUI
import Foundation

struct VolumeSheet: View {
    
    @EnvironmentObject var playState:PlayState
    
    var body: some View{
        
        HStack(alignment:.center){
            //speaker.wave.1
            Image(systemName: "speaker.wave.1").foregroundColor(Color.primary)
            
            Button {
                if(playState.volume > 0)
                {
                    playState.volume -= 1
                }
            } label: {
                Image(systemName: "minus")
            }
            
            Slider(value: IntDoubleBinding($playState.volume).doubleValue,in:0...100, step:5.0).onChange(of: playState.volume) { newValue in
                
                playState.youTubePlayer.set(volume: 50)
                
            }
            
            Button {
                if(playState.volume < 100)
                {
                    playState.volume += 1
                }
            } label: {
                Image(systemName: "plus")
            }
            
            
            
            
        }.frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height*0.2)
            .background(.black.opacity(0.7))
            .padding(.horizontal,20)
            .padding(.bottom, UIDevice.current.hasNotch ? 0 : 0)
        
        
        
        
        
        
    }
}



struct IntDoubleBinding {
    let intValue : Binding<Int>
    
    let doubleValue : Binding<Double>
    
    init(_ intValue : Binding<Int>) {
        self.intValue = intValue
        
        self.doubleValue = Binding<Double>(get: {
            return Double(intValue.wrappedValue)
        }, set: {
            intValue.wrappedValue = Int($0)
        })
    }
}

struct VolumeSheet_Previews: PreviewProvider {
    static var previews: some View {
        VolumeSheet().environmentObject(PlayState())
    }
}
