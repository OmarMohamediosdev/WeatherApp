//
//  CityRow.swift
//  Weather App
//
//  Created by Omar Mohamed on 25/10/2025.
//

import SwiftUI

struct CityRowView: View {
    let cityWeather: CityCurrentWeather
    let onHistoryTap: () -> Void
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(cityWeather.name ?? "Unknown")
                    .font(.headline)
                if let desc = cityWeather.weather?.first?.description,
                   let kelvin = cityWeather.main?.temp {
                    HStack(spacing: 8) {
                        Text(String(format: "%.0f℃", kelvin - 273.15))
                            .font(.subheadline)
                        Text(desc.capitalized)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("No data")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Button(action: onHistoryTap) {
                Image(systemName: "info.circle")
                    .imageScale(.large)
            }
            .buttonStyle(.plain)
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
        .background(
            Color.blue.opacity(0.02)
        )
    }
}

#Preview {
    CityRowView(cityWeather: mockWeather, onHistoryTap: {}, onSelect: {})
        .padding()
}
