//
//  CityViewCell.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 28.09.2022.
//

import UIKit

class CityViewCell: UITableViewCell {
    
    private lazy var backgroundCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "cellBackground")
        imageView.image = image
        imageView.contentMode = .redraw
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var airportLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = UIColor(named: "customYellow")
        return label
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "customYellow")
        label.layer.cornerRadius = 25
        label.layer.borderColor = UIColor(named: "customYellow")?.cgColor
        label.layer.borderWidth = 3
        label.textAlignment = .center
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        locationLabel.text = nil
        airportLabel.text = nil
        codeLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        
        addSubview(backgroundCell)
        backgroundCell.addSubview(locationLabel)
        backgroundCell.addSubview(airportLabel)
        backgroundCell.addSubview(codeLabel)
      
    }
    
    func configure(viewModel: AirportsModel) {
        self.locationLabel.text = "Страна: \(viewModel.country). Город: \(viewModel.city)"
        self.airportLabel.text = viewModel.name
        self.codeLabel.text = viewModel.code
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            airportLabel.topAnchor.constraint(equalTo: backgroundCell.topAnchor),
            airportLabel.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 15),
            airportLabel.widthAnchor.constraint(equalToConstant: 300),
            airportLabel.heightAnchor.constraint(equalToConstant: 30),
            
            locationLabel.bottomAnchor.constraint(equalTo: backgroundCell.bottomAnchor, constant: -8),
            locationLabel.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 15),
            locationLabel.widthAnchor.constraint(equalToConstant: 300),
            locationLabel.heightAnchor.constraint(equalToConstant: 15),
            
            codeLabel.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor, constant: 3),
            codeLabel.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -15),
            codeLabel.widthAnchor.constraint(equalToConstant: 50),
            codeLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


