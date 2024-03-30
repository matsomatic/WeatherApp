//
//  DailyData.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

struct DailyData {
    let day: Date
    let sunrise: Date
    let sunset: Date
    let hourlyData: [HourlyData]
}
