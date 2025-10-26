//
//  ContentView.swift
//  Weather App
//
//  Created by Omar Mohamed on 25/10/2025.
//

import SwiftUI
import CoreData

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
            
            // add city sheet
            .sheet(isPresented: $showingAddCity) {
                AddCityView { newCityName in
                    viewModel.addCity(named: newCityName)
                }
            }
            // details sheet
            .sheet(item: $selectedCityForDetail) { city in
                WeatherDetailView(cityWeather: city)
            }
            // show city history sheet
            .sheet(item: $selectedCityForHistory) { city in
                CityHistoryView(cityName: city.name ?? "Unknown")
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
            // loading the data
            .onAppear {
                viewModel.loadAllCities()
            }
            // alert
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
