//
//  WeatherViewController.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {
    
    @IBOutlet var lb_weatherInfos: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeather()
        designLabel(label: lb_weatherInfos)
    }
    
    func designLabel(label: [UILabel]) {
        for label in label {
            label.layer.borderWidth = 2
            label.layer.borderColor = UIColor.systemIndigo.cgColor
            label.layer.cornerRadius = 8
            label.backgroundColor = .white
        }
    }
    
    func loadWeather() {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=37.517829&lon=126.886270&appid=\(APIKey.weatherKey)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // print("JSON: \(json)")
                
                // 습도
                self.lb_weatherInfos[1].text = " 현재 습도 : \(json["main"]["humidity"].stringValue)% "
                // 온도
                self.lb_weatherInfos[2].text = " 현재 온도 : \(json["main"]["temp"].intValue - 273)도 "
                // 바람세기
                self.lb_weatherInfos[3].text = " 바람 세기 : \(json["wind"]["speed"].stringValue)m/s "
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
