//
//  Color+Temperature.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import SwiftUI

extension Color {
    private typealias ColorValues = (red: Double, green: Double, blue: Double)

    private static let cold = (red: 0.784, green: 0.831, blue: 0.969)
    private static let medium = (red: 0.969, green: 0.898, blue: 0.784)
    private static let hot = (red: 0.969, green: 0.667, blue: 0.667)
    
    private static let midPointTemp = 15.0
   

    static func temperatureColor(temperature: Double) -> Color {
        let start: ColorValues
        let end: ColorValues
        let progress: Double
        if temperature > midPointTemp {
            start = Color.medium
            end = Color.hot
            progress = min((temperature - midPointTemp)/midPointTemp, 1.0)
        } else {
            start = Color.cold
            end = Color.medium
            progress = max(temperature/midPointTemp, 0.0)
        }
        let red = start.red + (end.red - start.red) * progress
        let green = start.green + (end.green - start.green) * progress
        let blue = start.blue + (end.blue - start.blue) * progress
        return Color(red: red, green: green, blue: blue)
    }
}
