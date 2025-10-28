//
//  MainUIView.swift
//  WeatherApiApp
//
//  Created by Adrian Inculet on 27.10.2025.
//

import UIKit

class MainUIView: UIView {
    
    let mainView = UIView()
    
    lazy var weatherimageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage.cloudImage
        return image
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "27°C"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    lazy var windImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.windImage
        return imageView
    }()
    
    lazy var windLabel: UILabel = {
        let label = UILabel()
        label.text = "10 km/h"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .black
        return label
    }()

    //MARK: - View Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupMainView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UIView and SubView SETUP
    private func setupMainView() {
        addSubview(weatherimageView)
        addSubview(temperatureLabel)
        addSubview(windImageView)
        addSubview(windLabel)
    }
    
    private func setupConstraints() {
        weatherimageView.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        windImageView.translatesAutoresizingMaskIntoConstraints = false
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            weatherimageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            weatherimageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherimageView.heightAnchor.constraint(equalToConstant: 125),
            weatherimageView.widthAnchor.constraint(equalToConstant: 125),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: weatherimageView.bottomAnchor, constant: 0),
            
            windImageView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 15),
            windImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            windImageView.heightAnchor.constraint(equalToConstant: 125),
            windImageView.widthAnchor.constraint(equalToConstant: 125),
            
            windLabel.topAnchor.constraint(equalTo: windImageView.bottomAnchor, constant: 0),
            windLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
