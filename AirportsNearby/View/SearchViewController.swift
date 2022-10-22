//
//  ViewController.swift
//  AirportsNearby
//
//  Created by Мария Хатунцева on 28.09.2022.
//


import UIKit
import SwiftUI
import Combine

class SearchViewController: UIViewController {
    
    private var storage: Set<AnyCancellable> = []
    private var viewModel = AirportsViewModel()
    private var airpotsModel = [AirportsModel]()
    private var searchableViewModel = [AirportsModel]()
    private var observer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private let defaultView = UIHostingController(rootView: DefaultContentView())
    
    private lazy var searchBarBackground: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "searchBackImage")
        imageView.image = image
        imageView.contentMode = .redraw
        return imageView
    }()
    
    private let searchTextField: UITextField = {
         let textField =  UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name:"Avenir Next", size: 14)
        textField.autocorrectionType = .no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocapitalizationType = .none
        textField.backgroundColor = .gray.withAlphaComponent(0.4)
        textField.attributedPlaceholder = NSAttributedString(
            string: "ПУНКТ НАЗНАЧЕНИЯ ...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
         return textField
     }()
    
    private var airportTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CityViewCell.self, forCellReuseIdentifier: "CityCell")
        tableView.delaysContentTouches = false
        tableView.backgroundColor = UIColor(named: "spaceBlue")
        tableView.alpha = 0
        return tableView
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBarBackground)
        view.addSubview(searchTextField)
        addChildren()
        view.addSubview(airportTableView)
        airportTableView.dataSource = self
        airportTableView.delegate = self
        setupConstraints()
        bindCity()
    }

    private func addChildren() {
    
        addChild(defaultView)
        defaultView.didMove(toParent: self)
        defaultView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(defaultView.view)

    }
    
    private func bindCity() {
        
        let textFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .map( {
                ($0.object as? UITextField)?.text
            })
        textFieldPublisher
            .receive(on: RunLoop.main)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.observer = self?.viewModel.fetchAirports()
                            .receive(on: DispatchQueue.main)
                            .eraseToAnyPublisher()
                            .sink(receiveCompletion: { completion in
                                   switch completion {
                                   case .finished:
                                       break
                                   case .failure(let error):
                                       print(error)
                                   }
                               }, receiveValue: { [weak self] value in
                                   self?.airpotsModel = value
                                   for model in self?.airpotsModel ?? [] {
                                       if model.city == self?.searchTextField.text && (model.name.contains("Airport") || model.type.contains("Airport")) {
                                           self?.searchableViewModel.append(model)
                                       } else if self?.searchTextField.text == "Moscow" && (model.city == "Podol'sk" || model.city == "Zelenograd" || model.city == "Lyubertsy") {
                                           self?.searchableViewModel.append(model)
                                       }
                                   }
                                   self?.updateViews()
                                   self?.airportTableView.reloadData()
                           })
        })
        .store(in: &cancellables)
    }
    
    private func updateViews() {
        if searchTextField.text?.isEmpty == true {
            airportTableView.alpha = 0
            searchableViewModel.removeAll()
        } else {
            airportTableView.alpha = 1
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            defaultView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -5),
            defaultView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5),
            defaultView.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            defaultView.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            
            searchBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarBackground.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarBackground.heightAnchor.constraint(equalToConstant: 180),
            
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchBarBackground.bottomAnchor, constant: -70),
            searchTextField.widthAnchor.constraint(equalToConstant: 330),
            searchTextField.heightAnchor.constraint(equalToConstant: 45),
            
            airportTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            airportTableView.topAnchor.constraint(equalTo: searchBarBackground.bottomAnchor),
            airportTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            airportTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}

extension SearchViewController: UITableViewDelegate {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchableViewModel.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = airportTableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath as IndexPath) as! CityViewCell
        let airportCell = searchableViewModel[indexPath.row]
        cell.configure(viewModel: airportCell)
        cell.backgroundColor = UIColor(named: "spaceBlue")
        return cell
    }
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
    }
}

extension SearchViewController: UITableViewDataSource {

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.airportTableView.deselectRow(at: indexPath, animated: true)

       let detailVC = DetailedViewController()
       let airportCell = searchableViewModel[indexPath.row]
        detailVC.viewModel = airportCell
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 30
        }
        present(detailVC, animated: true, completion: nil)
    }
}



