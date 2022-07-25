//
//  UserDefaults+Extensions.swift
//  WeatherForecast
//
//  Created by Phil Chang on 2022/7/13.
//  Copyright © 2022 Phil. All rights reserved.
//

import Foundation

extension UserDefaults {

    static let backupForecastKey = "backupForecastKey"
    var savedForecasts: [Forecast] {
        guard let savedForecastsData = UserDefaults.standard.data(forKey: UserDefaults.backupForecastKey) else { return [] }
        guard let savedForecasts = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Forecast.self], from: savedForecastsData) as? [Forecast] else { return [] }
        return savedForecasts
    }
}
