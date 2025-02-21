//
//  WeatherStatusIcon.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 18.02.2025.
//

import SwiftUI

struct HumidityStatusIcon: View {
    let weatherImage: String
    let weatherStatus: Int
    let weatherDescription: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: weatherImage)
                .foregroundStyle(.blue)
                .bold()
            
            Text("\(weatherStatus, specifier: "%.0f")")
                .font(.system(size: 20, weight: .bold, design: .rounded))

            
            Text(weatherDescription)
                .font(.system(size: 15, weight: .thin, design: .rounded))
                
        }
        
    }
}

#Preview {
    HumidityStatusIcon(weatherImage: "aqi.low", weatherStatus: 10, weatherDescription: "Pressure")
}
