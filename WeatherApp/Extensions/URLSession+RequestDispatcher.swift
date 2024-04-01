//
//  URLDispatcher+RequestDispatcher.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import Foundation

extension URLSession: RequestDispatcher {
    func dispatch(request: Request) async -> Result<Data, Error> {
        return await withCheckedContinuation { continuation in
            guard var urlComponents = URLComponents(string: request.baseUrl.absoluteString) else {
                continuation.resume(returning: .failure(RequestDispatcherError.malformedUrl))
                return
            }
            urlComponents.path = request.path
            if let params = request.params {
                var resultParams = [URLQueryItem]()
                for paramKey in params.keys {
                    resultParams.append(URLQueryItem(name: paramKey, value: params[paramKey]))
                }
                urlComponents.queryItems = resultParams
            }
            guard let url = urlComponents.url else {
                continuation.resume(returning: .failure(RequestDispatcherError.malformedUrl))
                return
            }
            let urlRequest = URLRequest(url: url)
            let task = dataTask(with: urlRequest) { data, _, error in
                guard error == nil else {
                    continuation.resume(returning: .failure(error!))
                    return
                }
                guard let data = data else {
                    continuation.resume(returning: .failure(RequestDispatcherError.missingData))
                    return
                }
                continuation.resume(returning: .success(data))
            }
            task.resume()
        }
    }
}
