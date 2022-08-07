//
//  SearchViewController.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/03.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var movieGenre:[Int:String] = [:]
    var movieGenreId:[Int] = []
    
    var movieList : [Movie] = []
    
    var genreId:[Int] = []
    var genreName:[String] = []

    var actorName:[Actor] = []
    var actorName2:[[Actor]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewNib()
        LoadGenre()
        tmdb_movie()
        configureView()
        designNavigation()
        
    }
    
    // MARK: - Functions
    
    func linkButtonClicked(index:Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: MovieInfoWebViewController.reuseIdentifier) as! MovieInfoWebViewController
        
        vc.movieid = movieList[index].id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainMovieTableViewCell.reuseIdentifier, for: indexPath) as! MainMovieTableViewCell
        
        let count = movieGenreId.randomElement()!
        
        cell.lb_title.text = movieList[indexPath.row].title
        cell.lb_releaseDate.text = movieList[indexPath.row].date
        cell.lb_rate.text = movieList[indexPath.row].rate
        cell.lb_genre.text = movieGenre[count]
        cell.img_main.kf.setImage(with: URL(string: EndPoint.tmdbBgImage+movieList[indexPath.row].backGroundImage))
//        let cell = tableView.dequeueReusableCell(withIdentifier: MainMovieTableViewCell.reuseIdentifier, for: indexPath) as! MainMovieTableViewCell
        cell.btn_YoutubeLink.addTarget(self, action: Selector("\(linkButtonClicked(index: indexPath.row))"), for: .touchUpInside)
        
        if actorName2.count - 1 >= indexPath.row {
            cell.lb_actors.text = "\(actorName2[indexPath.row][0].actorName), \(actorName2[indexPath.row][1].actorName), \(actorName2[indexPath.row][2].actorName),\(actorName2[indexPath.row][3].actorName)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print("didSelectRowAt Click")
        // 셀을 클릭했을 떄의 화면전환.
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: MovieDetailViewController.reuseIdentifier) as! MovieDetailViewController
        
        vc.movieInfo = movieList[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        print("didSelectRowAt Clicked")
    }
    
    func tableViewNib() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: MainMovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MainMovieTableViewCell.reuseIdentifier)
    }

    func configureView() {
        mainTableView.backgroundColor = .clear
        mainTableView.separatorColor = .clear
        mainTableView.rowHeight = 380
    }
    
    // MARK: - design
    
    // 셀디자인 코드 작성 후 정리해야 함
    func designCell() {
        
    }
    
    func designNavigation() {
        
        self.navigationItem.title = ""
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: #selector(category))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchMovie))
    }
    
    // MARK: - @objc Functions
    
    @objc func category() {
        
    }
    
    @objc func searchMovie() {
        
    }
    
    // MARK: - Alamofire
    
    func tmdb_movie() {
        let url = "\(EndPoint.tmdbMovieURL)\(APIKey.tmdbKey)"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                for movie in json["results"].arrayValue{
                    let id = movie["id"].stringValue
                    let title = movie["original_title"].stringValue
                    let image = movie["poster_path"].stringValue
                    let bgimage = movie["backdrop_path"].stringValue
                    let date = movie["date"].stringValue
                    let rate = String(format: "%.1f",movie["vote_average"].doubleValue)
                    let overview = movie["overview"].stringValue
                    var genreIds = 0
                    for item in movie["genre_ids"].arrayValue {
                        genreIds = item.intValue
                    }
                    
                    self.movieList.append(Movie(id: id, title: title, image: image, backGroundImage: bgimage, date: date, rate: rate, genreId: genreIds, overview: overview))

                    for item in movie["genre_ids"].arrayValue {
                        self.movieGenreId.append(item.intValue)
                    }
                    // 각 영화마다의 아이디를 넣어 배우를 찾는 함수 실행 완료
                    self.tmdb_person(id: id)
                }
                
                self.mainTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tmdb_person(id:String) {
        let url = "\(EndPoint.tmdbPersonFirstURL)\(id)\(EndPoint.tmdbPersonSecondURL)\(APIKey.tmdbKey)"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for actornames in json["cast"].arrayValue{
                    
                    let realName = actornames["name"].stringValue
                    let movieName = actornames["character"].stringValue
                    let profileUrl = actornames["profile_path"].stringValue
                    
                    let actor = Actor(actorName: realName, actorCharacter: movieName, actorImage: profileUrl)
                    self.actorName.append(actor)
                }
                self.actorName2.append(self.actorName)
                
                self.actorName.removeAll()
                
                self.mainTableView.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func LoadGenre() {
        let url = "\(EndPoint.tmdbMovieGenre)\(APIKey.tmdbKey)&language=en-US"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)["genres"]
//                print("JSON: \(json)")
                
                for item in json.arrayValue{
                    let id = item["id"].intValue
                    let name = item["name"].stringValue
                    
                    self.movieGenre[id] = name
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    func loadVideo() {
//        let url = "\(EndPoint.tmdbYoutubeFirstURL)\(movieid)\(EndPoint.tmdbYoutubeSecondURL)\(APIKey.tmdbKey)&language=kr-KR"
//        AF.request(url, method: .get).validate().responseData { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
}
