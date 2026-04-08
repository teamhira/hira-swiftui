//
//  ZakatViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation
import SwiftUI

@Observable
public final class ZakatViewModel {
    // Asset input state (Generalized)
    public var currentAsset: String = ""
    public var assetPrice: String = ""      // Price per gram/unit
    public var secondaryIncome: String = "" // For profession
    public var expenseValue: String = ""    // For trade/mal
    
    public var calculatedZakat: Double = 0
    public var selectedType: ZakatType = .emas
    
    // History
    public var history: [ZakatRecord] = []
    
    // Logic options for specialized zakat
    public var useIrrigation: Bool = false
    public var goldPricePerGram: Double = 1200000 // Default/Mock value
    
    public init() {}
    
    /// Complex calculation based on the Zakat type and its specific rules.
    public func calculate() {
        let amount = Double(currentAsset) ?? 0
        let price = Double(assetPrice) ?? goldPricePerGram
        let extra = Double(secondaryIncome) ?? 0
        
        switch selectedType {
        case .fitrah:
            // amount = people. price = price per head.
            let unitPrice = Double(assetPrice) ?? 45000
            calculatedZakat = amount * unitPrice
            
        case .emas:
            // amount = grams. price = price per gram.
            calculatedZakat = (amount * price) * 0.025
            
        case .tani:
            // amount = kg. price = price per kg.
            let unitPrice = Double(assetPrice) ?? 12000
            let rate = useIrrigation ? 0.05 : 0.10
            calculatedZakat = (amount * unitPrice) * rate
            
        case .ternak:
            // Simplified livestock value calc
            calculatedZakat = (amount * (Double(assetPrice) ?? 3000000)) * 0.025
            
        case .tambang:
            // Rikaz: 20%. amount = Rp.
            calculatedZakat = amount * 0.20
            
        case .profesi:
            // (amount = salary, extra = other)
            calculatedZakat = (amount + extra) * 0.025
            
        case .dagang:
            // amount = total assets. expense = debts/liabilities.
            let net = amount - (Double(expenseValue) ?? 0)
            calculatedZakat = max(0, net) * 0.025
            
        default:
            // Standard Zakat Mal (Uang): 2.5%.
            calculatedZakat = amount * 0.025
        }
    }
    
    public func addRecord() {
        guard let amount = Double(currentAsset) else { return }
        let record = ZakatRecord(type: selectedType, date: Date(), assetAmount: amount, zakatAmount: calculatedZakat)
        history.insert(record, at: 0)
    }
}
