//
//  WeatherViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Bohirjon Akhmedov on 05/01/21.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    private var weatherService: WeatherServiceProtocol
    private var locationService: LocationServiceProtocol
    
    @Published var WeatherData:WeatherData?
    
    @Published var searchText:String = ""
    
    @Published var weatherError:String?
    @Published var locationError:String?
    
    init(weatherService: WeatherServiceProtocol, locationService: LocationServiceProtocol) {
        self.weatherService = weatherService
        self.locationService = locationService
        
        self.weatherService.weatherServiceDelegate = self
        self.locationService.locationServiceDelegate = self
    }
    
    func search(cityName:String)  {
        weatherService.fetchWeatherData(cityName: cityName)
    }
    func getWeatherByCurrentLocation()  {
        locationService.requestForLocation()
    }
}

extension WeatherViewModel : LocationServiceDelegate {
    func onLocationMeasured(lon: CLLocationDegrees, lat: CLLocationDegrees) {
        weatherService.fetchWeatherData(lon: lon, lat: lat)
    }
    
    func onLocationMeasureFailed(error: Error) {
        DispatchQueue.main.async {
            self.locationError = error.localizedDescription
        }
    }
}

extension WeatherViewModel : WeatherServiceDelegate {
    func onWeatherFetched(weatherData: WeatherData) {
        DispatchQueue.main.async {
            self.WeatherData = weatherData
        }
    }
    
    func onWeatherFetchFailed(error: WeatherFetchingError) {
        DispatchQueue.main.async {
            self.weatherError = error.message
        }
    }
}
