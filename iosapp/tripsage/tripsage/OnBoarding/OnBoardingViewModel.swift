//
//  OnBoardingViewModel.swift
//  tripsage
//
//  Created by Proud Mpala on 5/13/24.
//

import Foundation
import SwiftUI
import Combine

class OnBoardingViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var navigateToNextView = false
    private var cancellables = Set<AnyCancellable>()

    public var userNeedOnBoarding: Bool {
        return true
    }
    
    func submitInterests(_ interests: [String]) {
        
        
        guard let url = URLProvider.interests else {
            print("Invalid URL")
            return
        }
        
        guard let token = KeyChainUtility.retrieveTokenFromKeychain() else
        {
            print("Could not retrieve token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = ["interests": interests]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        print("Posting interests: \(interests)")
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [String: [String]].self, decoder: JSONDecoder())
            .replaceError(with: [:])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("Done posting interests!")
                self?.isLoading = false
                self?.navigateToNextView = true
            }
            .store(in: &cancellables)
    }
}
