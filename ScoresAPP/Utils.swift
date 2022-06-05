//
//  Utils.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 5/6/22.
//

import UIKit

func createToolbar(buttons:[UIBarButtonItem]) -> UIToolbar {
    let toolbar = UIToolbar()
    toolbar.barStyle = .default
    toolbar.isTranslucent = true
    toolbar.tintColor = .gray
    toolbar.sizeToFit()
    
    toolbar.setItems(buttons, animated: true)
    
    return toolbar
}
