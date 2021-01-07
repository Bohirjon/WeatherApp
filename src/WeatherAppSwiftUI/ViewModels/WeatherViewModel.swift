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

    @Published var weatherData: WeatherData?

    @Published var searchText: String = ""

    @Published var displayError: String?

    @Published var showErrorAlert: Bool = false

    init(weatherService: WeatherServiceProtocol, locationService: LocationServiceProtocol) {
        self.weatherService = weatherService
        self.locationService = locationService

        self.weatherService.weatherServiceDelegate = self
        self.locationService.locationServiceDelegate = self

        let jsonString: String = """
                                     {"coord":{"lon":2.35,"lat":48.85},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"base":"stations","main":{"temp":3.88,"feels_like":271,"temp_min":275.15,"temp_max":276.48,"pressure":1014,"humidity":81},"visibility":7000,"wind":{"speed":4.1,"deg":40},"clouds":{"all":90},"dt":1609848949,"sys":{"type":1,"id":6550,"country":"FR","sunrise":1609832603,"sunset":1609862898},"timezone":3600,"id":2988507,"name":"Paris","cod":200}
                                 """
        let data = Data(jsonString.utf8)
        let jsonDecoder = JSONDecoder()
        do {
            let weatherData = try jsonDecoder.decode(WeatherData.self, from: data)
            self.weatherData = weatherData
        } catch let error {
            print(error)
        }
    }

    func getWeatherByCityName() {
        weatherService.fetchWeatherData(cityName: searchText)
    }

    func getWeatherByCurrentLocation() {
        locationService.requestForLocation()
    }
}

extension WeatherViewModel: LocationServiceDelegate {
    func onLocationMeasured(lon: CLLocationDegrees, lat: CLLocationDegrees) {
        weatherService.fetchWeatherData(lon: lon, lat: lat)
    }

    func onLocationMeasureFailed(error: Error) {
        DispatchQueue.main.async {
            self.displayError = error.localizedDescription
            self.showErrorAlert = true
        }
    }
}

extension WeatherViewModel: WeatherServiceDelegate {
    func onWeatherFetched(weatherData: WeatherData) {
        DispatchQueue.main.async {
            self.weatherData = weatherData
        }
    }

    func onWeatherFetchFailed(error: WeatherFetchingError) {
        DispatchQueue.main.async {
            self.displayError = error.message
            self.showErrorAlert = true
        }
    }
}
