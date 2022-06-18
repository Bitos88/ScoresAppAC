//
//  DetailViewController.swift
//  ScoresAPP
//
//  Created by Alberto Alegre Bravo on 1/6/22.
//

import UIKit

final class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    let modelLogic = ModelLogic.shared

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var composerTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var score:ScoreModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        configureNotifications()
        
        tableView.allowsSelection = false
    }
    
    fileprivate func configureNotifications() {
        NotificationCenter.default.addObserver(forName: .detailAlert,
                                               object: nil,
                                               queue: .main) { notification in
            guard let message = notification.object as? String else {
                return
            }
            
            self.present(UIAlertController.showAlert(title: "Info", message: "\(message)"), animated: true)
        }
        
        NotificationCenter.default.addObserver(forName: .reloadNewData,
                                               object: nil,
                                               queue: .main) { notification in
            guard let message = notification.object as? String else { return }
            
            self.present(UIAlertController.showAlert(title: "Saved Data", message: "\(message)"), animated: true)
        }
    }
    
    func initialize() {
        if let score = score {
            titleTextField.text = score.title
            composerTextField.text = score.composer
            yearTextField.text = "\(score.year)"
            lengthTextField.text = "\(score.length)"
            coverImage.image = UIImage(named: "\(score.cover)")
        } else {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
            navigationItem.leftBarButtonItem = closeButton
            shareButton.isEnabled = false
            shareButton.tintColor = .clear
            coverImage.image = UIImage(named: "coverPlaceholder_")
        }
        composerTextField.delegate = self
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty,
              let composer = composerTextField.text, !composer.isEmpty,
              let year = yearTextField.text, let yearNumber = Int(year),
              let length = lengthTextField.text, let lengthNumber = Double(length)
        else {
          
          present(UIAlertController.showAlert(title: "Error", message: "Data must not be empty"), animated: true)
          
          return
      }
        if let score = score {
            self.score = ScoreModel(id: score.id, title: title, composer: composer, year: yearNumber, length: lengthNumber, cover: score.cover, tracks: score.tracks)
            performSegue(withIdentifier: "back", sender: nil)
        } else {
            modelLogic.addNewScore(title: title, composer: composer, year: yearNumber, length: lengthNumber)
            dismiss(animated: true)
            NotificationCenter.default.post(name: .reloadNewData, object: "New Composer Added")
        }
    }
    
    @IBAction func shareScore(_ sender: UIBarButtonItem) {
        let activity = UIActivityViewController(activityItems: [coverImage.image as Any], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let picker = CustomPickerView(data: modelLogic.composers, initialValue: composerTextField.text ?? "")
        picker.delegateCustom = self
        textField.inputView = picker
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButton))
        
        textField.inputAccessoryView = createToolbar(buttons: [spacer, done])
        
    }
    
    @objc func doneButton() {
        composerTextField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .detailAlert, object: nil)
        NotificationCenter.default.removeObserver(self, name: .reloadNewData, object: nil)
    }
}

extension DetailViewController: CustomPickerViewDelegate {
    func didSelectRow(pickerView: UIPickerView, didSelectValue value: String) {
        composerTextField.text = value
    }
}
