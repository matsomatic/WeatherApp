//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import SwiftUI
import CoreLocation

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel:WeatherViewModel(geoLookup: MockGeocoder()))
        }
    }
}
