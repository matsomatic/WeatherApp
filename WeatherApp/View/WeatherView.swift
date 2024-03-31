//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    
    let viewModel: WeatherViewModel
    @State private var scrollHour: Date?
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            VStack{
                TextField("Place", text: $viewModel.searchString)
                    .textFieldStyle(.roundedBorder)
                HStack{
                    Spacer()
                    Button("Search Weather", action: {
                        dismissKeyboard()
                        viewModel.performSearch()
                    })
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.black)
                    .tint(Color.temperatureColor(temperature: 0))
                    Spacer()
                }
            }
            .padding()
            .background(in: RoundedRectangle(cornerRadius: 20))
            .backgroundStyle(.linearGradient(colors:
                                                [Color.temperatureColor(temperature: 40),
                                                 Color.temperatureColor(temperature: 20)],
                                             startPoint: UnitPoint(x: 0, y: 1),
                                             endPoint: UnitPoint(x: 1, y: 0)))
            getDetialView()
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func getDetialView() -> some View {
        VStack(alignment: .center) {
            switch viewModel.state {
            case .empty:
                Text("Empty")
            case .loading:
                Spacer()
                ProgressView()
                Text(String("Loading"))
                Spacer()
            case .available(let forecast):
                @Bindable var viewModel = viewModel
                let dailyData = forecast.dailyData[viewModel.selectedDayIndex]
                VStack {
                    VStack{
                        Text(String("Weather Forecast\n\(viewModel.lastSearched)"))
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                        Spacer()
                        HStack {
                            VStack {
                                Image(systemName: "sunrise.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                Text(viewModel.hourStringFor(dailyData.sunrise))
                            }
                            Spacer()
                            Text (viewModel.dayStringFor(dailyData.day))
                                .font(.title)
                            Spacer()
                            VStack {
                                Image(systemName: "sunset.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                Text(viewModel.hourStringFor(dailyData.sunset))
                            }
                        }
                        Spacer()
                    }
                    .clipShape(.rect(cornerRadius: 20))
                    .frame(maxHeight: .infinity)
                    .padding()
                    .background(in: RoundedRectangle(cornerRadius: 20))
                    .backgroundStyle(.linearGradient(colors:
                                                        [Color.temperatureColor(temperature: 20),
                                                         Color.temperatureColor(temperature: 40)],
                                                     startPoint: UnitPoint(x: 0, y: 1),
                                                     endPoint: UnitPoint(x: 1, y: 0)))
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.allHours) { hour in
                                let isNight = hour.time.compare(dailyData.sunrise) == .orderedAscending || hour.time.compare(dailyData.sunset) == .orderedDescending
                                HourlyView(
                                    temperature: hour.temperature,
                                    temperatureUnit: forecast.hourlyUnits.temperature,
                                    weatherCode: hour.weatherCode,
                                    windDirection: hour.windDirection,
                                    windSpeed: hour.windSpeed,
                                    windSpeedUnit: forecast.hourlyUnits.windSpeed,
                                    time: hour.time,
                                    timeZone: forecast.timezoneAbbreviation,
                                    isNight: isNight)
                                .clipShape(.rect(cornerRadius: 20))
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $scrollHour)
                    .onChange(of: scrollHour) { oldValue, newValue in
                        viewModel.selectedHour = newValue
                    }
                }
                
            case .error:
                Text(String("Error"))
            }
        }
    }
    
    func getTimeTextFor(date: Date, forecast: Forecast) -> String {
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        hourFormatter.timeZone = TimeZone(abbreviation: forecast.timezoneAbbreviation)
        return hourFormatter.string(from: date)
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(geoLookup: MockGeocoder(), dispatcher: URLSession.shared))
}
