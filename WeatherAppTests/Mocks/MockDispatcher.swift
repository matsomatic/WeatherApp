//
//  MockDispatcher.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 31/03/2024.
//

import Foundation
@testable import WeatherApp

class MockDispatcher: RequestDispatcher {
    enum MockDispatcherError: Error {
        case unintitalisedMock
    }
    
    var result: Result<Data, Error> = .failure(MockDispatcherError.unintitalisedMock)
    var dispatchedRequest: Request?
    func dispatch(request: Request) async -> Result<Data, Error> {
        dispatchedRequest = request
        return result
    }
}
