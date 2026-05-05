//
//  ArrayExtension.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 11/09/2025.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
