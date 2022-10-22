//
//  TextField + extension.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 28.09.2022.
//

import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String?,Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap { $0.text }
            .eraseToAnyPublisher()
    }
}
