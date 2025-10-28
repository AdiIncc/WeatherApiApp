//
//  Extention+ViewController.swift
//  WeatherApiApp
//
//  Created by Adrian Inculet on 24.10.2025.
//

import Foundation
import UIKit

extension ViewController {
    
    func presentError(title: String,message: String) {
        let alertControl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionControl = UIAlertAction(title: "OK", style: .cancel)
        alertControl.addAction(actionControl)
    }
    
}
