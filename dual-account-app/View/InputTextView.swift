//  gkc_hash_code : 01E7J182PMWQBNM0GN3DE8TS7F
//
//  InputTextView.swift
//  MeeTruckMouseAdjusters
//
//  Created by user.name on 07/04/2021.
//

import UIKit

final class InputTextView: UITextView {
    var maxLength: Int?
    
    @IBInspectable var placeholderColor: UIColor = .lightGray
    
    @IBInspectable var colorText: UIColor = .black
    
    @IBInspectable var placeholder: String? {
        didSet {
            text = placeholder
        }
    }
    
    var didEndEditing: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = text == placeholder ? placeholderColor : colorText
        delegate = self
    }
    
    func updateLineSpacing() {
        let mutableAttrStr = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        mutableAttrStr.addAttributes([NSAttributedString.Key.paragraphStyle: style,
                                      NSAttributedString.Key.font: font ?? UIFont()],
                                     range: NSMakeRange(0, mutableAttrStr.length))
        attributedText = mutableAttrStr
    }
}

extension InputTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = nil
            textView.textColor = colorText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textColor != placeholderColor {
            didEndEditing?(textView.text)
        }
        
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let maxLength = maxLength else { return true }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count <= maxLength {
            return true
        }
        textView.text = newText.subString(from: 0, to: maxLength) 
        return false
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updateLineSpacing()
    }
}
