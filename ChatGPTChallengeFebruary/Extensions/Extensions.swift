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

// Extension that changes a weather icon based on received string from the API

extension WeatherCondition {
    var currentWeatherIcon: String {
        switch self.main {
        case "Clear":
            return "sun.min"
        case "Clouds":
            return "cloud"
        case "Rain":
            return "cloud.rain"
        case "Drizzle":
            return "cloud.drizzle"
        case "Thunderstorm":
            return "cloud.bolt"
        case "Snow":
            return "cloud.snow"
        case "Mist":
            return "cloud.fog"
        default:
            return "Could not fetch weather!"
        }
    }
}
