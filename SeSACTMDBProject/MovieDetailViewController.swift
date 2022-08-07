//
//  MovieDetailViewController.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/04.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var img_backGround: UIImageView!
    @IBOutlet weak var img_poster: UIImageView!
    @IBOutlet weak var detailTableView: UITableView!
    
    var movieInfo : Movie?
    var actorInfos : [Actor] = []
    var crewsInfos : [Actor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCast()
        tableViewNib()
        configureView()
        designNavigation()
        designMovieInfo()
        
    }
    
    
    // MARK: - Alamofire
    func requestCast() {
        guard let movieId = movieInfo?.id else {return}
        
        let url = "\(EndPoint.tmdbPersonFirstURL)\(movieId)\(EndPoint.tmdbPersonSecondURL)\(APIKey.tmdbKey)"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for cast in json["cast"].arrayValue {
                    let actorName = cast["name"].stringValue
                    let actorImage = cast["profile_path"].stringValue
                    let actorCharacter = cast["character"].stringValue
                    
                    let data = Actor(actorName: actorName, actorCharacter: actorCharacter, actorImage: actorImage)
                    
                    self.actorInfos.append(data)
                }
                
                self.detailTableView.reloadData()
                
                for crew in json["crew"].arrayValue {
                    let directorName = crew["name"].stringValue
                    let directorImage = crew["profile_path"].stringValue
                    let directorJob = crew["job"].stringValue
                    
                    let data = Actor(actorName: directorName, actorCharacter: directorJob, actorImage: directorImage)
                    
                    self.crewsInfos.append(data)
                }
                
                self.detailTableView.reloadData()
                                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - setData, design Functions
    func designMovieInfo() {
        guard let movieInfo = movieInfo else { return }
        
        let title = movieInfo.title
        lb_title.text = title
        let backGroundImage = movieInfo.backGroundImage
        img_backGround.kf.setImage(with: URL(string:EndPoint.tmdbBgImage+backGroundImage))
        let posterImage = movieInfo.image
        img_poster.kf.setImage(with: URL(string: EndPoint.tmdbBgImage+posterImage))
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    
    
    // 테이블 뷰 헤더 설정할 수 있는 함수
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 0 {
            return "overview"
        }else if section == 1 {
            return "cast"
        }else if section == 2 {
            return "crew"
        }
        return ""
    }
    
    
    func configureView() {
        detailTableView.backgroundColor = .clear
        detailTableView.separatorColor = .clear
        detailTableView.rowHeight = 80
    }
    
    func tableViewNib() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        let nib1 = UINib(nibName: MovieDeatailTableViewCell.reuseIdentifier, bundle: nil)
        detailTableView.register(nib1, forCellReuseIdentifier: MovieDeatailTableViewCell.reuseIdentifier)
        let nib2 = UINib(nibName: OverViewTableViewCell.reuseIdentifier, bundle: nil)
        detailTableView.register(nib2, forCellReuseIdentifier: OverViewTableViewCell.reuseIdentifier)
    }
    
    func designNavigation() {
        self.navigationItem.title = "출연/제작"
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return actorInfos.count
        }else {
            return crewsInfos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let overviewCell = tableView.dequeueReusableCell(withIdentifier: OverViewTableViewCell.reuseIdentifier, for: indexPath) as! OverViewTableViewCell
            overviewCell.overview.text = movieInfo?.overview
            return overviewCell
            
        }else if indexPath.section == 1 {
            
            // 배우의 본명, 캐릭터 이름, 배우의 프로필
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDeatailTableViewCell.reuseIdentifier, for: indexPath) as! MovieDeatailTableViewCell
            
            cell.lb_actorOriginalName.text = actorInfos[indexPath.row].actorName
            cell.lb_actorName.text = actorInfos[indexPath.row].actorCharacter
            cell.img_actor.kf.setImage(with: URL(string: EndPoint.tmdbBgImage +  actorInfos[indexPath.row].actorImage))
            return cell
            
        }else {
            // 감독들의 정보 가져와서 출력하기.
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieDeatailTableViewCell.reuseIdentifier, for: indexPath) as! MovieDeatailTableViewCell
            
            cell.lb_actorOriginalName.text = crewsInfos[indexPath.row].actorName
            cell.lb_actorName.text = crewsInfos[indexPath.row].actorCharacter
            cell.img_actor.kf.setImage(with: URL(string: EndPoint.tmdbBgImage + crewsInfos[indexPath.row].actorImage))
            
            return cell
        }
    }
    
}
