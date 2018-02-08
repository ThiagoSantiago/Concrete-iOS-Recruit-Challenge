//
//  Utils.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 05/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import UIKit

public struct Color {
    static let DarkYellow = UIColor(red:217/255, green:151/255, blue:30/255, alpha: 1.0)
}

class Constants {
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let apiKey = "ba9ff4f446ab295f4c2afd0dd03166f7"
    static let lostConnectionMessage = "Ops, parece que você está sem conexão com a internet."
    static let defaultServerFailureError = "Oops, parece que tem algo de errado com nossos servidores no momento. \u{1F61E}"
}
