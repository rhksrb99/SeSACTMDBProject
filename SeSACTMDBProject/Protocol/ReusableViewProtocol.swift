//
//  ReusableViewProtocol.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/10.
//

//import UIKit
//import SeSACTMDBFramework

//protocol ReusableViewProtocol {
//    static var reuseIdentifier: String { get } //저장 프로퍼티이든 연산프로퍼티 이든 상관없다.
//}
//
//extension UIViewController: ReusableViewProtocol {
//    static var reuseIdentifier: String {
//        return String(describing: self)
//    }
//}
//
//extension UICollectionViewCell: ReusableViewProtocol {
//    static var reuseIdentifier: String {
//        return String(describing: self)
//    }
//}
//extension UITableViewCell: ReusableViewProtocol {
//    static var reuseIdentifier: String {
//        return String(describing: self)
//    }
//}
