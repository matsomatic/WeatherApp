//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import CoreLocation
import SwiftUI

struct WeatherViewConfiguration {
    let locationName: String
    let timeZone: String
    let sunriseTime: Date
    let sunsetTime: Date
    let day: Date
}

struct WeatherView: View {
    let viewModel: WeatherViewModel
    @State private var scrollHour: Date?

    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            VStack {
                TextField("Location", text: $viewModel.searchString)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Spacer()
                    Button("Get Forecast", action: {
                        dismissKeyboard()
                        viewModel.performSearch()
                    })
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.black)
                    .tint(Color.temperatureColor(temperature: 0))
                    .disabled(viewModel.searchString.isEmpty)
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
                Spacer()
                Text("⬆\nEnter a location and tap the button to get a weather forecast.")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Spacer()
            case .loading:
                Spacer()
                ProgressView()
                Text("Loading")
                Spacer()
            case .forecastAvailable:
                @Bindable var viewModel = viewModel
                if let dailyData = viewModel.dayConfiguration(index: viewModel.selectedDayIndex) {
                    VStack {
                        let gradientPoints: [UnitPoint] = {
                            switch viewModel.selectedDayIndex % 4 {
                            case 0:
                                return [UnitPoint(x: 0, y: 1),
                                        UnitPoint(x: 1, y: 0)]
                            case 1:
                                return [UnitPoint(x: 1, y: 1),
                                        UnitPoint(x: 0, y: 0)]
                            case 2:
                                return [UnitPoint(x: 1, y: 0),
                                        UnitPoint(x: 0, y: 1)]
                            default:
                                return [UnitPoint(x: 0, y: 0),
                                        UnitPoint(x: 1, y: 1)]
                            }
                        }()
                        VStack {
                            Text("Weather Forecast\n\(dailyData.locationName)\n\(dailyData.timeZone)")
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                            Spacer()
                            HStack {
                                VStack {
                                    Image(systemName: "sunrise.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                    Text(viewModel.hourStringFor(dailyData.sunriseTime))
                                }
                                Spacer()
                                let dayDescription = viewModel.dayStringFor(dailyData.day)
                                Text(dayDescription)
                                    .font(.title)
                                Spacer()
                                VStack {
                                    Image(systemName: "sunset.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                    Text(viewModel.hourStringFor(dailyData.sunsetTime))
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
                            startPoint: gradientPoints[0],
                            endPoint: gradientPoints[1]))
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.hourConfigurations) { hour in
                                    HourlyView(configuration: hour)
                                        .clipShape(.rect(cornerRadius: 20))
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollPosition(id: $scrollHour)
                        .onChange(of: scrollHour) { _, newValue in
                            viewModel.selectedHour = newValue
                        }
                    }
                }
            case .error(let error):
                Spacer()
                if case .geoLookupIssue = error {
                    Text(String("❌\n Could not find location. Try specifying a place name and country, e.g. \"London, UK\""))
                        .font(.title)
                        .multilineTextAlignment(.center)

                } else {
                    Text(String("❌\n Could not load forecast. Try again later."))
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
                Spacer()
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

#Preview("Empty") {
    struct PreviewGeocoder: Geocoder {
        func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) {
            return (0.5, 0.5)
        }
    }
    return WeatherView(viewModel: WeatherViewModel(geoLookup: PreviewGeocoder(), dispatcher: URLSession.shared))
}

#Preview("Loading") {
    struct PreviewGeocoder: Geocoder {
        func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) {
            return (0.5, 0.5)
        }
    }
    return WeatherView(viewModel: WeatherViewModel(state: .loading, geoLookup: PreviewGeocoder(), dispatcher: URLSession.shared))
}

#Preview("Error Geocoding") {
    struct PreviewGeocoder: Geocoder {
        func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) {
            return (0.5, 0.5)
        }
    }
    return WeatherView(viewModel: WeatherViewModel(state: .error(error: .geoLookupIssue), geoLookup: PreviewGeocoder(), dispatcher: URLSession.shared))
}

#Preview("Error Forecast") {
    struct PreviewGeocoder: Geocoder {
        func findLocationForAddress(_ address: String) async -> (latitude: Double?, longitude: Double?) {
            return (0.5, 0.5)
        }
    }
    return WeatherView(viewModel: WeatherViewModel(state: .error(error: .forecastIssue), geoLookup: PreviewGeocoder(), dispatcher: URLSession.shared))
}
