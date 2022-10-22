//
//  DetailedViewController.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 28.09.2022.
//

import MapKit
import UIKit
import CoreLocation
import Combine

class DetailedViewController: UIViewController {
  
    var viewModel: AirportsModel?
    private var currentLocation: (lat: Double, lon: Double)?

    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private lazy var container: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor(named: "spaceBlue")
        stackView.layer.cornerRadius = 10
        stackView.addSubview(airportLabel)
        stackView.addSubview(distanceLabel)
        stackView.addSubview(locationLabel)
        stackView.addSubview(urlLabel)
        stackView.addSubview(phoneLabel)
        return stackView
    }()
    
    private lazy var airportLabel: UILabel = {
      let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 25)
        label.textAlignment = .center
        label.textColor = .systemPink
        label.numberOfLines = 0
        label.text = viewModel?.name
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
      let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textAlignment = .center
        label.textColor = .systemGray5
        let doubleStr = String(format: "%.2f", ceil(getDistance(airportLocation: (lat: Double(viewModel?.lat ?? ""), lon: Double(viewModel?.lon ?? "")), currentLocation: currentLocation ?? (55.75578600, 37.61763300))!) / 1000)
        label.text = doubleStr + " км"
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
      let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textAlignment = .center
        label.textColor = .systemGray5
        label.text = (viewModel?.city ?? "") + ", " + (viewModel?.country ?? "")
        return label
    }()
    
    private lazy var phoneLabel: UILabel = {
      let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textAlignment = .center
        label.textColor = .systemGray6
        label.text = viewModel?.phone
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
      let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textAlignment = .center
        label.textColor = .systemGray6
        label.text = viewModel?.url
        return label
    }()
    
    private lazy var directionIndicatorImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "directionIndicatorPic")
        imageView.image = image
        imageView.alpha = 0
        return imageView
    }()
    
    private lazy var addDirectionLabel: UILabel = {
      let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textAlignment = .center
        label.textColor = .systemPink
        label.text = "Проложить путь Джедая к этому пункту?"
        label.numberOfLines = 0
        label.backgroundColor = UIColor(named: "spaceBlue")
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.alpha = 0
        return label
    }()
    
    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Да", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.alpha = 0
        return button
    }()
    
    private lazy var noButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нет", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "spaceBlue")
        button.layer.cornerRadius = 10
        button.alpha = 0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
        view.addSubview(container)
        view.addSubview(directionIndicatorImage)
        view.addSubview(addDirectionLabel)
        view.addSubview(yesButton)
        view.addSubview(noButton)
        map.delegate = self
        let airportLocation = (Double(self.viewModel?.lat ?? ""), Double(self.viewModel?.lon ?? ""))
        addAirportPin(with: airportLocation)
        setupConstraints()
        noButton.addTarget(self, action: #selector(didTapNoButton), for: .touchUpInside)
        yesButton.addTarget(self, action: #selector(didTapYesButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        map.removeFromSuperview()
    }

    @objc private func didTapNoButton() {
        directionIndicatorImage.alpha = 0
        addDirectionLabel.alpha = 0
        yesButton.alpha = 0
        noButton.alpha = 0
    }
    
    @objc private func didTapYesButton() {
        didTapNoButton()
        LocationService.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        }
        guard let airportLat = Double(viewModel?.lat ?? ""),
              let aiportLon = Double(viewModel?.lon ?? "") else { return }
        let airportLocation = CLLocation(latitude: airportLat, longitude: aiportLon)
        let airportPin = MKPointAnnotation()
        let currentPin = MKPointAnnotation()
        airportPin.coordinate = airportLocation.coordinate
        map.setRegion(MKCoordinateRegion(center: currentPin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        map.setRegion(MKCoordinateRegion(center: airportLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        map.addAnnotations([airportPin, currentPin])
        
        let currentPoint = CLLocationCoordinate2D(latitude: UserSettings.shared.currentLat, longitude: UserSettings.shared.currentLon)
        let airportPoint = CLLocationCoordinate2D(latitude: Double(viewModel?.lat ?? "") ?? 0.0, longitude: Double(viewModel?.lon ?? "") ?? 0.0)

        let currentPlacemark = MKPlacemark(coordinate: currentPoint)
        let airportPlacemark = MKPlacemark(coordinate: airportPoint)
        
        let directionRequest = MKDirections.Request()
        
        directionRequest.source = MKMapItem(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: airportPlacemark)
        
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [map] (response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let route = response?.routes.first else { return }
            map.addOverlay(route.polyline, level: .aboveRoads)
            
            UIView.animate(withDuration: 1.5) { [map, route] in
                let mapRectangle = route.polyline.boundingMapRect
                let region = MKCoordinateRegion(mapRectangle)
                map.setRegion(region, animated: true)
                
            }
        }
    }
    
    private func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        map.addAnnotation(pin)
    }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            container.widthAnchor.constraint(equalToConstant: 280),
            container.heightAnchor.constraint(equalToConstant: 200),
            
            airportLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            airportLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            airportLabel.widthAnchor.constraint(equalToConstant: 250),
            airportLabel.heightAnchor.constraint(equalToConstant: 70),
            
            distanceLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            distanceLabel.topAnchor.constraint(equalTo: airportLabel.bottomAnchor, constant: 10),
            distanceLabel.widthAnchor.constraint(equalToConstant: 250),
            distanceLabel.heightAnchor.constraint(equalToConstant: 30),
            
            locationLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 10),
            locationLabel.widthAnchor.constraint(equalToConstant: 250),
            locationLabel.heightAnchor.constraint(equalToConstant: 30),
            
            phoneLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            phoneLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            phoneLabel.widthAnchor.constraint(equalToConstant: 250),
            phoneLabel.heightAnchor.constraint(equalToConstant: 12),
            
            urlLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            urlLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 2),
            urlLabel.widthAnchor.constraint(equalToConstant: 250),
            urlLabel.heightAnchor.constraint(equalToConstant: 12),
            
            directionIndicatorImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            directionIndicatorImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -135),
            directionIndicatorImage.widthAnchor.constraint(equalToConstant: 120),
            directionIndicatorImage.heightAnchor.constraint(equalToConstant: 130),
            
            addDirectionLabel.leadingAnchor.constraint(equalTo: directionIndicatorImage.trailingAnchor, constant: 10),
            addDirectionLabel.topAnchor.constraint(equalTo: directionIndicatorImage.topAnchor),
            addDirectionLabel.widthAnchor.constraint(equalToConstant: 200),
            addDirectionLabel.heightAnchor.constraint(equalToConstant: 130),
            
            yesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            yesButton.topAnchor.constraint(equalTo: directionIndicatorImage.bottomAnchor, constant: 10),
            yesButton.widthAnchor.constraint(equalToConstant: 80),
            yesButton.heightAnchor.constraint(equalToConstant: 30),
            
            noButton.leadingAnchor.constraint(equalTo: yesButton.trailingAnchor, constant: 10),
            noButton.topAnchor.constraint(equalTo: yesButton.topAnchor),
            noButton.widthAnchor.constraint(equalToConstant: 80),
            noButton.heightAnchor.constraint(equalToConstant: 30)
        
        ])
    }
}
private extension DetailedViewController {
    
    func getDistance(airportLocation: (lat: Double?, lon: Double?), currentLocation: (lat: Double, lon: Double)) -> Double? {
        guard let airportLat = airportLocation.lat,
              let aiportLon = airportLocation.lon else { return nil }
        let currentUserLocation = CLLocation(latitude: currentLocation.lat, longitude: currentLocation.lon)
        let airportLocation = CLLocation(latitude: airportLat, longitude: aiportLon)
        
        return currentUserLocation.distance(from: airportLocation)
    }
    
    func addAirportPin(with airportLocation: (lat: Double?, lon: Double?)) {
        guard let airportLat = airportLocation.lat,
              let aiportLon = airportLocation.lon else { return }
        let airportLocation = CLLocation(latitude: airportLat, longitude: aiportLon)
        let pin = MKPointAnnotation()
        pin.coordinate = airportLocation.coordinate
        map.setRegion(MKCoordinateRegion(center: airportLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)), animated: true)
        map.addAnnotation(pin)
    }
}

extension DetailedViewController: MKMapViewDelegate {

   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
       directionIndicatorImage.alpha = 1
       addDirectionLabel.alpha = 1
       yesButton.alpha = 1
       noButton.alpha = 1
   }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                
                if overlay is MKPolyline {
                    let render = MKPolylineRenderer(overlay: overlay)
                    render.strokeColor = .systemPink
                    render.lineWidth = 2
                    return render
                } else if overlay is MKPolygon {
                    let render = MKPolygonRenderer(overlay: overlay as! MKPolygon)
                    render.strokeColor = .red
                    render.fillColor = UIColor.black.withAlphaComponent(0.5)
                    render.lineWidth = 1.0
                    return render
                }
                return  MKOverlayRenderer()
            }
}
