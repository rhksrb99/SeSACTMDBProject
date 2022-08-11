//
//  CustomCollectionViewCell.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/09.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var customView: CustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        setupUI()
//        prepareForReuse()
        
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        customView.lb_main.text = nil
//    }
//
//    func setupUI() {
//        customView.backgroundColor = .clear
//        customView.mainImage.backgroundColor = .blue
//        customView.mainImage.layer.cornerRadius = 8
//        customView.btn_heart.tintColor = .black
//    }

}
