//
//  MapViewController.swift
//  SeSACTMDBProject
//
//  Created by 박관규 on 2022/08/11.
//

import UIKit

// 순서 1번. 임포트
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    // 순서 2번. 상수를 선언하며 위임
    let locationManager = CLLocationManager()
    let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
    
    let theaterList = TheaterList().mapAnnotations
    
    
    var theater: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 순서 3번. delegate 설정
        locationManager.delegate = self
        setNavigation()
        
        
    }
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setNavigation() {
        self.navigationItem.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterItem))
    }
    
    @objc func filterItem() {
        print(#function)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "메가박스", style: .default, handler: { action in
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.getTheater(listnum: 2)
            self.getTheater(listnum: 3)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "롯데시네마", style: .default, handler: { action in
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.getTheater(listnum: 0)
            self.getTheater(listnum: 1)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "CGV", style: .default, handler: { action in
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.getTheater(listnum: 4)
            self.getTheater(listnum: 5)
        }))
        actionSheet.addAction(UIAlertAction(title: "전체보기", style: .default, handler: { action in
            for i in 0...5 {
                self.getTheater(listnum: i)   
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    
    func getTheater(listnum:Int) {
        self.theater.longitude = self.theaterList[listnum].longitude
        self.theater.latitude = self.theaterList[listnum].latitude
        
        self.setResignAnnotation(center: self.theater, title: self.theaterList[listnum].location)
    }
    
    
    func setResignAnnotation(center: CLLocationCoordinate2D, title:String ) {
        // 지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 20000, longitudinalMeters: 20000)
        
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
//        let newCenter = defaultLocation()
        
//        if center.longitude == newCenter.longitude {
            annotation.title = title
//        }else {
//            annotation.title = "현위치"
//        }
        mapView.addAnnotation(annotation)
    }
    
//    func defaultLocation() {
//    }-> CLLocationCoordinate2D{
//        // 지도의 중심이 될 경.위도 기본설정 ( 캠퍼스가 된다. )
//        // 37.517829, 126.886270
//
//        return center
//    }
    
}

// 위치 관련된 User Defined 메서드
extension MapViewController {
    // 순서 7번. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    // 위치 서비스가 켜져있다면 권한을 요청하고, 위치 서비스가 꺼져있다면 커스텀 얼럿으로 상황 알려주기.
    // CLAuthorizationStatus
    // - denied: 허용 안함 / 설정에서 추후에 거부 / 위치 서비스 중지 / 비행기 모드
    // - restricted: 앱 권한 자체가 없는 경우 / 자녀 보호 기능 같은걸로 아예 제한
    func checkUserDevice() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        }else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrent(locationManager.authorizationStatus)
        }
        
    }
    
    // 순서 8번. 사용자의 위치 권한 상태 확인
    // 사용자가 위치를 허용했는지, 거부했는지 아직 선택하지 않았는지 등을 확인
    // ( 단, 사전에 iOS 위치 서비스 활성화 여부를 꼭 확인해야한다. )
    func checkUserCurrent(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            setResignAnnotation(center: center, title: "SeSAC 영등포 캠퍼스")
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showLocationServiceAlert()
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            // 사용자가 위치 권한을 허용했다면
            // 업데이트 함수 실행
            locationManager.startUpdatingLocation()
        default:print("DEFAULT")
            
        }
    }
    
    func showLocationServiceAlert() {
        let locationAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            if let appSetting = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        locationAlert.addAction(cancel)
        locationAlert.addAction(goSetting)
        present(locationAlert, animated: true, completion: nil)
    }
    
    
    
}

// 순서 4번. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    
    // 순서 5번. 사용자의 위치를 정상적을 받아왔을 때 실행되는 코드
    // 옮겨진 위치를 업데이트 해준다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            setResignAnnotation(center: coordinate,title: "현위치")
        }
        // 무한으로 위치를 업데이트를 하기 때문에 위치를 정상적으로 업데이트 하면
        // 더이상 업데이트를 하지 안도록 하는 코드
        locationManager.stopUpdatingLocation()
        
    }
    
    // 순서 6번. 사용자의 위치를 정상적으로 받아오지 못했을 떄의 코드
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
    // 순서 9번. 사용자의 권한 상태가 바뀔 때를 알려주는 코드
    // iOS 14 이상
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDevice()
    }
    
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    // 사용자가 지도를 움직이다가 멈추게되면 해당 화면의 중앙의 위치를 호출하게 된다.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
    }
}
