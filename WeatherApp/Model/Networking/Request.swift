//
//  BaseRequest.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import Foundation

protocol Request {
    var baseUrl: URL { get }
    var path: String { get }
    var params: [String: String]? { get }
}
