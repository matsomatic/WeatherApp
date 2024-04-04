//
//  HourlyView.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import SwiftUI

struct HourViewConfiguration: Identifiable  {
    var id: Date { time }
    let temperature: Double
    let temperatureUnit: String
    let weatherCode: WeatherCode
    let windDirection: Int
    let windSpeed: Double
    let windSpeedUnit: String
    let time: Date
    let isNight: Bool
}

struct HourlyView: View {
    let configuration: HourViewConfiguration

    let hourFormatter = { let result = DateFormatter()
        result.dateFormat = "HH:mm"
        result.timeZone = TimeZone(abbreviation: "GMT")
        return result
    }()

    var body: some View {
        VStack(alignment: .center) {
            Text(hourFormatter.string(from: configuration.time))
            configuration.weatherCode.image(night: configuration.isNight)
            Text("TemperatureFormat\(configuration.temperature)\(configuration.temperatureUnit)")
                .font(.title)
            HStack {
                Spacer()
                Image(systemName: "wind")
                Text("↑")
                    .rotationEffect(.degrees(Double(configuration.windDirection)))
                Spacer()
            }

            Text("WindSpeedFormat\(configuration.windSpeed) \(configuration.windSpeedUnit)")
        }
        .padding()
        .background(Color.temperatureColor(temperature: configuration.temperature))
    }
}

#Preview {
    HourlyView(configuration: HourViewConfiguration (
        temperature: 23.0,
        temperatureUnit: "°C",
        weatherCode: .partlyCloudy,
        windDirection: 45,
        windSpeed: 5.0,
        windSpeedUnit: "km/h",
        time: Date.distantPast,
        isNight: false)
               )
}
