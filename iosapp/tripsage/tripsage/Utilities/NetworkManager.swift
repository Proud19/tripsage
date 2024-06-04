//
//  NetworkManager.swift
//  tripsage
//
//  Created by Proud Mpala on 6/2/24.
//

import Foundation
import CoreLocation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func updateLocation(location: CLLocation) {
        // URL and request setup
        print("Updating location to \(location), endpoint not yet implemented")
        return
        let url = URL(string: "https://your-backend-server.com/api/location")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the location data
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": location.timestamp
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: locationData, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Failed to serialize location data: \(error.localizedDescription)")
            return
        }
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to update location: \(error.localizedDescription)")
                return
            }
            print("Location updated successfully")
        }.resume()
    }
    
    func checkForUpdates(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        print("Checking for updates, updates location not yet implemented")
        return 
        let url = URL(string: "https://your-backend-server.com/api/updates")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            do {
                let updates = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                completion(.success(updates ?? [:]))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
