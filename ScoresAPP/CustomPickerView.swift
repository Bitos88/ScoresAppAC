//
//  ComposerPickerView.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 5/6/22.
//

import UIKit

class CustomPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let data:[String]
    
    init(data:[String]) {
        self.data = data
        super.init(frame: .zero)
        delegate = self
        dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        self.data = []
        super.init(coder: coder)
    }
    
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
        <#code#>
    }
}
