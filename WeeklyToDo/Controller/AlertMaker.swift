//
//  AlertMaker.swift
//  WeeklyToDo
//
//  Created by Hina on 2024/03/21.
//

import UIKit

struct AlertMaker {
    func noStringAlert(title:String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        return alert
    }
}
