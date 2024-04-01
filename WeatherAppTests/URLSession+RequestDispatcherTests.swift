//
//  URLSession+RequestDispatcherTests.swift
//  WeatherAppTests
//
//  Created by Mats Trovik on 01/04/2024.
//

@testable import WeatherApp
import XCTest

class BrokenRequest: JsonRequest<String> {
    override var path: String {
        "😀"
    }

    override var params: [String: String]? {
        ["😀": "😀"]
    }
}

final class URLSession_RequestDispatcherTests: XCTestCase {
    func testMalformedURL() async {
        let sut = URLSession.shared
        let brokenRequest = BrokenRequest(dispatcher: sut)
        let result = await brokenRequest.process()
        if case .failure(let error) = result {
            if let dispatcherError = error as? RequestDispatcherError {
                XCTAssert(dispatcherError == .malformedUrl)
            } else {
                XCTAssert(false, "Unexpected Error")
            }
        } else {
            XCTAssert(false, "Unexpected Success")
        }
    }
}
