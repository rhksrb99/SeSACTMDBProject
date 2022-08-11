//
//  TMDBAPIManager.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/11.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    var stillPath:[String] = []
    
    var movieData:[String] = []
    
    let movieURL = ""
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func callRequest(query: Int, completionHandler: @escaping([String]) -> () ) {
        print(#function)
        
        let url = "https://api.themoviedb.org/3/movie/\(query)/recommendations?api_key=\(APIKey.tmdbKey)&language=en-US&page=1"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let value = json["episodes"].arrayValue.map{ $0["still_path"].stringValue }
                
                completionHandler(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        var posterList: [[String]] = []
        
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)
            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadMovie(query: Int, completionHandler: @escaping([String]) -> () ) {
        
        let url = "https://api.themoviedb.org/3/tv/\(query)/recommendations?api_key=\(APIKey.tmdbKey)&language=en-US&page=1"
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                
                let value = json["results"].arrayValue.map{ $0["poster_path"].stringValue }
                
                completionHandler(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestPosterImage(completionHandler: @escaping ([[String]]) -> ()) {
        var posterImageList: [[String]] = []
        
        TMDBAPIManager.shared.loadMovie(query: tvList[0].1) { value in
            posterImageList.append(value)
            TMDBAPIManager.shared.loadMovie(query: self.tvList[1].1) { value in
                posterImageList.append(value)
                TMDBAPIManager.shared.loadMovie(query: self.tvList[2].1) { value in
                    posterImageList.append(value)
                    TMDBAPIManager.shared.loadMovie(query: self.tvList[3].1) { value in
                        posterImageList.append(value)
                        TMDBAPIManager.shared.loadMovie(query: self.tvList[4].1) { value in
                            posterImageList.append(value)
                            TMDBAPIManager.shared.loadMovie(query: self.tvList[5].1) { value in
                                posterImageList.append(value)
                                TMDBAPIManager.shared.loadMovie(query: self.tvList[6].1) { value in
                                    posterImageList.append(value)
                                    TMDBAPIManager.shared.loadMovie(query: self.tvList[7].1) { value in
                                        posterImageList.append(value)
                                        completionHandler(posterImageList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
