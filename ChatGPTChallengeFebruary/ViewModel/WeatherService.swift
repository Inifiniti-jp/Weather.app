//
//  TestWeatherService.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 16.02.2025.
//

import Foundation
import Combine

private enum APIKEY {
    static let key = "82b0cfddac7a3d02d5315d5bf59bff53"
}

class WeatherService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(APIKEY.key)&units=metric") else {
            fatalError("Invalid URL!")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
        
}
