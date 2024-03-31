//
//  WeatherCode+Image.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import SwiftUI

extension WeatherCode {
    func image(night: Bool) -> Image {
        if night {
            switch self {
            case .clear, .mainlyClear:
                return .init(.sunnyNight)
            case .partlyCloudy:
                return .init(.cloudyNight)
            case .overcast:
                return .init(.overcastNight)
            case .fog, .depositingRimeFog:
                return .init(.fogNight)
            case .drizzleDense,
                    .drizzleLight,
                    .drizzleModerate,
                    .drizzleFreezingDense,
                    .drizzleFreezingLight,
                    .rainSlight,
                    .rainHeavy,
                    .rainModerate,
                    .rainFreezingHeavy,
                    .rainFreezingLight:
                return .init(.rainNight)
            case .showersModerate,
                    .showersSlight,
                    .showersViolent:
                return .init(.showersNight)
            case .snowHeavy,
                    .snowGrains,
                    .snowSlight,
                    .snowModerate,
                    .snowShowersHeavy,
                    .snowShowersSlight:
                return .init(.snowNight)
            case .thunderStorm,
                    .thunderStormHeavyHail,
                    .thunderStormSlightHail:
                return .init(.thunderNight)
            }
        } else {
            switch self {
            case .clear, .mainlyClear:
                return .init(.sunny)
            case .partlyCloudy:
                return .init(.cloudy)
            case .overcast:
                return .init(.overcast)
            case .fog, .depositingRimeFog:
                return .init(.fog)
            case .drizzleDense,
                    .drizzleLight,
                    .drizzleModerate,
                    .drizzleFreezingDense,
                    .drizzleFreezingLight,
                    .rainSlight,
                    .rainHeavy,
                    .rainModerate,
                    .rainFreezingHeavy,
                    .rainFreezingLight:
                return .init(.rain)
            case .showersModerate,
                    .showersSlight,
                    .showersViolent:
                return .init(.showers)
            case .snowHeavy,
                    .snowGrains,
                    .snowSlight,
                    .snowModerate,
                    .snowShowersHeavy,
                    .snowShowersSlight:
                return .init(.snow)
            case .thunderStorm,
                    .thunderStormHeavyHail,
                    .thunderStormSlightHail:
                return .init(.thunder)
            }
        }
    }
}
