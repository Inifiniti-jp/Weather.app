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
    let cityClouds: Int
    let cityWind: Double
    
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
                
                switch cityCurrentWeather.trimmingCharacters(in: .whitespacesAndNewlines) {
                case "Clouds":
                    CloudView()
                        .frame(width: UIScreen.main.bounds.width)
                case "Rain":
                    RainView()
                case "Drizzle":
                    DrizzleView()
                case "Thunderstorm":
                    ThunderStormView()
                        .frame(width: UIScreen.main.bounds.width)
                case "Snow":
                    SnowView()
                case "Mist", "Fog":
                    MistView()
                        .frame(width: UIScreen.main.bounds.width)
                default:
                    if isCityDay {
                        ClearDayView()
                            .transition(.opacity)
                    } else {
                        ClearNightView()
                            .transition(.opacity)
                    }
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
                    
                    VStack(spacing: 10) {
                        
                        Text("\(cityTemperature, specifier: "%.0f")°")
                                .font(.system(size: 150, weight: .bold, design: .rounded))
                            
                            Text("Feels like \(cityFeelsLike, specifier: "%.0f")°")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
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
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 200)
                            .opacity(0.2)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "aqi.low")
                                Text("Pressure")
                                Text("\(cityPressure) hPa")
                            }
                            
                            HStack {
                                Image(systemName: "cloud")
                                Text("Clouds")
                                Text("\(cityClouds) %")
                            }
                            
                            HStack {
                                Image(systemName: "humidity")
                                Text("Humidity")
                                Text("\(cityHumidity) %")
                            }
                            HStack {
                                Image(systemName: "wind")
                                Text("Wind Speed")
                                Text("\(cityWind, specifier: "%.0f") m/s")
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
                .foregroundColor(.white)
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
        cityCurrentWeather: "Rain",
        cityPressure: 1013,
        cityHumidity: 75,
        cityLongitude: 14.4208,
        cityLatitude: 50.0880,
        cityTimezone: 7200,
        cityClouds: 20,
        cityWind: 20,
        onSave: nil
    )
}


