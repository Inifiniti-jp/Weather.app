//
//  Model.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 04.02.2025.
//

import Foundation

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

// Rule of thumb for fetching data: keep the let names as they are described in JSON, otherwise data won't be fetched. 

struct WeatherResponse: Codable {
let coord: Coordinates
    let weather: [WeatherCondition]
    let base: String
    let main: WeatherMain
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}
struct WeatherCondition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct WeatherMain: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
struct Rain: Codable {
    let oneH: Double?
    
    private enum CodingKeys: String, CodingKey {
        case oneH = "1h"
    }
}
struct Clouds: Codable {
    let all: Int
}
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct ForecastResponse: Codable {
    let hourly: [HourlyForecast]
}

struct HourlyForecast: Codable {
    let dt: Int
    let temp: Double
    let weather: [WeatherCondition]
}





