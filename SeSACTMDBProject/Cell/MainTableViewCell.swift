//
//  MainTableViewCell.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/10.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        contentCollectionView.collectionViewLayout = collectionViewLayout()
        print("MainTableViewCell", #function)
    }

    
    func setupUI() {
        lb_title.font = .boldSystemFont(ofSize: 24)
        lb_title.text = "넷플릭스 인기 컨텐츠"
        lb_title.backgroundColor = .lightGray
        
        contentCollectionView.backgroundColor = .clear
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        // left만 16을 준 이유는 넷플릭스의 영화 추천을 보면 왼쪽에 붙어있지 않고
        // 어느정도 간격을 두고 있기 때문에 16정도를 기본값으로 줬다.
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 130)
        return layout
    }
    
}
