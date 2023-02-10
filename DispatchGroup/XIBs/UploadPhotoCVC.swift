//
//  UploadPhotoCVC.swift
//  Offerpad Connect
//
//  Created by Inderjeet Singh on 03/02/23.
//  Copyright © 2023 Offerpad LLC. All rights reserved.
//

import UIKit

class UploadPhotoCVC: UICollectionViewCell {

//    MARK: - Outlets
    @IBOutlet weak var photoView: UIImageView!
    
    //    MARK: - Variables
    static let Cell_Identifier = "UploadPhotoCVC"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(data: UIImage) {
        self.photoView.image = data
        self.photoView.layer.cornerRadius = 8
        self.photoView.clipsToBounds = true
    }
}
