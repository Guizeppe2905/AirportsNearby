//
//  AirportsViewModel.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 28.09.2022.
//

import Foundation
import Combine

struct AirportsViewModel {
    
    func fetchAirports() -> AnyPublisher<[AirportsModel], Error> {
        
        let reposURL = URL(string: "https://gist.githubusercontent.com/tdreyno/4278655/raw/7b0762c09b519f40397e4c3e100b097d861f5588")!
        let publisher = URLSession.shared.dataTaskPublisher(for: reposURL)
        return publisher
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: [AirportsModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
    
}
