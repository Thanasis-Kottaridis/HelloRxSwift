//
//  WeatherAppVC.swift
//  HelloRxSwift
//
//  Created by thanos kottaridis on 31/8/21.
//

import UIKit
import RxSwift
import RxCocoa

/**
 # OpenWeatherMap API
 
 - Username: thanoskott
 - email: thanasiskottaridis@yahoo.gr
 - pass: Test1234!
 - API key: ab8fe181c436403e2761afd68d4902ad
 
 **SOS** gia ta request theloume metrics oxi imperial
 */

class WeatherAppVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var cityNameTF: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    
    // MARK: - RxSwift properties
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpObservers()
    }
    
    
    /**
     We create a data binding using textField value
     - every time that text field text changes we got notified
     */
    private func setUpObservers() {
        //        self.cityNameTF.rx.value.subscribe(onNext: { city in
        //
        //            if let city = city {
        //                if city.count < 3 {
        //                    self.displayWeather(nil)
        //                } else {
        //                    self.fetchWeather(by: city)
        //                }
        //            }
        //        }).disposed(by: disposeBag)
        
        
        let textObservable = cityNameTF.rx.value
        let buttonObservable = searchButton.rx.tap
        let searchObserver = buttonObservable.withLatestFrom(textObservable)
        
        searchObserver.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] city in
                if let city = city {
                    if city.isEmpty {
                        self?.displayWeather(nil)
                    } else {
                        self?.fetchWeather(by: city)
                    }
                }
                
                self?.cityNameTF.resignFirstResponder()
            }).disposed(by: disposeBag)
    }
    
    private func fetchWeather(by city: String) {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded) else {
            return
        }
        
        let resource = Resource<WeatherResults>(url: url)
        let search = URLRequest.load(resource: resource)
            .observe(on: MainScheduler.instance)
            .catchAndReturn(WeatherResults(main: nil))

        // bind search results to labels
        search.map { weatherResult in
            return "\(weatherResult.main?.temp ?? 0.0)"
        }.bind(to: self.tempLbl.rx.text)
        .disposed(by: disposeBag)
        
        search.map { weatherResult in
            return "\(weatherResult.main?.humidity ?? 0.0)"
        }.bind(to: self.humidityLbl.rx.text)
        .disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            // 🥵 🥶 😎 🧐
            tempLbl.text = "\(weather.temp ?? 0)"
            humidityLbl.text = "\(weather.humidity ?? 0)"
        } else {
            tempLbl.text = "🧐"
            humidityLbl.text = "😎"
        }
    }
    
    @IBAction func didSearchTap(_ sender: Any) {
    }
}
