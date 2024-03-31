//
//  RequestDispatcher.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import Foundation

protocol RequestDispatcher {
    func dispatch(request: any Request) async -> Result<Data, Error>
}

enum RequestDispatcherError: Error {
    case malformedUrl
    case missingData
}
