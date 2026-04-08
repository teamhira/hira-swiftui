//
//  SadaqahViewModel.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import Foundation
import Observation

@Observable
public final class SadaqahViewModel {
    public var amount: String = ""
    public var selectedType: SadaqahType = .cash
    
    // Sedekah Subuh Program state
    public var isSubuhProgramActive: Bool = false
    public var hasJoinedSubuhCommunity: Bool = false
    
    public var campaigns: [SadaqahCampaignItem] = [
        SadaqahCampaignItem(title: "Pembangunan Masjid", category: "Waqf", progress: 0.75, description: "Bantu pembangunan masjid di daerah pedalaman Indonesia. Setiap rupiah yang Anda berikan menjadi amal jariyah yang tak terputus."),
        SadaqahCampaignItem(title: "Bantuan Anak Yatim", category: "Sosial", progress: 0.40, description: "Donasikan untuk keperluan pendidikan, makanan, dan tempat tinggal anak yatim piatu yang membutuhkan bimbingan kita."),
        SadaqahCampaignItem(title: "Waqaf Quran Nusantara", category: "Quran", progress: 0.90, description: "Salurkan Al-Quran ke pelosok Nusantara untuk santri dan mualaf yang sulit mendapatkan mushaf berkualitas.")
    ]
    
    public init() {}
    
    public func joinSubuhProgram() {
        isSubuhProgramActive = true
        hasJoinedSubuhCommunity = true
    }
}
