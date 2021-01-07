//
//  ContentView.swift
//  WeatherAppSwiftUI
//
//  Created by Bohirjon Akhmedov on 04/01/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        ZStack {
            Image("background")
                    .resizable()
                    .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        viewModel.getWeatherByCurrentLocation()
                    }, label: {
                        Image(systemName: "paperplane.fill")
                                .foregroundColor(Color.init("foregroundColor"))
                    })

                    TextField("Search", text: $viewModel.searchText, onCommit: {
                        viewModel.getWeatherByCityName()
                    })
                            .multilineTextAlignment(.trailing)
                            .padding(.all, 10)
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(10.0)

                    Button(action: {
                        viewModel.getWeatherByCityName()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.init("foregroundColor"))
                    })
                }
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        Image(systemName: "cloud.rain")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.init("foregroundColor"))
                                .frame(width: 100, height: 100)
                    }
                    if viewModel.weatherData != nil {
                        Text("\(String(format: "%.1f", viewModel.weatherData!.main.temp))ºC")
                                .font(.custom("", size: 87))
                                .bold()

                        Text("\(viewModel.weatherData!.name)")
                                .font(.title)
                    }
                    Spacer()
                }
            }
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .ignoresSafeArea(.all, edges: .bottom)
        }
                .onAppear(perform: viewModel.getWeatherByCurrentLocation)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel(weatherService: WeatherService(), locationService: LocationService()))
                .preferredColorScheme(.light)
    }
}