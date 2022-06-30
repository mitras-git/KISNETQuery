//
//  JSONKISStudentData.swift
//  KISTest2
//
//  Created by मित्रा on 30/06/2022.
//

import Foundation

struct JSONKISStudentData: Codable {
    let document: JSONStudent
}

struct JSONStudent: Codable {
    let name: String
    let grade: Int
    let DOB: String
    let gender: String
    let dorm: String
    let house: String
    let studentID: Int
}
