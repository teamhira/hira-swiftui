//
//  QuranScriptType.swift
//  Hira
//
//  Created by Ryuk on 10/04/26.
//

import Foundation

public enum QuranScriptType: String, CaseIterable, Codable {
    case uthmani = "uthmani"
    case uthmaniSimple = "uthmani_simple"
    case textUthmaniSimple = "text_uthmani_simple"
    case uthmaniTajweed = "uthmani_tajweed"
    case textUthmaniTajweed = "text_uthmani_tajweed"
    case indopak = "indopak"
    case textIndopak = "text_indopak"
    case indopakNastaleeq = "indopak_nastaleeq"
    case textIndopakNastaleeq = "text_indopak_nastaleeq"
    case imlaei = "imlaei"
    case textImlaei = "text_imlaei"
    case imlaeiSimple = "imlaei_simple"
    case textImlaeiSimple = "text_imlaei_simple"
    case qpcHafs = "qpc_hafs"
    case textQpcHafs = "text_qpc_hafs"
    case qpcNastaleeq = "qpc_nastaleeq"
    case textQpcNastaleeq = "text_qpc_nastaleeq"
    case codeV1 = "code_v1"
    case v1 = "v1"
    case codeV2 = "code_v2"
    case v2 = "v2"
    case v1Image = "v1_image"
}
