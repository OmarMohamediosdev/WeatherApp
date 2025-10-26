//
//  CityHistoryView.swift
//  Weather App
//
//  Created by Omar Mohamed on 26/10/2025.
//

import SwiftUI
import CoreData

struct CityHistoryView: View {
    let cityName: String
    @FetchRequest var records: FetchedResults<WeatherInfo>
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CityHistoryViewModel(service: WeatherService())
    @State private var selectedRecord: WeatherInfo?
    
    // FetchRequest with predicate
    init(cityName: String) {
        self.cityName = cityName
        _records = FetchRequest<WeatherInfo>(
            sortDescriptors: [NSSortDescriptor(keyPath: \WeatherInfo.timestamp, ascending: false)],
            predicate: NSPredicate(format: "cityName == %@", cityName)
        )
    }
    
    var body: some View {
        NavigationView {
            List {
                if records.isEmpty {
                    Text("No history found for \(cityName)")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(records) { record in
                        HStack(spacing: 12) {
                            // Load and show weather icon from OpenWeather
                            if let icon = record.iconCode {
                                if let image = viewModel.iconImages[icon] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(6)
                                } else {
                                    ProgressView()
                                        .frame(width: 40, height: 40)
                                        .onAppear {
                                            viewModel.fetchIcon(for: icon)
                                        }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text((record.condition ?? "Unknown").capitalized)
                                    .font(.headline)
                                
                                Text(String(format: "%.1f ℃", record.temperature - 273.15))
                                    .font(.subheadline)
                                
                                if let date = record.timestamp {
                                    Text(date.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        // tap opens detail sheet
                        .onTapGesture { selectedRecord = record }
                    }
                }
            }
            .navigationTitle("\(cityName) History")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            // present detail view with historical data
            .sheet(item: $selectedRecord) { record in
                let historyVM = WeatherDetailViewModel(record: record, service: WeatherService())
                WeatherDetailView(viewModel: historyVM)
            }
        }
    }
}

#Preview {
    CityHistoryView(cityName: "London")
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
