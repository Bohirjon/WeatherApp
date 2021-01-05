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
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    
    @Published var WeatherData:WeatherData?
    
    @Published var searchText:String?
    
    @Published var weatherError:String?
    @Published var locationError:String?
    
    init(weatherService: WeatherService, locationService: LocationServiceProtocol) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.weatherService.weatherServiceDelegate = self
        self.locationService.locationServiceDelegate = self
    }
    
    func search(cityName:String)  {
        weatherService.fetchWeatherData(cityName: cityName)
    }
    func getCurrentLocation()  {
        locationService.requestForLocation()
    }
}

extension WeatherViewModel : LocationServiceDelegate {
    func onLocationMeasured(lon: CLLocationDegrees, lat: CLLocationDegrees) {
        
    }
    
    func onLocationMeasureFailed(error: Error) {
        
    }
}

extension WeatherViewModel : WeatherServiceDelegate {
    func onWeatherFetched(weatherData: WeatherData) {
        
    }
    
    func onWeatherFetchFailed(error: WeatherFetchingError) {
        
    }
}
