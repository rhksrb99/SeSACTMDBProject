//
//  ViewPresentableProtocol.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/04.
//

import Foundation
import UIKit

@objc
protocol ViewPresentableProtocol {
    
    var navigationTitleString: String { get set }
    var backgroundColor: UIColor { get }
    static var identifier: String { get }
    
    func configureView()
    @objc optional func configureLabel()
    @objc optional func configureTextField()
}

@objc protocol KidultTableViewProtocol {
    func nuberOfRowsInSection() -> Int
    func cellForRowAt(indexPath:IndexPath) -> UITableViewCell
    @objc optional func didSelectRowAt()
}
