//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

@Observable
class WeatherViewModel {
    
    enum WeatherState {
        case empty
        case loading
        case available(forecast: Forecast)
        case error
    }
    
    var searchString: String = ""
    private(set) var lastSearched: String = ""
    var state: WeatherState = .empty
    var selectedDayIndex = 0
    
    let geoLookup: Geocoder
    
    init(searchString: String = "", state: WeatherState = .empty, geoLookup: Geocoder) {
        self.searchString = searchString
        self.state = state
        self.geoLookup = geoLookup
    }
    
    func performSearch() {
        state = .loading
        Task {
            lastSearched = searchString
            let location = await geoLookup.findLocationForAddress(searchString)
            guard let longitude = location.longitude, let latitude = location.latitude else {
                state = .error
                return
            }
            
            //Replace with API call
            
            let dataUrl = Bundle.main.url(forResource: "DummyData", withExtension: "json")!
            let data = try Data(contentsOf: dataUrl)
            let parser = JSONDecoder()
            let forecast = try parser.decode(Forecast.self, from: data)
            state = .available(forecast: forecast)
        }
    }
}
