//
//  ViewController.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON


class ViewController: UIViewController {

    var movieid:[String] = []
    var actorName:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tmdb_movie()
//        tmdb_person(id: "725201")
    }
    func tmdb_movie() {
        let url = "\(EndPoint.tmdbMovieURL)\(APIKey.tmdbKey)"
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
//                print("jsonResult : \(json["results"].arrayValue)") // 정상출력
//                print("jsonResult : \(json["results"][0]["id"].stringValue)") // 정상출력
                
                for movie in json["results"].arrayValue{
                    self.movieid.append(movie["id"].stringValue)
                }
                print(self.movieid)
                
                self.tmdb_person(id: self.movieid[0])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tmdb_person(id:String) {
        let url = "\(EndPoint.tmdbPersonFirstURL)\(id)\(EndPoint.tmdbPersonSecondURL)\(APIKey.tmdbKey)"
        AF.request(url, method: .get).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                for actornames in json["cast"].arrayValue{
                    self.actorName.append(actornames["name"].stringValue)
                }
                print(self.actorName)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

