//
//  HourlyView.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import SwiftUI

struct HourlyView: View {
    
    let temperature: Double
    let temperatureUnit: String
    let weatherCode: WeatherCode
    let windDirection: Int
    let windSpeed: Double
    let windSpeedUnit: String
    let time: Date
    var timeZone: String
    let isNight: Bool
    
    let hourFormatter = { let result = DateFormatter()
        result.dateFormat = "HH:mm"
        result.timeZone = TimeZone(abbreviation: "GMT")
        return result
    }()
    
    var body: some View {
        VStack(alignment: .center) {
            Text(hourFormatter.string(from: time))
            weatherCode.image(night: isNight)
            Text(String("\(temperature)\(temperatureUnit)"))
                .font(.title)
            HStack {
                Spacer()
                Image(systemName: "wind")
                Text("↑")
                    .rotationEffect(.degrees(Double(windDirection)))
                Spacer()
            }
                
            Text(String("\(windSpeed) \(windSpeedUnit)"))
        }
        .padding()
        .background(Color.temperatureColor(temperature: temperature))
    }
}

#Preview {
    HourlyView(
               temperature:23.0,
               temperatureUnit: "°C",
               weatherCode: .partlyCloudy,
               windDirection: 45,
               windSpeed: 5.0,
               windSpeedUnit: "km/h",
               time: Date.distantPast,
               timeZone: "GMT",
               isNight: false)
}
