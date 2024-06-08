//
//  AudioUtilities.swift
//  tripsage
//
//  Created by Proud Mpala on 6/6/24.
//

import Foundation

class AudioUtilities {
    static func saveMP3(base64String: String, filename: String) -> URL? {
        guard let data = Data(base64Encoded: base64String) else {
            print("Invalid base64 string")
            return nil
        }

        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(filename).mp3")

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Failed to save MP3 file: \(error)")
            return nil
        }
    }
}
