//
//  ListItemView.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 17.02.2025.
//

import SwiftUI

struct ListItemView: View {
    let cityName: String
    let cityTemperature: Double
    let cityLowTemperature: Double
    let cityHighTemperature: Double
    let cityCurrentWeather: String
    let cityTimezone: Int
    
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

        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .overlay(content: {
                    if isCityDay {
                        DayTimeBackground()
                            .transition(.opacity)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } else {
                        NightTimeBackground()
                            .transition(.opacity)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                        
                })
                .frame(width: 400, height: 130)
                .padding(.horizontal, 10)
                .padding(.vertical, -5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(cityName)
                        .font(.title)
                        
                    
                    Text(cityCurrentWeather)
                        .font(.caption)
                    
                }
                .padding(.leading, 30)
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("\(cityTemperature, specifier: "%.0f")°")
                        .font(.system(size: 50, weight: .light))
                    
                    HStack {
                        Text("L: \(cityLowTemperature, specifier: "%.0f")°")
                        Text("H: \(cityHighTemperature, specifier: "%.0f")°")
                    }
                }
                .padding(.trailing, 30)
            }
        }
        .foregroundStyle(.white)
    }
}

//extension ListItemView {
//    var switchBackground
//}

#Preview {
    ListItemView(cityName: "Prague", cityTemperature: 1, cityLowTemperature: 1, cityHighTemperature: 1, cityCurrentWeather: "cloud", cityTimezone: 7600)
}
