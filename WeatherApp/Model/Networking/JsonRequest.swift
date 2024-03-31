//
//  JsonRequest.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import Foundation

class JsonRequest<T: Decodable>: Request {
    
    var baseUrl : URL {
        URL(string: "https://api.open-meteo.com")!
    }
    
    var path : String {
        assert(false, "Override in subclass")
        return ""
    }
    
    var params: [String: String]? {
        assert(false, "Override in subclass")
        return nil
    }
    
    enum JsonRequestError: Error {
        case parsingFailed(Error)
    }
    
    let dispatcher: RequestDispatcher
    
    init(dispatcher: RequestDispatcher) {
        self.dispatcher = dispatcher
    }
    
    func process() async -> Result <T, Error> {
        let dataResponse = await dispatcher.dispatch(request: self)
        switch dataResponse {
        case .success(let data):
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                return .success(object)
            } catch {
                return.failure(JsonRequestError.parsingFailed(error))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
