//
//  CustomView.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/09.
//

import UIKit

class CustomView: UIView {

    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var btn_heart: UIButton!
    @IBOutlet weak var lb_main: UILabel!
    
    
    // 옵셔널 해제를 위한 초기화를 하는 과정
    required init?(coder:NSCoder) {
        super.init(coder: coder)
        
        let view = UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        
        
        self.addSubview(view)
        
        
    }

}
