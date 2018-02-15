//
//  MovieHelper.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 07/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import Foundation
import DRPLoadingSpinner

class MovieHelper {
    
    static func configLoadingSpinner(_ spinner: DRPLoadingSpinner) {
        spinner.colorSequence = [Color.DarkYellow]
        spinner.lineWidth = 3.0
        spinner.maximumArcLength = CGFloat((2 * Double.pi) - Double.pi / 4)
        spinner.minimumArcLength = 1.0
        spinner.startAnimating()
    }
    
    static func convertDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date!)
    }
}
