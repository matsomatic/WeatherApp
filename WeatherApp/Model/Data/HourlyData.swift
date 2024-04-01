//
//  HourlyData.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

struct HourlyData: Identifiable {
    var id: Date { time }
    let time: Date
    let weatherCode: WeatherCode
    let temperature: Double
    let windSpeed: Double
    let windDirection: Int
}
