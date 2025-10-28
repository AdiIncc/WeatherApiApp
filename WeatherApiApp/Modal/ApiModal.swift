//
//  ApiModal.swift
//  WeatherApiApp
//
//  Created by Adrian Inculet on 24.10.2025.
//

import Foundation

struct WeatherResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current: CurrentWeatherData
}

struct CurrentWeatherData: Decodable {
    let time: String
    let temperature2m: Double
    let windSpeed10m: Double
    
    private enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case windSpeed10m = "wind_speed_10m"
    }
}
