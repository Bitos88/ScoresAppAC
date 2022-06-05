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
    
    var score:ScoreModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = score?.title
        composerTextField.text = score?.composer
        yearTextField.text = "\(score?.year ?? 0)"
        lengthTextField.text = "\(score?.length ?? 0)"
        coverImage.image = UIImage(named: "\(score?.cover ?? "")")
        composerTextField.delegate = self
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let score = score,
              let title = titleTextField.text,
              let composer = composerTextField.text,
              !title.isEmpty else {
            
            present(UIAlertController.showAlert(title: "Error", message: "Introduce datos"), animated: true)
            
            return
        }
        self.score = ScoreModel(id: score.id, title: title, composer: composer, year: score.year, length: score.length, cover: score.cover, tracks: score.tracks)
        performSegue(withIdentifier: "back", sender: nil)
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
}

extension DetailViewController: CustomPickerViewDelegate {
    func didSelectRow(pickerView: UIPickerView, didSelectValue value: String) {
        composerTextField.text = value
    }
}
