//
//  CityDetailView.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 16.02.2025.
//

import SwiftUI
import Charts

struct CityDetailView: View {
    let cityName: String
    let cityTemperature: Double
    let cityFeelsLike: Double
    let cityLowTemperature: Double
    let cityHighTemperature: Double
    let cityCurrentWeather: String
    let cityPressure: Int
    let cityHumidity: Int
    let cityLongitude: Double
    let cityLatitude: Double
    let cityTimezone: Int    // Timezone in seconds from UTC
    let weatherIcons = ["humidity", "aqi.low"]
    let cityClouds: Int
    
    var onSave: (() -> Void)?
    
    @ObservedObject private var viewModel = WeatherAPIViewModel()
    
    // A dummy state to force a view update
    @State private var currentDate = Date()
    
    // Computes the city's local time based on the timezone offset
    var isCityDay: Bool {
        let cityLocalTime = currentDate.addingTimeInterval(TimeInterval(cityTimezone))
        let hour = Calendar.current.component(.hour, from: cityLocalTime)
        // Considers day if between 6 AM and 6 PM in the city's local time
        return hour >= 6 && hour < 18
    }
    
    // Adjust text color based on whether it's day or night in the city
    private var textColor: Color {
        isCityDay ? .black : .white
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Switch background based on the city's local time
                if isCityDay {
                    DayTimeBackground()
                        .transition(.opacity)
                } else {
                    NightTimeBackground()
                        .transition(.opacity)
                }
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "location.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                            .offset(y: 8)
                        
                        Text(cityName)
                            .font(.system(size: 40, weight: .thin, design: .rounded))
                            .padding(.top)
                    }
                    
                    VStack(spacing: -10) {
                        Text("\(cityTemperature, specifier: "%.0f")°")
                            .font(.system(size: 150, weight: .bold, design: .rounded))
                        
                        Text("Feels like \(cityFeelsLike, specifier: "%.0f")°")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .frame(height: 150)
                            .opacity(0.2)
                        
                        HStack(alignment: .bottom) {
                            VStack(spacing: 10) {
                                Image(systemName: "aqi.low")
                                    .font(.system(size: 40))
                                Text("\(cityPressure) hPa")
                                    .bold()
                            }
                            .padding()
                            
                            VStack(spacing: 10) {
                                Image(systemName: "humidity")
                                    .font(.system(size: 40))
                                Text("\(cityHumidity, specifier: "%.0f")%")
                                    .bold()
                            }
                            .padding()
                            
                            VStack(spacing: 10) {
                                Image(systemName: "cloud")
                                    .font(.system(size: 40))
                                Text("\(cityClouds, specifier: "%.0f")%")
                                    .bold()

                            }
                            .padding()
                        }
                    }
                    
                    HStack {
                        Image(systemName: "arrow.down")
                            .bold()
                            .font(.system(size: 30))
                        Text("\(cityLowTemperature, specifier: "%.0f")°")
                            .font(.system(size: 30))
                        
                        Image(systemName: "arrow.up")
                            .bold()
                            .font(.system(size: 30))
                        Text("\(cityHighTemperature, specifier: "%.0f")°")
                            .font(.system(size: 30))
                    }

                    Spacer()
                }
                .padding()
                .foregroundColor(textColor)
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if let onSave = onSave {
                        Button {
                            onSave()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.white)
                        }
                        .padding()
                    }
                }
            }
        }
        // Updates currentDate every minute to trigger recomputation of isCityDay
        .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
            currentDate = Date()
        }
    }
}

#Preview {
    CityDetailView(
        cityName: "Prague",
        cityTemperature: 10,
        cityFeelsLike: 10,
        cityLowTemperature: 5,
        cityHighTemperature: 15,
        cityCurrentWeather: "sun.min",
        cityPressure: 1013,
        cityHumidity: 75,
        cityLongitude: 14.4208,
        cityLatitude: 50.0880,
        cityTimezone: 7200,
        cityClouds: 20,
        onSave: nil
    )
}
