//
//  ExploreViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 6/4/24.
//

import SwiftUI
import Combine

struct Landmark: Identifiable, Decodable, Hashable {
    let id: String
    let name: String
    let description: String
    let photoUrls: [String]
    let address: String
}

class ExploreViewModel: ObservableObject {
    @Published var landmarks: [Landmark] = []
    private var cancellables = Set<AnyCancellable>()
    
    
    
    init() {
        guard let location = LocationManager.shared.location else {
            print("Could not get user location for exploreview")
            return
        }
        print("Fetching landmarks from \(location.coordinate)")
        fetchLandmarks(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }

    func fetchLandmarks(latitude: Double, longitude: Double) {
        guard let baseUrl =  URLProvider.nearby,
            let url = URL(string: "\(baseUrl)?latitude=\(latitude)&longitude=\(longitude)")  else {
            print("Invalid URL")
            return
        }
        
        guard let token = KeyChainUtility.retrieveTokenFromKeychain() else
        {
            print("Could not retrieve token")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        print("Fetching landmarks from url \(url) and token \(token)")
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [Landmark].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] landmarks in
                self?.landmarks = landmarks
            }
            .store(in: &cancellables)
    }
}

