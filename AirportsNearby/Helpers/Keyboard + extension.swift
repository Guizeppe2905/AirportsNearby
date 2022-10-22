//
//  Keyboard + extension.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 29.09.2022.
//

import UIKit

extension SearchViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
