//
//  ComposerPickerView.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 5/6/22.
//

import UIKit

protocol CustomPickerViewDelegate {
    func didSelectRow(pickerView: UIPickerView, didSelectValue value: String)
}

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let data:[String]
    
    init(data:[String], initialValue: String) {
        self.data = data
        super.init(frame: .zero)
        delegate = self
        dataSource = self
        if let index = data.firstIndex(where: {$0 == initialValue}) {
            selectRow(index, inComponent: 0, animated: false)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        self.data = []
        super.init(coder: coder)
    }
    
    var delegateCustom: CustomPickerViewDelegate?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegateCustom?.didSelectRow(pickerView: pickerView, didSelectValue: data[row])
    }
}
