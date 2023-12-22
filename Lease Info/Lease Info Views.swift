//
//  Lease Info.swift
//  Lease Info Check
//
//  Created by Neema Tabarani on 12/15/23.
//

import SwiftUI
import Foundation

struct EnterMileage: View {
    @Binding var currentMileage: Double // Binding to hold the current mileage
    @Binding var selectedMileage: Double // Binding to hold the selected mileage
    @State private var mileageInput: String = "" // String to hold text input
    @State private var showAlert = false // State to control alert visibility
    
    var body: some View {
        VStack {
            Text("Welcome to the Lease Manager App!")
                .font(.title)
                .padding(.bottom, 20)
                .multilineTextAlignment(.center)
            
            Spacer() // Spacer to push the text field to the center
            TextField("Enter Current Mileage", text: $mileageInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(width: 200)
                .padding()
                .multilineTextAlignment(.center) // Center the text field content
            
            Button(action: {
                if let newMileage = Double(mileageInput) {
                    currentMileage = newMileage
                    showAlert = true
                    mileageInput = ""
                }
            }) {
                Text("Save")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Mileage Saved"),
                    message: Text("The mileage has been updated."),
                    dismissButton: .default(Text("OK"))
                )
            }
            Spacer()
            Text("Select Your Annual Mileage Limit")
            HStack {
                MileageButton(value: 10000, selectedMileage: $selectedMileage)
                MileageButton(value: 12000, selectedMileage: $selectedMileage)
                MileageButton(value: 15000, selectedMileage: $selectedMileage)
            }
            Spacer() // Spacer to push the button to the bottom
        }

        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand the VStack to fill the screen
    }
}

struct MileageButton: View {
    let value: Double
    @Binding var selectedMileage: Double

    var body: some View {
        Button(action: {
            selectedMileage = value
        }) {
            Text("\(Int(value / 1000))k")
                .padding()
                .foregroundColor(.white)
                .background(selectedMileage == value ? Color.blue : Color.gray)
                .cornerRadius(8)
                .clipShape(Circle())
        }
    }
}


struct LeaseInfo: View {
    let currentMileage: Double
    @Binding var selectedMileage: Double // Binding to hold the selected mileage
    let endDate = Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 25))!
    let startDate = Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 25))!
    let currentDate = Date()

    var daysLeftInLease: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
        return components.day ?? 0
    }

    var averageMileagePerDay: Double {
        let days = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day ?? 0
        return currentMileage / Double(abs(days))
    }

    var recommendedMileage: Double {
        let days = Calendar.current.dateComponents([.day], from: startDate, to: currentDate).day ?? 0
        return (selectedMileage / 365.0) * Double(abs(days))
    }

    var amountOwedIfMileageNotReduced: Double {
        let excessMileage = currentMileage - recommendedMileage
        return excessMileage > 0 ? 0.25 * excessMileage : 0
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Lease Information")
                .font(.title)
                .bold()
            Text("\(dateFormatter.string(from: currentDate))")
                .multilineTextAlignment(.center)

            Spacer() // Pushes content below the title towards the center

            InfoRow(label: "Days left in Lease:", value: "\(daysLeftInLease)")
            if currentMileage != 0{
                InfoRow(label: "Current Mileage:", value: String(format: "%.2f", currentMileage))
            InfoRow(label: "Recommended Mileage:", value: String(format: "%.2f", recommendedMileage))
            if currentMileage >= recommendedMileage {
                InfoRow(label: "Amount Owed if Mileage Not Reduced:", value: String(format: "$%.2f", amountOwedIfMileageNotReduced))
            }
            if recommendedMileage > currentMileage {
                InfoRow(label: "You are under", value: "\(String(format: "%.2f", recommendedMileage - currentMileage)) miles")
            } else if currentMileage > recommendedMileage {
                InfoRow(label: "You are over", value: "\(String(format: "%.2f", currentMileage - recommendedMileage)) miles")
            } else {
                Text("You are where you should be.")
            }
                InfoRow(label: "Your Daily Average Mileage:", value: String(format: "%.2f", averageMileagePerDay))
            }
            else
            {Text("Enter Your Current Mileage!")}
            Spacer()
        }
        .padding()
    }


    // Custom view for a row in the information display
    struct InfoRow: View {
        var label: String
        var value: String
        
        var body: some View {
            VStack(alignment: .center, spacing: 4) {
                Text(label)
                    .foregroundColor(.secondary)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text(value)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct LeaseCalc: View {
    @State private var downPayment1: String = ""
    @State private var monthlyPayment1: String = ""
    @State private var downPayment2: String = ""
    @State private var monthlyPayment2: String = ""

    var totalAmountPaid1: Double {
        let downPaymentValue = Double(downPayment1) ?? 0
        let monthlyPaymentValue = Double(monthlyPayment1) ?? 0
        return downPaymentValue + (monthlyPaymentValue * 36)
    }

    var totalAmountPaid2: Double {
        let downPaymentValue = Double(downPayment2) ?? 0
        let monthlyPaymentValue = Double(monthlyPayment2) ?? 0
        return downPaymentValue + (monthlyPaymentValue * 36)
    }

    var savingDifference: Double {
        return abs(totalAmountPaid1 - totalAmountPaid2)
    }

    var savingText: String {
        let lowerValue = totalAmountPaid1 < totalAmountPaid2 ? "1st set" : "2nd set"
        return "You are saving $\(String(format: "%.2f", savingDifference)) more with the \(lowerValue)!"
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Lease Calculator")
                .font(.title)
                .bold()

            HStack {
                VStack {
                    Text("Offer 1")
                    TextField("Enter Down Payment", text: $downPayment1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding()
                    TextField("Enter Monthly Payment", text: $monthlyPayment1)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding()
                    Text("Total Amount Paid: $\(String(format: "%.2f", totalAmountPaid1))")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()

                Spacer()
                Divider()
                VStack {
                    Text("Offer 2")
                    TextField("Enter Down Payment", text: $downPayment2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding()
                    TextField("Enter Monthly Payment", text: $monthlyPayment2)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding()
                    Text("Total Amount Paid: $\(String(format: "%.2f", totalAmountPaid2))")
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
            if !monthlyPayment1.isEmpty && !monthlyPayment2.isEmpty {
                Text(savingText)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Spacer()
        }
        .padding()
    }
}
