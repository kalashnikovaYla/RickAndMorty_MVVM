//
//  Extensions.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 13.01.2023.
//

import UIKit

extension UIView {
    func addSubviews( _ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
