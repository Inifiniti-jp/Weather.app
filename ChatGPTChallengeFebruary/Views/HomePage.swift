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
            NightTimeBackground()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Weather")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding()
                
                HStack {
                    TextField("\(Image(systemName: "magnifyingglass")) Search for a city", text: $searchCity)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit {
                            // Ensures that the search field is not empty.
                            if searchCity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                errorMessage = "Please enter a city name."
                                showError = true
                            } else {
                                viewModel.fetchWeather(city: searchCity)
                                isSheetPresented = true
                                searchCity = ""
                            }
                        }
                }
                .padding()
                
                List {
                    ForEach(viewModel.savedCities) { city in
                        Button {
                            selectedCity = city  // Opens detail sheet for a saved city.
                        } label: {
                            ListItemView(cityName: city.name,
                                         cityTemperature: city.temperature,
                                         cityLowTemperature: city.tempMin,
                                         cityHighTemperature: city.tempMax,
                                         cityCurrentWeather: city.weatherIcon)
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
            .onReceive(Timer.publish(every: 120, on: .main, in: .common).autoconnect()) { _ in
                viewModel.refreshSavedCitiesWeather()
            }
            // Sheet that shows the searched city's weather and conditionally displays an "Add" button, if the city hasn't been saved earlier.
            .sheet(isPresented: $isSheetPresented) {
                VStack {
                    if let weather = viewModel.weather, let condition = weather.weather.first {
                        ZStack {
                            if !viewModel.isCurrentCitySaved {
                                CityDetailView(
                                    cityName: weather.name,
                                    cityTemperature: weather.main.temp,
                                    cityFeelsLike: weather.main.feels_like,
                                    cityLowTemperature: weather.main.temp_min,
                                    cityHighTemperature: weather.main.temp_max,
                                    cityCurrentWeather: condition.currentWeatherIcon,
                                    cityPressure: weather.main.pressure,
                                    cityHumidity: weather.main.humidity,
                                    cityLongitude: weather.coord.lon,
                                    cityLatitude: weather.coord.lat,
                                    cityTimezone: weather.timezone,
                                    cityClouds: weather.clouds.all,
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
                                    cityCurrentWeather: condition.currentWeatherIcon,
                                    cityPressure: weather.main.pressure,
                                    cityHumidity: weather.main.humidity,
                                    cityLongitude: weather.coord.lon,
                                    cityLatitude: weather.coord.lat,
                                    cityTimezone: weather.timezone,
                                    cityClouds: weather.clouds.all
                                    
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
                    cityCurrentWeather: city.weatherIcon,
                    cityPressure: city.pressure,
                    cityHumidity: city.humidity,
                    cityLongitude: city.longitude,
                    cityLatitude: city.latitude,
                    cityTimezone: city.timezone,
                    cityClouds: city.cloudsAll
                    
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
