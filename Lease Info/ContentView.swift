//
//  ContentView.swift
//  Lease Info
//
//  Created by Neema Tabarani on 12/15/23.
//
// After two years, I will update

import SwiftUI

struct ContentView: View {
    @State private var currentMileage: Double = 0.0
    @State private var selectedMileage: Double = 12000.0 // Default to 12,000
    @State private var downPayment: Double = 0.0
    @State private var isActive: Bool = false // State for loading animation

    var body: some View {
        ZStack {
            if self.isActive {
                TabView {
                    EnterMileage(currentMileage: $currentMileage, selectedMileage: $selectedMileage)
                        .tabItem {
                            Image(systemName: "plus")
                            Text("Enter Mileage")
                        }

                    LeaseInfo(currentMileage: currentMileage, selectedMileage: $selectedMileage)
                        .tabItem {
                            Image(systemName: "car")
                            Text("Lease Info")
                        }
                    LeaseCalc()
                        .tabItem {
                            Image(systemName: "dollarsign.circle")
                            Text("Lease Calculator")
                        }
                }
            } else {
                Rectangle()
                    .background(Color.black)
                Image("m-loading") // Replace with your image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 600, height: 1100)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
