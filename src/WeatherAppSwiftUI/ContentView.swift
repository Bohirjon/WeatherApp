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
                        
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(Color.init("foregroundColor"))
                    })
                    
                    TextField("Search", text: $viewModel.searchText)
                        .padding(.all, 10)
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(10.0)
                    
                    Button(action: {
                        print(viewModel.searchText)
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.init("foregroundColor"))
                    })
                }
                HStack {
                    Spacer()
                    Image(systemName: "cloud")
                }
                Spacer()
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
