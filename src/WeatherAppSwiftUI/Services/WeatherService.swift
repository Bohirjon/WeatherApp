//
//  WeatherService.swift
//  WeatherAppSwiftUI
//
//  Created by Bohirjon Akhmedov on 04/01/21.
//

import Foundation
import CoreLocation

class WeatherFetchingError: Error {
    let message: String
    init(message: String) {
        self.message = message
    }
}

protocol WeatherProtocol {
    func fetchWeatherData(cityName: String, onDataRecieved:  @escaping (WeatherData)->Void, onFailture: @escaping (Error)->Void)
    func fetchWeatherData(lon: CLLocationDegrees, lat: CLLocationDegrees, onDataRecieved:  @escaping (WeatherData)->Void, onFailture: @escaping (Error)->Void)
}

class WeatherService: WeatherProtocol {
    
    func fetchWeatherData(lon: CLLocationDegrees, lat: CLLocationDegrees, onDataRecieved: @escaping (WeatherData) -> Void, onFailture:@escaping (Error) -> Void) {
        let stringUrl = "\(AppConstanats.WeatherApiUrl)&lon=\(lon)&lat=\(lat)"
        if let url = URL(string: stringUrl) {
            performRequest(url: url, onDataRecieved: onDataRecieved, onFailture: onFailture)
        } else {
            onFailture(WeatherFetchingError(message: "Wrong url address or geo location address"))
        }
    }
    
    func fetchWeatherData(cityName: String, onDataRecieved:  @escaping (WeatherData) -> Void, onFailture: @escaping (Error) -> Void) {
        let stringUrl  = "\(AppConstanats.WeatherApiUrl)&q=\(cityName)"
        
        if let url = URL(string: stringUrl) {
            performRequest(url: url, onDataRecieved: onDataRecieved, onFailture: onFailture)
        }
        else {
            onFailture(WeatherFetchingError(message: "Wrong url address or cityName!"))
        }
    }
    
    private func performRequest(url:URL,  onDataRecieved: @escaping (WeatherData) -> Void, onFailture:@escaping (Error) -> Void) {
        
        let urlSessionaDataTask = URLSession.shared.dataTask(with: url,completionHandler: { (data, response, error) in
            if let safeError = error {
                onFailture(safeError)
                return
            }
            if let safeData = data {
                let weatherData = self.parseJson(jsonData: safeData)
                if let safeWeatherData = weatherData {
                    onDataRecieved(safeWeatherData)
                } else {
                    onFailture(WeatherFetchingError(message: "Could not parse recieved data!"))
                }
            } else {
                onFailture(WeatherFetchingError(message: "No data recieved from server!"))
            }
        })
        urlSessionaDataTask.resume()
    }
    
    private func parseJson(jsonData: Data) -> WeatherData? {
        let jsonDecoder = JSONDecoder()
        do {
            let weatherData = try jsonDecoder.decode(WeatherData.self, from: jsonData)
            return weatherData
        }
        catch let error {
            print(error)
            return nil
        }
    }
}
