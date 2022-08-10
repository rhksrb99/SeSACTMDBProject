//
//  MainViewController.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/09.
//

import UIKit

/*
 tableView - CollectionView > 프로토콜
 tag
 */
/*
 awakeFromNib - 셀 UI 초기화, 재사용 메커니즘에 의해 일정 횟수 이상 호출되지 않는다
 cellForItemAt
 - 재사용 될 때마다, 사용자에게 보일 때 마다 항상 실행도니다.
 - 화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있다.
 
 prepareForReuse
 - 셀이 재상요 될 때 초기화 하고자 하는 값을 넣으면 오류를 해결할 수 있다. 즉, cellForRowAt에서 모든 indexPath.item에 대한 조건을 작성하지 않아도 된다.
 
 CollectionView in Tableview
 - 하나의 컬렉션뷰나 테이블뷰라면 문제가 없지만
 - 복합적인 구조라면, 테이블셀도 재사용 되어야하고 컬렉션셀도 재사용이 되어야 한다.
 
 - print, Debug를 통해 오류구간을 찾고 해결해볼 수 있다.
 */


class MainViewController: UIViewController {

    @IBOutlet weak var customBannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    
    let numberList: [[Int]] = [
        [Int](1...10),
        [Int](11...20),
        [Int](21...30),
        [Int](31...40),
        [Int](41...50),
        [Int](51...60)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        customBannerCollectionView.delegate = self
        customBannerCollectionView.dataSource = self
        customBannerCollectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
        customBannerCollectionView.collectionViewLayout = collectionViewLayout()
        customBannerCollectionView.isPagingEnabled = true
        
    }
    

}
// MARK: - TableView delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 내부 매개변수 tableView를 통해 테이블뷰를 특정
    // 테이블뷰 객체가 하나 일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("MainTableViewCell", #function, indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .gray
        cell.cotentCollectionView.delegate = self
        cell.cotentCollectionView.dataSource = self
        // 셀의 태그에 인덱스의 섹션을 지정
        cell.cotentCollectionView.tag = indexPath.section
        // 셀의 컬랙션뷰에 커스텀한 컬렉션뷰를 연결
        cell.cotentCollectionView.register(UINib(nibName: CustomCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier)
        cell.cotentCollectionView.reloadData()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 3번째 섹션에 넷플릭스의 인기 영화 보여주 듯
        // 다른 셀보다 크기를 크기를 크게 하고 싶을 떄
        // 이런식으로 지정해줄 수 있다.
        return indexPath.section == 3 ? 350 : 190
    }
}

// MARK: - CollectionView Delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView == customBannerCollectionView ? color.count : numberList[collectionView.tag].count
    }
    
    // customBannerCollectionView가 들어올 수도 있고
    // 테이블뷰 안에 들어있는 컬렉션뷰가 들어올 수 도 있다.
    // 내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우, 셀이 재사용 되면 특정 collectionView 셀을 재사용하게 될 수 있다.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("MainCollectionViewController", #function, indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        if collectionView == customBannerCollectionView {
            cell.customView.mainImage.backgroundColor = color[indexPath.item]
        }else {
            cell.backgroundColor = .green
            cell.customView.mainImage.backgroundColor = .systemIndigo
            cell.customView.lb_main.textColor = .white
//            if indexPath.item < 2 {
            cell.customView.lb_main.text = "\(numberList[collectionView.tag][indexPath.item])"
//            }
        }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width , height: customBannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}
