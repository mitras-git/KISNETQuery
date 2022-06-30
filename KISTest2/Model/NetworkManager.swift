//
//  NetworkManager.swift
//  KISTest2
//
//  Created by मित्रा on 30/06/2022.
//

import Foundation

protocol NetworkManagerDelegate {
    func updateStudentData(student: KISStudentModel)
}

struct NetworkManager {
    let requestURL = "https://data.mongodb-api.com/app/data-irsfi/endpoint/data/v1/action/findOne"
    let APIkey = Secrets().mongoKey
    
    var delegate: NetworkManagerDelegate?
    
    func performRequest(withID: String) {
        KISRequest(with: requestURL, id: withID)
        print("Test Button Pass!")
    }
    
    func KISRequest(with urlLink: String, id: String) {
        let parameters = "{\"collection\":\"students\", \"database\":\"KISApp\", \"dataSource\":\"Cluster0\", \"filter\": {\"studentID\": \(id)}}"
        print(parameters)
        guard let url = URL(string: urlLink),
              let payload = parameters.data(using: .utf8) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(APIkey, forHTTPHeaderField: "api-key")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.httpBody = payload
        print("URL Encoding Success!")
        
        URLSession.shared.dataTask(with: request) { (data, response , error) in
            if error != nil {
                print("Found error \(error!)")
            }
            if let safeData = data {
                if let student = self.parseJSON(safeData){
                    self.delegate?.updateStudentData(student: student)
                }
            }
        }.resume()
    }
    
    func parseJSON(_ studentData: Data) -> KISStudentModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(JSONKISStudentData.self, from: studentData)
            let name = decodedData.document.name
            let grade = decodedData.document.grade
            let dob = decodedData.document.DOB
            let dorm = decodedData.document.dorm
            let gender = decodedData.document.gender
            let house = decodedData.document.house
            let studentID = decodedData.document.studentID
            
            print(decodedData.document.name)
            print(decodedData.document.grade)
            print(decodedData.document.DOB)
            print(decodedData.document.dorm)
            print(decodedData.document.gender)
            print(decodedData.document.house)
            print(decodedData.document.studentID)
            
            let student = KISStudentModel(name: name, grade: grade, DOB: dob, gender: gender, dorm: dorm, house: house, studentID: studentID)
            
            return student
        } catch {
            print("\(error)")
            return nil
        }
    }
}
