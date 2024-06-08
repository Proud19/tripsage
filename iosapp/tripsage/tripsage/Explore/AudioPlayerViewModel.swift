//
//  AudioPlayerViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 6/6/24.
//

import Foundation
import AVFoundation
import SwiftUI

struct AudioResponse: Codable {
    let id: String
    let attractionId: String
    let title: String
    let audioBytes: AudioBytes
}

struct AudioBytes: Codable {
    let type: String
    let data: [UInt8]
}


class AudioPlayerViewModel: ObservableObject {
    let attractionID: String
    var audioPlayer: AVAudioPlayer?
    @Published var isloading = false
    var masterPlayerState: MasterPlayerState?
    
    init(attractionID: String, audioPlayer: AVAudioPlayer? = nil, masterPlayer: MasterPlayerState? = nil) {
            self.attractionID = attractionID
            self.audioPlayer = audioPlayer
            self.masterPlayerState = masterPlayer
            setupAudioSession()
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playFromPause() {
        guard let player = audioPlayer else {
            print("Attempted to play from pause, player does not exist")
            return
        }
        pauseMasterPlayerIfNeeded()
        player.play()
    }
    
    func pauseMasterPlayerIfNeeded() {
        guard var masterplayer = masterPlayerState, let player = masterplayer.playingPlayer else {
                return
        }
        if masterplayer.isPlaying {
            player.pauseMP3()
        }
        masterplayer.playingPlayer = self
        masterplayer.isPlaying = true
    }

    func playMP3(from url: URL) {
       
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            pauseMasterPlayerIfNeeded()
            audioPlayer?.play()
            print("Playing MP3 from URL: \(url)")
        } catch {
            print("Failed to play MP3: \(error)")
        }
      
    }
    
    func pauseMP3() {
        guard let player = audioPlayer else {
            print("Attempted to pause but player does not exist")
            return
        }
        if player.isPlaying {
            player.pause()
        }
    }
    
    func fetchMusicData(completion: @escaping (String) -> Void) {
        // Assuming you have the URL for the JSON data
        guard let incompleteURL = URLProvider.podcasts else {
            print("Invalid URL")
            return
        }
        
        guard let url = URL(string: "\(incompleteURL)?attractionId=\(attractionID)") else {
            print("Could not make complete url")
            return
        }
        
        guard let token = KeyChainUtility.retrieveTokenFromKeychain() else
        {
            print("Could not retrieve token")
            return
        }
       
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("curl -X GET '\(url)'  -H 'Authorization: Bearer \(token)'")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isloading = false
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion("")
                return
            }
    
            guard let data = data else {
                print("No data received")
                completion("")
                return
            }
            
            do {
                let audioResponses = try JSONDecoder().decode([AudioResponse].self, from: data)
                if let firstAudio = audioResponses.first {
                    let audioData = Data(firstAudio.audioBytes.data)
                    let base64EncodedMP3 = audioData.base64EncodedString()
                    completion(base64EncodedMP3)
                } else {
                    print("No valid audio data found")
                    completion("")
                }
            } catch {
                print("Error parsing JSON response: \(error.localizedDescription)")
                completion("")
            }
        }
        
        task.resume()
    }
}
