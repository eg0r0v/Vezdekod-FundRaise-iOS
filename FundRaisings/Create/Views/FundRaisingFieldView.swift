//
//  FundRaisingFieldView.swift
//  FundRaisings
//
//  Created by Илья Егоров on 11.09.2020.
//  Copyright © 2020 Илья Егоров. All rights reserved.
//

import UIKit

final class FundRaisingFieldView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var fieldTextView: UITextView!
    @IBOutlet private weak var dropDownButton: UIButton!
    
    private var fieldType: FundRaisingFieldType!
    private var onDidChangeText: ((String?) -> Void)?
    
    private var currentText = ""
    
    var isEmpty: Bool {
        return currentText.isEmpty
    }
    
    func configure(fieldType: FundRaisingFieldType,
                   onDidChangeText: @escaping (String?) -> Void) {
        
        self.fieldType = fieldType
        self.onDidChangeText = onDidChangeText
        
        titleLabel.text = fieldType.title
        fieldTextView.text = fieldType.placeholder
        
        setupKeyboardType()
        makeLockedFields()
    }
    
    private func setupKeyboardType() {
        switch fieldType {
        case .fundSum, .fundSumPerMonth:
            fieldTextView.keyboardType = .decimalPad
        default:
            fieldTextView.keyboardType = .default
        }
    }
    
    private func makeLockedFields() {
        switch fieldType {
        case .account, .author:
            onDidChangeText?(fieldType.placeholder)
            fieldTextView.textColor = .black
            fieldTextView.isUserInteractionEnabled = false
            dropDownButton.isHidden = false
            dropDownButton.imageView?.transform = .init(rotationAngle: .pi / 2)
        default:
            break
        }
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if fieldTextView.isUserInteractionEnabled {
            return fieldTextView.becomeFirstResponder()
        }
        return false
    }
}

extension FundRaisingFieldView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if currentText.isEmpty {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if currentText.isEmpty {
            textView.text = fieldType.placeholder
            textView.textColor = .lightGrayCaptionColor
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        currentText = textView.text
        onDidChangeText?(currentText.isEmpty ? nil : currentText)
    }
}
