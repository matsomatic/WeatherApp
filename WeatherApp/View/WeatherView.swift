//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mats Trovik on 29/03/2024.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    
    let viewModel: WeatherViewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            VStack{
                TextField("Place", text: $viewModel.searchString)
                    .textFieldStyle(.roundedBorder)
                HStack{
                    Spacer()
                    Button("Search Weather", action: {
                        viewModel.performSearch()
                    })
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
            .padding()
            .background(in: RoundedRectangle(cornerSize: CGSize(width: 20,height: 20)))
            .backgroundStyle(.gray)
            getBody(viewModel: viewModel)
                .padding(.top, 20)
            Spacer()
        }
        .padding()
    }
}

@ViewBuilder
func getBody(viewModel: WeatherViewModel) -> some View {
    VStack(alignment: .center) {
        switch viewModel.state {
        case .empty:
            Text("Empty")
        case .loading:
            Spacer()
            ProgressView()
            Text("Loading")
            Spacer()
        case .available:
            Text("Data!")
        case .error:
            Text("Error")
        }
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(geoLookup: CLGeocoder()))
}
