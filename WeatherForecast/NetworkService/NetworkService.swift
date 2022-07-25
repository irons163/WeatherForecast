//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by Phil Chang on 2022/7/12.
//  Copyright © 2022 Phil. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {

    private let baseForecastURL = "https://5c5c8ba58d018a0014aa1b24.mockapi.io/api/forecast"

    static let shared = NetworkService()
}

extension NetworkService {

    func fetchForecast(searchText: String, completionHandler: @escaping ([Forecast]) -> Void) {
        print("Fetching forecast...")

        AF.request(baseForecastURL,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("Failed with error", error)
                print("Using backup data.")
                let forecasts = UserDefaults.standard.savedForecasts
                completionHandler(forecasts)
            }

            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode([Forecast].self, from: data)
                completionHandler(searchResult)
            } catch let decodeError {
                print("Failed to decode:", decodeError)
            }
        }
    }
}
