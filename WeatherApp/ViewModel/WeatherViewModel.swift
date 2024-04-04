//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation
import SwiftUI

@Observable
class WeatherViewModel {
    enum WeatherViewModelError: Error {
        case geoLookupIssue
        case forecastIssue
    }
    
    enum WeatherState {
        case empty
        case loading
        case forecastAvailable
        case error(error: WeatherViewModelError)
    }
    
    var searchString: String = ""
    private(set) var lastSearched: String = ""
    var state: WeatherState = .empty
    var selectedDayIndex = 0
    
    private var forecast: Forecast?
    
    var selectedHour: Date? {
        didSet {
            if let forecast {
                if let selectedHour, let selectedDay = forecast.dailyData.last(where: { day in
                    day.day.compare(selectedHour) != .orderedDescending
                }) {
                    if let selectedIndex = forecast.dailyData.firstIndex(where: { day in
                        day == selectedDay
                    }) {
                        if selectedIndex != selectedDayIndex {
                            selectedDayIndex = selectedIndex
                        }
                    }
                }
            }
        }
    }
    
    let geoLookup: Geocoder
    let dispatcher: RequestDispatcher
    
    private let hourFormatter = { let result = DateFormatter()
        result.dateFormat = "HH:mm"
        result.timeZone = TimeZone(abbreviation: "GMT")
        return result
    }()
    
    private let dayFormatter = { let result = DateFormatter()
        result.dateFormat = "EEE dd MMM"
        result.timeZone = TimeZone(abbreviation: "GMT")
        return result
    }()
    
    init(searchString: String = "", state: WeatherState = .empty, geoLookup: Geocoder, dispatcher: RequestDispatcher) {
        self.searchString = searchString
        self.state = state
        self.geoLookup = geoLookup
        self.dispatcher = dispatcher
    }
    
    func dayConfiguration(index: Int) -> WeatherViewConfiguration? {
        if let forecast {
            let day = forecast.dailyData[index]
            return WeatherViewConfiguration(locationName: lastSearched,
                                            timeZoneAbbreviation: forecast.timezoneAbbreviation,
                                            sunriseTime: day.sunrise,
                                            sunsetTime: day.sunset,
                                            day: day.day)
        }
        return nil
    }
    
    var hourConfigurations: [HourViewConfiguration] {
        if let forecast {
            var result = [HourViewConfiguration]()
            for day in forecast.dailyData {
            
                result.append(contentsOf: day.hourlyData.map({ hour in
                    let isNight = hour.time.compare(day.sunrise) == .orderedAscending || hour.time.compare(day.sunset) == .orderedDescending
                 
                    return HourViewConfiguration(temperature: hour.temperature,
                                                 temperatureUnit: forecast.hourlyUnits.temperature,
                                                 weatherCode: hour.weatherCode,
                                                 windDirection: hour.windDirection,
                                                 windSpeed: hour.windSpeed,
                                                 windSpeedUnit: forecast.hourlyUnits.windSpeed,
                                                 time: hour.time,
                                                 isNight: isNight)
                }))
            }
            return result
        } else {
            return []
        }
    }
    
    func hourStringFor(_ date: Date) -> String {
        hourFormatter.string(from: date)
    }
    
    func dayStringFor(_ date: Date) -> String {
        dayFormatter.string(from: date)
    }
    
    func performSearch() {
        state = .loading
        Task {
            lastSearched = searchString
            let location = await geoLookup.findLocationForAddress(searchString)
            guard let longitude = location.longitude, let latitude = location.latitude else {
                state = .error(error: WeatherViewModelError.geoLookupIssue)
                return
            }
            
            let request = ForecastRequest(latitude: latitude,
                                          longitude: longitude,
                                          dispatcher: dispatcher)
            let result = await request.process()
            switch result {
            case .success(let forecast):
                self.forecast = forecast
                state = .forecastAvailable
            case .failure:
                state = .error(error: WeatherViewModelError.forecastIssue)
            }
        }
    }
}
