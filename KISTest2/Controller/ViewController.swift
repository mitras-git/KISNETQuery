//
//  ViewController.swift
//  KISTest2
//
//  Created by मित्रा on 30/06/2022.
//

import UIKit

class ViewController: UIViewController {
    var networkManager = NetworkManager()
    var studentID: String = ""
    
    @IBOutlet weak var uiSpinnerView: UIActivityIndicatorView!
    @IBOutlet weak var IDtextField: UITextField!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var dorm: UILabel!
    @IBOutlet weak var studentIDLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        uiSpinnerView.startAnimating()
        uiSpinnerView.isHidden = true
    }

    @IBAction func testButtonPressed(_ sender: UIButton) {
        studentID = IDtextField.text ?? "6609"
        networkManager.performRequest(withID: studentID)
        IDtextField.text = ""
        IDtextField.endEditing(true)
        uiSpinnerView.isHidden = false
    }
}

extension ViewController: NetworkManagerDelegate {
    func updateStudentData(student: KISStudentModel) {
        DispatchQueue.main.async {
            self.uiSpinnerView.isHidden = true
            self.studentName.text = student.name
            self.grade.text = "\(student.grade)"
            self.studentIDLabel.text = "\(self.IDtextField.text ?? "6609")"
            self.dob.text = student.DOB
            self.gender.text = student.gender
            self.dorm.text = student.dorm
            if self.studentName.text != "" {
                self.uiSpinnerView.isHidden = true
                self.uiSpinnerView.stopAnimating()
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        IDtextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let id = IDtextField.text {
            networkManager.performRequest(withID: id)
        }
        IDtextField.text = ""
    }
}

