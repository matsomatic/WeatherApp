//
//  Units.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import Foundation

struct Units: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temperature_2m"
        case windSpeed = "wind_speed_10m"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temperature = try container.decode(String.self, forKey: .temperature)
        self.windSpeed = try container.decode(String.self, forKey: .windSpeed)
    }
    
    let temperature: String
    let windSpeed: String
}
