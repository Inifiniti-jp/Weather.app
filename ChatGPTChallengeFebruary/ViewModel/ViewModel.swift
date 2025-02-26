import Foundation
import Combine

class WeatherAPIViewModel: ObservableObject {
    
    private let weatherService = WeatherService()
    private var cancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var weather: WeatherResponse? // Property for current weather data

    
    @Published var savedCities: [SavedCity] = [] {
        didSet {
            saveCities()
        }
    }
    
    init() {
        loadCities()
    }
    
    func fetchWeather(city: String) {
        cancellable = weatherService.getWeather(for: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { weather in
                      self.weather = weather
                  })
    }
    
    func saveCurrentCity() {
        guard let weather = self.weather else { return }
        
        let newCity = SavedCity(
            name: weather.name,
            base: weather.base,
            temperature: weather.main.temp,
            feelsLike: weather.main.feels_like,
            tempMin: weather.main.temp_min,
            tempMax: weather.main.temp_max,
            pressure: weather.main.pressure,
            humidity: weather.main.humidity,
            seaLevel: weather.main.sea_level,
            grndLevel: weather.main.grnd_level,
            visibility: weather.visibility,
            windSpeed: weather.wind.speed,
            windDeg: weather.wind.deg,
            windGust: weather.wind.gust,
            cloudsAll: weather.clouds.all,
            dt: weather.dt,
            sys: weather.sys,
            timezone: weather.timezone,
            weatherId: weather.weather.first?.id ?? 0,
            weatherMain: weather.weather.first?.main ?? "Unknown",
            weatherDescription: weather.weather.first?.description ?? "Unknown",
            weatherIcon: weather.weather.first?.icon ?? "questionmark",
            cod: weather.cod,
            longitude: weather.coord.lon,
            latitude: weather.coord.lat
        )
        
        if !savedCities.contains(where: { $0.name == weather.name }) {
            savedCities.append(newCity)
        }
    }
    
    func deleteCity(at offsets: IndexSet) {
        savedCities.remove(atOffsets: offsets)
    }
    
    /// Refreshes the weather for each saved city with all updated parameters.
    func refreshSavedCitiesWeather() {
        for city in savedCities {
            weatherService.getWeather(for: city.name)
                .receive(on: DispatchQueue.main)
                .sink { _ in } receiveValue: { updatedWeather in
                    if let index = self.savedCities.firstIndex(where: { $0.id == city.id }) {
                        let updatedCity = SavedCity(
                            id: city.id,
                            name: updatedWeather.name,
                            base: updatedWeather.base,
                            temperature: updatedWeather.main.temp,
                            feelsLike: updatedWeather.main.feels_like,
                            tempMin: updatedWeather.main.temp_min,
                            tempMax: updatedWeather.main.temp_max,
                            pressure: updatedWeather.main.pressure,
                            humidity: updatedWeather.main.humidity,
                            seaLevel: updatedWeather.main.sea_level,
                            grndLevel: updatedWeather.main.grnd_level,
                            visibility: updatedWeather.visibility,
                            windSpeed: updatedWeather.wind.speed,
                            windDeg: updatedWeather.wind.deg,
                            windGust: updatedWeather.wind.gust,
                            cloudsAll: updatedWeather.clouds.all,
                            dt: updatedWeather.dt,
                            sys: updatedWeather.sys,
                            timezone: updatedWeather.timezone,
                            weatherId: updatedWeather.weather.first?.id ?? 0,
                            weatherMain: updatedWeather.weather.first?.main ?? "Unknown",
                            weatherDescription: updatedWeather.weather.first?.description ?? "Unknown",
                            weatherIcon: updatedWeather.weather.first?.icon ?? "questionmark",
                            cod: updatedWeather.cod,
                            longitude: updatedWeather.coord.lon,
                            latitude: updatedWeather.coord.lat
                        )
                        self.savedCities[index] = updatedCity
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    // MARK: - Persistence with UserDefaults
    
    private func saveCities() {
        if let encoded = try? JSONEncoder().encode(savedCities) {
            UserDefaults.standard.set(encoded, forKey: "savedCities")
        }
    }
    
    private func loadCities() {
        if let data = UserDefaults.standard.data(forKey: "savedCities"),
           let decodedCities = try? JSONDecoder().decode([SavedCity].self, from: data) {
            savedCities = decodedCities
        }
    }
}

// MARK: - Complete model including all parameters from API calls

struct SavedCity: Codable, Identifiable {
    let id: UUID
    let name: String
    let base: String
    let temperature: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?
    let visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let cloudsAll: Int
    let dt: Int
    let sys: Sys
    let timezone: Int
    let weatherId: Int
    let weatherMain: String
    let weatherDescription: String
    let weatherIcon: String
    let cod: Int
    let longitude: Double
    let latitude: Double

    init(
         id: UUID = UUID(),
         name: String,
         base: String,
         temperature: Double,
         feelsLike: Double,
         tempMin: Double,
         tempMax: Double,
         pressure: Int,
         humidity: Int,
         seaLevel: Int?,
         grndLevel: Int?,
         visibility: Int,
         windSpeed: Double,
         windDeg: Int,
         windGust: Double?,
         cloudsAll: Int,
         dt: Int,
         sys: Sys,
         timezone: Int,
         weatherId: Int,
         weatherMain: String,
         weatherDescription: String,
         weatherIcon: String,
         cod: Int,
         longitude: Double,
         latitude: Double
    )
    
    {
         self.id = id
         self.name = name
         self.base = base
         self.temperature = temperature
         self.feelsLike = feelsLike
         self.tempMin = tempMin
         self.tempMax = tempMax
         self.pressure = pressure
         self.humidity = humidity
         self.seaLevel = seaLevel
         self.grndLevel = grndLevel
         self.visibility = visibility
         self.windSpeed = windSpeed
         self.windDeg = windDeg
         self.windGust = windGust
         self.cloudsAll = cloudsAll
         self.dt = dt
         self.sys = sys
         self.timezone = timezone
         self.weatherId = weatherId
         self.weatherMain = weatherMain
         self.weatherDescription = weatherDescription
         self.weatherIcon = weatherIcon
         self.cod = cod
         self.longitude = longitude
         self.latitude = latitude
    }
}
