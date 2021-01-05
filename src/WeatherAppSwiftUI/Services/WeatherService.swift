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

protocol WeatherServiceDelegate {
    func onWeatherFetched(weatherData: WeatherData)
    func onWeatherFetchFailed(error: WeatherFetchingError)
}

protocol WeatherServiceProtocol {
    var weatherServiceDelegate:WeatherServiceDelegate? { get set }
    
    func fetchWeatherData(cityName: String)
    func fetchWeatherData(lon: CLLocationDegrees, lat: CLLocationDegrees)
}

class WeatherService: WeatherServiceProtocol {
    var weatherServiceDelegate: WeatherServiceDelegate?
    
    func fetchWeatherData(lon: CLLocationDegrees, lat: CLLocationDegrees) {
        let stringUrl = "\(AppConstanats.WeatherApiUrl)&lon=\(lon)&lat=\(lat)"
        if let url = URL(string: stringUrl) {
            performRequest(url: url)
        } else {
            weatherServiceDelegate?.onWeatherFetchFailed(error: WeatherFetchingError(message: "Wrong url address or geo location address"))
        }
    }
    
    func fetchWeatherData(cityName: String) {
        let stringUrl  = "\(AppConstanats.WeatherApiUrl)&q=\(cityName)"
        
        if let url = URL(string: stringUrl) {
            performRequest(url: url)
        }
        else {
            weatherServiceDelegate?.onWeatherFetchFailed(error: WeatherFetchingError(message: "Wrong url address or cityName!"))
        }
    }
    
    private func performRequest(url:URL) {
        
        let urlSessionaDataTask = URLSession.shared.dataTask(with: url,completionHandler: { (data, response, error) in
            if let safeError = error {
                print(safeError)
                self.weatherServiceDelegate?.onWeatherFetchFailed(error: WeatherFetchingError(message: safeError.localizedDescription))
                return
            }
            if let safeData = data {
                let weatherData = self.parseJson(jsonData: safeData)
                if let safeWeatherData = weatherData {
                    self.weatherServiceDelegate?.onWeatherFetched(weatherData:safeWeatherData)
                } else {
                    self.weatherServiceDelegate?.onWeatherFetchFailed(error: WeatherFetchingError(message: "Could not parse recieved data!"))
                }
            } else {
                self.weatherServiceDelegate?.onWeatherFetchFailed(error: WeatherFetchingError(message: "No data recieved from server!"))
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
