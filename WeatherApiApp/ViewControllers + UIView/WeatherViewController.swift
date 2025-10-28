//
//  ViewController.swift
//  WeatherApiApp
//
//  Created by Adrian Inculet on 24.10.2025.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 45, weight: .bold)
        return label
    }()
    
    lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    let mainView = MainUIView()
    var currentWeather: WeatherResponse?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupLocationManager()
    }
    
    override func viewDidLayoutSubviews() {
        mainView.layer.cornerRadius = 10
    }
    
    // MARK: - Fetching temperature and wind data from the API
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,wind_speed_10m"
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.presentError(title: "Error", message: "Network Error")
                }
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    self.presentError(title: "Error", message: "Could not fetch data")
                }
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(WeatherResponse.self, from: data)
                self.currentWeather = jsonResult
                let temp = Int(jsonResult.current.temperature2m.rounded())
                let wind = jsonResult.current.windSpeed10m.rounded()
                let apiTimeString = jsonResult.current.time
                let date = self.getDataFromApi(apiTimeString)
                let formatedTime = self.formatAPITime(apiTimeString, date: date)
                let iconImage = self.getWeatherIcon(for: temp)
                
                DispatchQueue.main.async {
                    if let weatherDate = date {
                        self.setBackgroundGradient(for: weatherDate)
                    }
                    self.mainView.weatherimageView.image = iconImage
                    self.mainView.temperatureLabel.text = "\(temp)°C"
                    self.mainView.windLabel.text = "\(wind) km/h"
                    self.dataLabel.text = formatedTime
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    /// This function changes the weatherImageView based on the temperature shown.
    func getWeatherIcon(for temperature: Int) -> UIImage {
        switch temperature {
        case ...0:
            return UIImage.snowy
        case 1..<15:
            return UIImage.cloud
        case 15..<25:
            return UIImage.cloudSunny
        case 25...:
            return UIImage.sunny
        default:
            return UIImage.init(systemName: "questionmark.circle")!
        }
    }
}

// MARK: - Background using CAGRADIENT
extension ViewController {
    
    /// This function is created for the daylight background of the app.
    func createSkyGradient(in view: UIView) {
        let whiteColor = UIColor.whiteColor.cgColor
        let blueColor = UIColor.blueColor.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blueColor, whiteColor]
        gradientLayer.startPoint = CGPoint(x: 0.65, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.65, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// This function is created for the night background of the app.
    func createNightGradient(in view: UIView) {
        let charcoalColor = UIColor.charcoalColor.cgColor
        let coolColor = UIColor.coolColor.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [coolColor, charcoalColor]
        gradientLayer.startPoint = CGPoint(x: 0.65, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.65, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// This function sets the background based on the hour.
    func setBackgroundGradient(for date: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        let isNight = (hour >= 20 || hour < 6)
        self.view.layer.sublayers?.filter( {$0 is CAGradientLayer}).forEach({ $0.removeFromSuperlayer()})
        
        if isNight {
            createNightGradient(in: view)
            cityLabel.textColor = .white
            dataLabel.textColor = .white
        } else {
            createSkyGradient(in: view)
            cityLabel.textColor = .black
            dataLabel.textColor = .black
        }
    }
    
}


//MARK: - UI layout
extension ViewController {
    func setupConstraints() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: mainView.topAnchor, constant: -15),
            
            dataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            dataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            mainView.heightAnchor.constraint(equalTo: mainView.widthAnchor),
            mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupUI() {
        view.addSubview(dataLabel)
        view.addSubview(cityLabel)
        view.addSubview(mainView)
    }
    
}

//MARK: - Convert longitude and latitude to city according to device location
extension ViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        manager.stopUpdatingLocation()
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        fetchCityName(latitude: latitude, longitude: longitude)
        fetchWeather(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
        self.cityLabel.text = "Unknown location"
        self.presentError(title: "Error", message: "Could not determine your location")
    }
    /// This function transform longitude si latitude into city name based on user's location.
    func fetchCityName(latitude: Double, longitude: Double) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let placemark = placemarks?.first {
                let cityName = placemark.locality ?? placemark.subLocality ?? "Unknown Location"
                self.cityLabel.text = cityName
            } else {
                self.cityLabel.text = "Uknown Location"
            }
        }
    }
}

//MARK: - Date time from API
extension ViewController {
    func formatAPITime(_ apiTimeString: String, date: Date?) -> String {
        guard let validDate = date else {
            return "Error getting the time from API."
        }
        let displayFormatter = DateFormatter()
        displayFormatter.timeZone = .current
        displayFormatter.dateFormat = "dd.MM.yyyy"
        return displayFormatter.string(from: validDate)
    }
    
    func getDataFromApi(_ apiTimeString: String) -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        inputFormatter.timeZone = TimeZone(identifier: "UTC")
        return inputFormatter.date(from: apiTimeString)
    }
}
