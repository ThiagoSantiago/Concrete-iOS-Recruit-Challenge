//
//  PopularMovieCell.swift
//  ios-recruit-challenge
//
//  Created by Thiago Alexandre Araújo Santiago on 07/02/2018.
//  Copyright © 2018 Thiago Alexandre Araújo Santiago. All rights reserved.
//

import UIKit

class PopularMovieCell: UICollectionViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var baseFavoriteView: UIView!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var favoriteView: UIImageView!
    
    override func awakeFromNib() {
        baseView.layer.cornerRadius = 10
        baseFavoriteView.layer.cornerRadius = 20
    }
}
