//
//  HomePage.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 04.02.2025.
//

import SwiftUI

struct HomePage: View {
    @ObservedObject var viewModel: WeatherAPIViewModel
    @State private var searchCity = ""
    @State private var selectedCity: SavedCity? = nil
    @State private var isSheetPresented: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack {
                Text("Weather")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding()
                
                    TextField(text: $searchCity) {
                            Text("Search for a city")
                                .foregroundStyle(.black)
                    }
                        .padding(10)
                        .foregroundStyle(.black)
                        .background(Color.white)
                        .cornerRadius(10)
                        .submitLabel(.search)
                        .padding(.horizontal)
                        .onSubmit {
                            // Ensures that the search field is not empty, and if it is, an error is thrown.
                            if searchCity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                errorMessage = "Please enter a city name."
                                showError = true
                            } else {
                                viewModel.fetchWeather(city: searchCity)
                                isSheetPresented = true
                                
                                // Clears the searchfield of all characters when the city is saved
                                searchCity = ""
                            }
                }
                
                List {
                    ForEach(viewModel.savedCities) { city in
                        Button {
                            selectedCity = city  // Opens detail sheet for a saved city.
                        } label: {
                            ListItemView(cityName: city.name,
                                         cityTemperature: city.temperature,
                                         cityLowTemperature: city.tempMin,
                                         cityHighTemperature: city.tempMax,
                                         cityCurrentWeather: city.weatherMain, cityTimezone: city.timezone)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: viewModel.deleteCity)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
            }
            // Updates all data every 120 seconds. 
            .onReceive(Timer.publish(every: 120, on: .main, in: .common).autoconnect()) { _ in
                viewModel.refreshSavedCitiesWeather()
            }
            // Sheet that shows the searched city's weather and conditionally displays an "Add" button, if the city hasn't been saved earlier.
            .sheet(isPresented: $isSheetPresented) {
                VStack {
                    if let weather = viewModel.weather {
                        
                        ZStack {
                            if !viewModel.isCurrentCitySaved {
                                CityDetailView(
                                    cityName: weather.name,
                                    cityTemperature: weather.main.temp,
                                    cityFeelsLike: weather.main.feels_like,
                                    cityLowTemperature: weather.main.temp_min,
                                    cityHighTemperature: weather.main.temp_max,
                                    cityCurrentWeather: weather.weather.first?.main ?? "Unknown",
                                    cityPressure: weather.main.pressure,
                                    cityHumidity: weather.main.humidity,
                                    cityLongitude: weather.coord.lon,
                                    cityLatitude: weather.coord.lat,
                                    cityTimezone: weather.timezone,
                                    cityClouds: weather.clouds.all,
                                    cityWind: weather.wind.speed,
                                    onSave: {
                                        viewModel.saveCurrentCity()
                                        isSheetPresented = false
                                    }
                                )
                            } else {
                                CityDetailView(
                                    cityName: weather.name,
                                    cityTemperature: weather.main.temp,
                                    cityFeelsLike: weather.main.feels_like,
                                    cityLowTemperature: weather.main.temp_min,
                                    cityHighTemperature: weather.main.temp_max,
                                    cityCurrentWeather: weather.weather.first?.main ?? "Unknown",
                                    cityPressure: weather.main.pressure,
                                    cityHumidity: weather.main.humidity,
                                    cityLongitude: weather.coord.lon,
                                    cityLatitude: weather.coord.lat,
                                    cityTimezone: weather.timezone,
                                    cityClouds: weather.clouds.all,
                                    cityWind: weather.wind.speed
                                )
                                
                            }
                        }
                    }
                }
            }
            // Existing sheet for when a saved city is selected from the list.
            .sheet(item: $selectedCity, onDismiss: {
                selectedCity = nil
            }) { city in
                CityDetailView(
                    cityName: city.name,
                    cityTemperature: city.temperature,
                    cityFeelsLike: city.feelsLike,
                    cityLowTemperature: city.tempMin,
                    cityHighTemperature: city.tempMax,
                    cityCurrentWeather: city.weatherMain,
                    cityPressure: city.pressure,
                    cityHumidity: city.humidity,
                    cityLongitude: city.longitude,
                    cityLatitude: city.latitude,
                    cityTimezone: city.timezone,
                    cityClouds: city.cloudsAll,
                    cityWind: city.windSpeed
                    
                )
            }
            // Alert to display errors when the search field is empty.
            .alert("Error", isPresented: $showError, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text(errorMessage)
            })
        }
    }
}


#Preview {
    HomePage(viewModel: WeatherAPIViewModel())
}


