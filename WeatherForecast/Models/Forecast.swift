//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Phil Chang on 2022/7/12.
//  Copyright © 2022 Phil. All rights reserved.
//

import Foundation

final class Forecast: NSObject, Decodable, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true


    /*
     {"day":"1","description":"Sunny","sunrise":27420,"sunset":63600,"chance_rain":0.1,"high":15,"low":6,"image":"https://picsum.photos/640/480"}
     */

    var day: String?
    var descriptionStr: String?
    var sunrise: Int?
    var sunset: Int?
    var chance_rain: Double?
    var high: Int?
    var low: Int?
    var image: String?
    var image_downloaded: Bool?

    private enum CodingKeys : String, CodingKey {
        case descriptionStr = "description"
        case day
        case sunrise
        case sunset
        case chance_rain
        case high
        case low
        case image
        case image_downloaded
    }

    func encode(with aCoder: NSCoder) {
        print("Trying to transform Forecast into Data")
        aCoder.encode(self.day ?? "", forKey: "day")
        aCoder.encode(self.descriptionStr ?? "", forKey: "descriptionStr")
        aCoder.encode(self.sunrise ?? 0, forKey: "sunrise")
        aCoder.encode(self.sunset ?? 0, forKey: "sunset")
        aCoder.encode(self.chance_rain ?? 0, forKey: "chance_rain")
        aCoder.encode(self.high ?? 0, forKey: "high")
        aCoder.encode(self.low ?? 0, forKey: "low")
        aCoder.encode(self.image ?? "", forKey: "image")
    }

    init?(coder aDecoder: NSCoder) {
        print("Trying to turn Data into Forecast")
        self.day = aDecoder.decodeObject(forKey: "day") as? String
        self.descriptionStr = aDecoder.decodeObject(forKey: "descriptionStr") as? String
        self.sunrise = aDecoder.decodeInteger(forKey: "sunrise")
        self.sunset = aDecoder.decodeInteger(forKey: "sunset")
        self.chance_rain = aDecoder.decodeObject(forKey: "chance_rain") as? Double
        self.high = aDecoder.decodeInteger(forKey: "high")
        self.low = aDecoder.decodeInteger(forKey: "low")
        self.image = aDecoder.decodeObject(forKey: "image") as? String
    }
}
