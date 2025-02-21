import SwiftUI

struct HomePageTest: View {
    @ObservedObject var viewModel: WeatherAPIViewModel
    @State private var searchCity = ""
    @State private var selectedCity: SavedCity? = nil
    @State private var isSheetPresented: Bool = false

    var body: some View {
        VStack {
            Text("Weather")
                .font(.largeTitle.weight(.semibold))
                .padding()
            
            HStack {
                TextField("\(Image(systemName: "magnifyingglass")) Search for a city", text: $searchCity)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.search)
                    .onSubmit {
                        viewModel.fetchWeather(city: searchCity)
                        isSheetPresented = true
                    }
                
                // Tapping this button will do the same as pressing enter.
//                Button {
//                    viewModel.fetchWeather(city: searchCity)
//                    isSheetPresented = true
//                } label: {
//                    Text("Search")
//                }
//                .padding()
            }
            .padding()
            
            // (The inline weather view has been removed since the sheet now handles the display.)
            
            List {
                ForEach(viewModel.savedCities) { city in
                    Button {
                        selectedCity = city  // Opens detail sheet for a saved city.
                    } label: {
                        ListItemView(cityName: city.name,
                                     cityTemperature: city.temperature,
                                     cityLowTemperature: city.tempMin,
                                     cityHighTemperature: city.tempMax,
                                     cityCurrentWeather: city.weatherDescription)
                    }
                }
                .onDelete(perform: viewModel.deleteCity)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
        // Sheet that shows the searched city's weather and has an "Add" button.
        .sheet(isPresented: $isSheetPresented) {
            VStack {
                if let weather = viewModel.weather { 
                    Text(weather.name)
                    
                    if !viewModel.isCurrentCitySaved {
                        Button("Add") {
                            viewModel.saveCurrentCity()
                            isSheetPresented = false  // Dismiss the sheet after saving.
                        }
                        .buttonStyle(.bordered)
                        .padding()
                    } else {
                        Text("\(weather.main.temp, specifier: "%.0f")")
                    }
                    }
                    
            }
            .padding()
        }
        // Existing sheet for when a saved city is selected from the list.
        .sheet(item: $selectedCity, onDismiss: {
            selectedCity = nil
        }) { city in
                
//                CityDetailView(city: city, viewModel: viewModel)
            
        }
    }
}

#Preview {
    HomePageTest(viewModel: WeatherAPIViewModel())
}
