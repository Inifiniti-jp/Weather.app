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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.blue)
                .frame(width: 380, height: 130)
                .padding(.horizontal, 10)
                .padding(.vertical, -5)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(cityName)
                        .foregroundStyle(.white)
                        .font(.title)
                        
                    
                    Image(systemName: cityCurrentWeather)
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                        .padding(.top, 1)
                }
                .padding(.leading, 30)
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("\(cityTemperature, specifier: "%.0f")°")
                        .foregroundStyle(.white)
                        .font(.system(size: 50, weight: .light))
                    
                    HStack {
                        Text("L: \(cityLowTemperature, specifier: "%.0f")°")
                        Text("H: \(cityHighTemperature, specifier: "%.0f")°")
                    }
                    .foregroundStyle(.white)
                }
                .padding(.trailing, 30)
            }
        }
    }
}

#Preview {
    ListItemView(cityName: "Prague", cityTemperature: 1, cityLowTemperature: 1, cityHighTemperature: 1, cityCurrentWeather: "cloud")
}
