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
    
    // 🔥 FetchRequest with predicate
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
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("\(cityName) History")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    CityHistoryView(cityName: "London")
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
