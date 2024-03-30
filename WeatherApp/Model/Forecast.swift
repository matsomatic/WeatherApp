//
//  Forecast.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

struct Forecast: Decodable {
    
    private struct HourlyDataContainer: Decodable {
        let time: [String]
        let temperature: [Double]
        let weatherCode: [WeatherCode]
        let windSpeed: [Double]
        let windDirection: [Int]
        
        enum CodingKeys: String, CodingKey {
            case time
            case temperature = "temperature_2m"
            case weatherCode = "weather_code"
            case windSpeed = "wind_speed_10m"
            case windDirection = "wind_direction_10m"
        }
    }
    
    private struct DailyDataContainer: Decodable {
        let time: [String]
        let sunrise: [String]
        let sunset: [String]
    }
    
    let timezoneAbbreviation: String
    let hourlyUnits: Units
    let dailyData: [DailyData]
    
    enum CodingKeys: String, CodingKey {
        case timezoneAbbreviation = "timezone_abbreviation"
        case hourlyUnits = "hourly_units"
        case daily
        case hourly
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timezoneAbbreviation = try container.decode(String.self, forKey: .timezoneAbbreviation)
        self.hourlyUnits = try container.decode(Units.self, forKey: .hourlyUnits)
        
        let dailyValues = try container.decode(DailyDataContainer.self, forKey: .daily)
        let hourlyValues = try container.decode(HourlyDataContainer.self, forKey: .hourly)
        var days = [DailyData]()
        let numberOfDays = dailyValues.sunrise.count
        let dayFormat = DateFormatter()
        dayFormat.timeZone = .init(abbreviation: self.timezoneAbbreviation)
        dayFormat.dateFormat = "yyyy-MM-dd"
        
        let timeOfDayFormat = DateFormatter()
        timeOfDayFormat.timeZone = .init(abbreviation: self.timezoneAbbreviation)
        timeOfDayFormat.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        for index in 0 ..< numberOfDays {
            let dayString = dailyValues.time[index]
            let day = dayFormat.date(from: dayString) ?? .distantFuture
            let nextDay: Date
            if index < (numberOfDays - 1) {
                let nextDayString = dailyValues.time[index + 1]
                nextDay = dayFormat.date(from: nextDayString) ?? .distantFuture
            } else {
                nextDay = .distantFuture
            }
            
            var hourIndex = hourlyValues.time.firstIndex { timeOfDayString in
                let timeOfDay = timeOfDayFormat.date(from: timeOfDayString) ?? .distantFuture
                return timeOfDay == day
            } ?? .max
            var hours = [HourlyData]()
            let numberOfHours = hourlyValues.time.count
            var iterate = hourIndex < numberOfHours
            while iterate {
                let hourString = hourlyValues.time[hourIndex]
                let hour = timeOfDayFormat.date(from: hourString) ?? .distantFuture
                if hour.compare(nextDay) == .orderedAscending {
                    let temperature = hourlyValues.temperature[hourIndex]
                    let weatherCode = hourlyValues.weatherCode[hourIndex]
                    let windSpeed = hourlyValues.windSpeed[hourIndex]
                    let windDirection = hourlyValues.windDirection[hourIndex]
                    hours.append(HourlyData(time: hour, weatherCode: weatherCode, temperature: temperature, windSpeed: windSpeed, windDirection: windDirection))
                    hourIndex += 1
                    iterate = hourIndex < numberOfHours
                } else {
                    iterate = false
                }
            }
            let sunrise = timeOfDayFormat.date(from: dailyValues.sunrise[index]) ?? day
            let sunset = timeOfDayFormat.date(from: dailyValues.sunset[index]) ?? day
            days.append(DailyData(day: day, sunrise: sunrise , sunset: sunset, hourlyData: hours))
        }
        self.dailyData = days
    }
    
}
