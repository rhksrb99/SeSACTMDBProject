//
//  MovieInfoWebViewController.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/06.
//

import UIKit
import WebKit

import Alamofire
import SwiftyJSON

class MovieInfoWebViewController: UIViewController {
    
    @IBOutlet weak var movieInfoWebView: WKWebView!
    
    var movieid = ""
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // 첫번째 테이블뷰에서 링크버튼 클릭 시 해당 영화에 대한
    // movieID를 넘겨주며 해당 영화 예고편 유튜브 링크로 이동
    func movieInYoutube(movieid:String) {
        let url = "\(EndPoint.tmdbYoutubeFirstURL)\(movieid)\(EndPoint.tmdbYoutubeSecondURL)\(APIKey.tmdbKey)&language=en-US"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadWebPage(_ url: String){
        guard let myUrl = URL(string: url) else{
            return
        }
        let request = URLRequest(url: myUrl)
        movieInfoWebView.load(request)
    }

}
