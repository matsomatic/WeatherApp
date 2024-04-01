//
//  ForecastRequest.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import Foundation

class ForecastRequest: JsonRequest<Forecast> {
    override var path: String {
        "/v1/forecast"
    }

    override var params: [String: String]? {
        ["latitude": "\(latitude)",
         "longitude": "\(longitude)",
         "hourly": "temperature_2m,weather_code,wind_speed_10m,wind_direction_10m",
         "daily": "sunrise,sunset",
         "timezone": "auto"]
    }

    let latitude: Double
    let longitude: Double

    init(latitude: Double, longitude: Double, dispatcher: RequestDispatcher) {
        self.latitude = latitude
        self.longitude = longitude
        super.init(dispatcher: dispatcher)
    }
}
