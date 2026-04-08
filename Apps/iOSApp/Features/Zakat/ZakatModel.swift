//
//  ZakatModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import SwiftUI

/// Represents different types of Zakat in Islam.
public enum ZakatType: String, CaseIterable, Identifiable {
    case fitrah = "Fitrah"
    case emas = "Emas & Perak"
    case uang = "Tabungan/Uang"
    case dagang = "Perdagangan"
    case tani = "Pertanian"
    case ternak = "Peternakan"
    case tambang = "Tambang & Rikaz"
    case profesi = "Profesi"
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .fitrah: return "person.3.fill"
        case .emas: return "sparkles"
        case .uang: return "banknote.fill"
        case .dagang: return "cart.fill"
        case .tani: return "leaf.fill"
        case .ternak: return "hare.fill"
        case .tambang: return "hammer.fill"
        case .profesi: return "briefcase.fill"
        }
    }
    
    public var localizedTitleKey: String {
        switch self {
        case .fitrah: return "zakat_title_fitrah"
        case .emas: return "zakat_title_gold"
        case .uang: return "zakat_title_savings"
        case .dagang: return "zakat_title_trade"
        case .tani: return "zakat_title_agriculture"
        case .ternak: return "zakat_title_livestock"
        case .tambang: return "zakat_title_mining"
        case .profesi: return "zakat_title_profession"
        }
    }
    
    public var localizedDescKey: String {
        switch self {
        case .fitrah: return "zakat_desc_fitrah"
        case .emas: return "zakat_desc_gold"
        case .uang: return "zakat_desc_savings"
        case .dagang: return "zakat_desc_trade"
        case .tani: return "zakat_desc_agriculture"
        case .ternak: return "zakat_desc_livestock"
        case .tambang: return "zakat_desc_mining"
        case .profesi: return "zakat_desc_profession"
        }
    }
    
    public var labelKey: String {
        switch self {
        case .fitrah: return "zakat_label_people"
        case .emas: return "zakat_label_grams"
        case .tani: return "zakat_label_harvest"
        case .ternak: return "zakat_label_people" // Using people for simplified count
        default: return "zakat_label_amount"
        }
    }
    
    public var placeholder: String {
        switch self {
        case .fitrah: return "Jumlah Jiwa"
        case .emas: return "Total Gram Emas"
        case .ternak: return "Jumlah Hewan Ternak"
        case .tani: return "Hasil Panen (Kg)"
        case .tambang: return "Nilai Harta Temuan (Rp)"
        default: return "Total Saldo / Aset (Rp)"
        }
    }
}

/// A record of a calculated zakat payment.
public struct ZakatRecord: Identifiable {
    public let id = UUID()
    public let type: ZakatType
    public let date: Date
    public let assetAmount: Double
    public let zakatAmount: Double
}
