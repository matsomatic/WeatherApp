//
//  DailyData.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

struct DailyData : Equatable {
    static func == (lhs: DailyData, rhs: DailyData) -> Bool {
        lhs.day == rhs.day
    }
    
    let day: Date
    let sunrise: Date
    let sunset: Date
    let hourlyData: [HourlyData]
}
