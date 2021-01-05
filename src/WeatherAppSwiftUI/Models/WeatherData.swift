//
//  WeatherData.swift
//  WeatherAppSwiftUI
//
//  Created by Bohirjon Akhmedov on 04/01/21.
//

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
}
