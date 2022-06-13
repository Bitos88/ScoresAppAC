//
//  Extension.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 4/6/22.
//

import UIKit

extension UIAlertController {
    static func showAlert(title:String, message:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let accion = UIAlertAction(title: "Accept", style: .default) { _ in print("Alert mostrado")
        }
        
        alert.addAction(accion)
        
        return alert
    }
}

//MARK: NOTIFICATIONS

extension Notification.Name {
    static let detailAlert = Notification.Name("DETAILALERT")
    static let reloadNewData = Notification.Name("RELOADNEWDATA")
}
