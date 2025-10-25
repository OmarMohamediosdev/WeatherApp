//
//  ContentView.swift
//  Weather App
//
//  Created by Omar Mohamed on 25/10/2025.
//

import SwiftUI

struct CityListView: View {
    @StateObject private var viewModel = CityListViewModel(service: WeatherService())
    
    @State private var showingAddCity = false
    @State private var selectedCityForHistory: CityCurrentWeather?
    @State private var selectedCityForDetail: CityCurrentWeather?
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.cityWeathers) { cityWeather in
                            CityRowView(
                                cityWeather: cityWeather,
                                onHistoryTap: { selectedCityForHistory = cityWeather },
                                onSelect: { selectedCityForDetail = cityWeather }
                            )
                            .onTapGesture {
                                selectedCityForDetail = cityWeather
                            }
                        }
                        .onDelete(perform: viewModel.delete)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Cities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCity = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedCityForDetail) { city in
                WeatherDetailView(cityWeather: city)
            }
            .onAppear {
                viewModel.loadAllCities()
            }
            .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK")) {
                        viewModel.errorMessage = nil
                    }
                )
            }
        }
    }
}
#Preview {
    CityListView()
}
