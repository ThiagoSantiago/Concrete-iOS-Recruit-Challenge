//
//  FavoriteViewController.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 07/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import UIKit
import DRPLoadingSpinner

class FavoriteViewController: UIViewController {
    @IBOutlet weak var spinner: DRPLoadingSpinner!
    
    override func viewDidLoad() {
        MovieHelper.configLoadingSpinner(spinner)
    }
}
