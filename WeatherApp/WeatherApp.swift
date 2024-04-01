//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import CoreLocation
import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: WeatherViewModel(geoLookup: CLGeocoder(), dispatcher: URLSession.shared))
        }
    }
}
