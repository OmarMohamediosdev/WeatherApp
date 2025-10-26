//
//  AddCityView.swift
//  Weather App
//
//  Created by Omar Mohamed on 26/10/2025.
//

import SwiftUI

struct AddCityView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cityName: String = ""
    
    // 🔥 new: loading + error states for validation
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // 🔥 callback to ViewModel
    var onAdd: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("City Name")) {
                    TextField("e.g. London", text: $cityName)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Add City")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Button("Add") {
                            validateAndAddCity()
                        }
                        .disabled(cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
    }
    
    // 🔥 new validation logic
    private func validateAndAddCity() {
        let trimmed = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        // basic validation: only letters and spaces
        guard trimmed.range(of: #"^[A-Za-z\s]+$"#, options: .regularExpression) != nil else {
            errorMessage = "Please enter a valid city name."
            return
        }
        
        // if ok, notify parent
        onAdd(trimmed)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddCityView( onAdd: {_ in} )
}
