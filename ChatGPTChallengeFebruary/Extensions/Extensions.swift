//
//  Extensions.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 15.02.2025.
//

import Foundation

// Checks if the current city is saved based on the city's name (e.g. Prague)

extension WeatherAPIViewModel {
    var isCurrentCitySaved: Bool {
        guard let weather = weather else { return false }
        return savedCities.contains(where: { $0.name == weather.name })
    }
}
