//
//  HourlyData.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

struct HourlyData {
    let time: Date
    let weatherCode: WeatherCode
    let temperature: Float
    let windSpeed: Float
    let windDirection: Int
}
