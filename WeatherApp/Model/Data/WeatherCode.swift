//
//  WeatherCode.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

enum WeatherCode: Int, Decodable, CaseIterable {
    case clear = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case depositingRimeFog = 48
    case drizzleLight = 51
    case drizzleModerate = 53
    case drizzleDense = 55
    case drizzleFreezingLight = 56
    case drizzleFreezingDense = 57
    case rainSlight = 61
    case rainModerate = 63
    case rainHeavy = 65
    case rainFreezingLight = 66
    case rainFreezingHeavy = 67
    case snowSlight = 71
    case snowModerate = 73
    case snowHeavy = 75
    case snowGrains = 77
    case showersSlight = 80
    case showersModerate = 81
    case showersViolent = 82
    case snowShowersSlight = 85
    case snowShowersHeavy = 86
    case thunderStorm = 95
    case thunderStormSlightHail = 96
    case thunderStormHeavyHail = 99
}
