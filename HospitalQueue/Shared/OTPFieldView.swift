//
//  OTPFieldView.swift
//  HospitalQueue
//

import SwiftUI

struct OTPFieldView: View {
    @Binding var digits: [String]
    let digitCount: Int
    
    init(digits: Binding<[String]>, digitCount: Int = 6) {
        _digits = digits
        self.digitCount = digitCount
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<digitCount, id: \.self) { index in
                OTPDigitBox(
                    text: Binding(
                        get: { index < digits.count ? digits[index] : "" },
                        set: { newValue in
                            if index < digits.count {
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count <= 1 {
                                    digits[index] = filtered
                                    if !filtered.isEmpty, index < digitCount - 1 { }
                                }
                            }
                        }
                    )
                )
            }
        }
    }
}

struct OTPDigitBox: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("", text: $text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.title2)
            .frame(width: 44, height: 50)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Theme.borderGray, lineWidth: 1)
            )
            .cornerRadius(8)
            .focused($isFocused)
            .onChange(of: text) { oldValue, newValue in
                let filtered = newValue.filter { $0.isNumber }
                if filtered.count > 1 {
                    text = String(filtered.prefix(1))
                } else {
                    text = filtered
                }
            }
    }
}
