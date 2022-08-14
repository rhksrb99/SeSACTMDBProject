//
//  WeatherViewController.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/12.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON
import MapKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var lb_today: UILabel!
    @IBOutlet weak var lb_userLocation: UILabel!
    @IBOutlet var lb_weatherInfos: [UILabel]!
    @IBOutlet weak var img_weatherIcon: UIImageView!
    @IBOutlet weak var lb_comment: UILabel!
    @IBOutlet var buttons: [UIButton]!
    let comments = ["좋은 하루 보내세요!", "행복한 하루 보내세요!", "오늘은 좋을 일이 생길 것만 같아요!"]
    
    // 임의의 위치 지정
    // 추후 사용자의 위치를 받아와서 적용할 예정
    let location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
    var imageURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeather()
        lb_today.text = loadTime()

//        designLabel(label: lb_today)
        for i in 0...lb_weatherInfos.count - 1{
            designLabel(label: lb_weatherInfos[i])
            designButton(btn: buttons[i])
        }
        designUI()
        convertToAddressWith(coordinate: location)
        
        buttons[0].addTarget(self, action: #selector(reloadLocation), for: .touchUpInside)
        
        lb_comment.text = comments.randomElement()
    }
    
    func designButton(btn: UIButton) {
        btn.tintColor = .white
        btn.backgroundColor = .clear
    }
    
    func designUI() {
        view.backgroundColor = .lightGray
    }
    
    func designLabel(label: UILabel) {
        label.text = ""
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 8
    }
    
    func loadTime() -> String{
        let format = DateFormatter()
        format.dateFormat = "MM월 dd일 HH시 mm분"
        let result = format.string(from: Date())
        print(result)
        return result
    }
    
    func loadWeather() {
        // 사용자의 위치에 대한 위, 경도를 받아와서 넣어줄 예정
        let url = "\(EndPoint.weatherURL)\(37.517829)&lon=\(126.886270)&appid=\(APIKey.weatherKey)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // print("JSON: \(json)")
                
                
                // 습도
                self.lb_weatherInfos[0].text = " 현재 습도는 \(json["main"]["humidity"].stringValue)% 입니다. "
                // 온도
                self.lb_weatherInfos[1].text = " 현재 온도는 \(json["main"]["temp"].intValue - 273)도 입니다. "
                // 바람세기
                self.lb_weatherInfos[2].text = " 바람 세기는 \(json["wind"]["speed"].stringValue)m/s 입니다. "
                // 날씨에 따른 아이콘
                for i in json["weather"].arrayValue{
                    self.imageURL = "\(EndPoint.weatherImageURL)\(i["icon"].stringValue)@2x.png"
                }
                self.img_weatherIcon.kf.setImage(with: URL(string: self.imageURL))
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func convertToAddressWith(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks?.first,
                  let dong = placemarks.subLocality,
                  let city = placemarks.locality
            else { return }
            DispatchQueue.main.async {
            self?.lb_userLocation.text = "\(city), \(dong)"
            }
        }
    }
    
    @objc func reloadLocation() {
        lb_userLocation.text = "위치를 불러오고 있습니다."
        lb_weatherInfos.removeAll()
        loadWeather()
    }
    
}
