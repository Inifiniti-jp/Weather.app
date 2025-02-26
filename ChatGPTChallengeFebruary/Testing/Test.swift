import SwiftUI

struct HourlyForecastView: View {
    
    @ObservedObject private var viewModel = WeatherAPIViewModel()
    
    var body: some View {
        VStack {
             
            if let weather = viewModel.weather {
                Text("\(weather.timezone)")
                    .foregroundStyle(.black)
                }
            }
                    }
                }
            
            

#Preview {
    HourlyForecastView()
    }
