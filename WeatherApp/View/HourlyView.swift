//
//  HourlyView.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import SwiftUI

struct HourlyView: View {
    
    private typealias ColorValues = (red: Double, green: Double, blue: Double)
    
    
   
    let temperature: Double
    let temperatureUnit: String
    let weatherCode: WeatherCode
    let windDirection: Int
    let windSpeed: Double
    let windSpeedUnit: String
    let time: Date
    var timeZone: String {
        didSet {
            hourFormatter.timeZone = TimeZone(abbreviation: timeZone)
        }
    }
    let isNight: Bool
    
    private let cold = (red: 0.784, green: 0.831, blue: 0.969)
    private let medium = (red: 0.969, green: 0.898, blue: 0.784)
    private let hot = (red: 0.969, green: 0.667, blue: 0.667)

    private let hourFormatter = {
       let result = DateFormatter()
        result.dateFormat = "HH:mm"
        return result
    }()
    
    var body: some View {
        VStack(alignment: .center) {
            Text(hourFormatter.string(from: time))
            weatherCode.image(night: false)
            Text(String("\(temperature)\(temperatureUnit)"))
                .font(.title)
            Text("↑")
                .rotationEffect(.degrees(Double(windDirection)))
            Text(String("\(windSpeed) \(windSpeedUnit)"))
        }
        .padding()
        .background(temperatureColor())
    }
    
    func temperatureColor() -> Color {
        let start: ColorValues
        let end: ColorValues
        let progress: Double
        if temperature > 20.0 {
            start = medium
            end = hot
            progress = min(((temperature - 20.0)/20.0), 1.0)
        } else {
            start = cold
            end = medium
            progress = max((temperature/20.0), 0.0)
        }
        let red = start.red + (end.red - start.red) * progress
        let green = start.green + (end.green - start.green) * progress
        let blue = start.blue + (end.blue - start.blue) * progress
        return Color(red: red, green: green, blue: blue)
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
