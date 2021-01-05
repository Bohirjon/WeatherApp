//
//  ContentView.swift
//  WeatherAppSwiftUI
//
//  Created by Bohirjon Akhmedov on 04/01/21.
//

import SwiftUI

struct ContentView: View {
    @State var searchKey : String = ""
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
                    
                    TextField("Search", text: $searchKey)
                        .padding(.all, 10)
                        .background(Color.gray.opacity(0.7))
                        .cornerRadius(10.0)
                    
                    Button(action: {
                        
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
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}