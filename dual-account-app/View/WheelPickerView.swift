//
//  WheelPickerView.swift
//  DualAccount
//
//  Created by user.name on 26/07/2021.
//

import UIKit

final class WheelPickerView: UIPickerView {

    private var arrayData: [String] = []
    var dataSelected: String!
    
    var handleSelected: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    func initData(arrayData: [String], dataSelected: String) {
        self.arrayData = arrayData
        self.dataSelected = dataSelected
        
        if let initIndex = arrayData.firstIndex(of: dataSelected) {
            selectRow(initIndex, inComponent: 0, animated: false)
        }
    }
}

// MARK: - Private Functions
extension WheelPickerView {
    private func config() {
        delegate = self
        dataSource = self
    }
}

// MARK: - UIPickerViewDataSource
extension WheelPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayData[row]
    }
}

// MARK: - UIPickerViewDelegate
extension WheelPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dataSelected = arrayData[row]
    }
}

