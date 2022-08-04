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
    
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var mainTableView: UITableView!
    
    var movieName:[String] = []
    var movieRate:[String] = []
    var movieImage:[String] = []
    var movieBgImage:[String] = []
    var movieId:[String] = []
    var movieDate:[String] = []
    var movieGenre:[Int:String] = [:]
    var movieGenreId:[Int] = []
    
    var genreId:[Int] = []
    var genreName:[String] = []

    var actorName:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadGenre()
        tableViewNib()
        configureView()
        designNavigation()
        tmdb_movie()

    }
    
    // MARK: - Functions
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainMovieTableViewCell.reuseIdentifier, for: indexPath) as! MainMovieTableViewCell
        let count = movieGenreId.randomElement()!
        
        cell.lb_title.text = movieName[indexPath.row]
        cell.lb_releaseDate.text = movieDate[indexPath.row]
        cell.lb_rate.text = movieRate[indexPath.row]
        cell.lb_genre.text = movieGenre[count]
        cell.img_main.kf.setImage(with: URL(string: EndPoint.tmdbBgImage+movieBgImage[indexPath.row]))
        cell.lb_actors.text = actorName[indexPath.row]
        
        
        return cell
    }
    
    func tableViewNib() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: MainMovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MainMovieTableViewCell.reuseIdentifier)
    }

    func configureView() {
        mainTableView.backgroundColor = .clear
        mainTableView.separatorColor = .clear
        mainTableView.rowHeight = 350
    }
    
    func designCell() {
        
    }
    
    func designNavigation() {
        
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "listbullet"), style: .plain, target: self, action: #selector(category))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchMovie))
    }
    
    @objc func category() {
        
    }
    
    @objc func searchMovie() {
        
    }
    
    func tmdb_movie() {
        let url = "\(EndPoint.tmdbMovieURL)\(APIKey.tmdbKey)"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                for movie in json["results"].arrayValue{
                    self.movieId.append(movie["id"].stringValue)
                    self.movieName.append(movie["original_title"].stringValue)
                    self.movieImage.append(movie["poster_path"].stringValue)
                    self.movieBgImage.append(movie["backdrop_path"].stringValue)
                    self.movieDate.append(movie["release_date"].stringValue)
                    self.movieRate.append(String(format:"%.1f", movie["vote_average"].doubleValue))
                    for item in movie["genre_ids"].arrayValue {
                        self.movieGenreId.append(item.intValue)
                    }
                    // 각 영화마다의 아이디를 넣어 배우를 찾는 함수 실행 완료
                    self.tmdb_person(id: movie["id"].stringValue)
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
                
                var actor : String = ""
                for actornames in json["cast"].arrayValue{
//                    print(actornames["name"].stringValue)
                    actor += actornames["name"].stringValue
                    actor += ", "
//                    self.actorName.append(actornames["name"].stringValue)
                }
                self.actorName.append(actor)
                print("배우 이름 : \(self.actorName)")
                
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
    
}
