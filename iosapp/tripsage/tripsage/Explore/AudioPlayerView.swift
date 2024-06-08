//
//  AudioPlayerView.swift
//  tripsage
//
//  Created by Proud Mpala on 6/6/24.
//

import SwiftUI

enum AudioPlayerState {
    case isPlaying
    case isLoading
    case normal
}

struct AudioPlayerView: View {
    let attractiionID: String
    
    @ObservedObject var viewModel: AudioPlayerViewModel
    @State var playerState: AudioPlayerState = .normal
    @State var audioFetched = false
    
    init(attractionID: String, masterPlayer: MasterPlayerState? = nil) {
        self.attractiionID = attractionID
        self.viewModel = AudioPlayerViewModel(attractionID: attractionID, masterPlayer: masterPlayer)
    }
    
    private func play() {
        if audioFetched {
            viewModel.playFromPause()
            playerState = .isPlaying
        } else {
            playerState = .isLoading
            viewModel.fetchMusicData { base64String in
                if !base64String.isEmpty {
                    if let fileURL = AudioUtilities.saveMP3(base64String: base64String, filename: "music") {
                        print("about to play the audio")
                        audioFetched = true
                        viewModel.playMP3(from: fileURL)
                        playerState = .isPlaying
                        
                    }
                }
                else {
                    print("Failed to fetch music data :( ")
                }
            }
        }
        
    }
    
    
    private func pause() {
        playerState = .normal
        viewModel.pauseMP3()
    }

    var body: some View {
        VStack {
           
            Button(action: 
                {
                    switch playerState {
                    case .isPlaying:
                        pause()
                    case .isLoading:
                        print("No action when loading")
                    case .normal:
                        play()
                    }
                }
            ) {
                switch playerState {
                case .isPlaying:
                    Image(systemName: "pause.fill")
                        .foregroundColor(.white)
                case .isLoading:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                case .normal:
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                }
                
                    
            }
        
        }
        .frame(width: 50, height: 50)
        .background(Color.orange)
        .clipShape(Circle())
    }
}

#Preview {
    AudioPlayerView(attractionID: "")
}
