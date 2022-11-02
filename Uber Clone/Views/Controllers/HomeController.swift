//
//  HomeController.swift
//  Uber
//
//  Created by Islam NourEldin on 27/09/2022.
//

import UIKit
import MapKit

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel=AuthenticationViewModel()
    
    private let mapView:MKMapView={
        let mv = MKMapView()
        return mv
    }()
    
    private let locationManager = CLLocationManager()
    
    private let inputLocationActivationView=InputLocationActivationView()
    
    private let inputLocationView = InputLocationView()
    
    private let tableView = UITableView()
    
    private final let inputLocationActivationViewHeight:CGFloat = 200
    
    private var homeViewModel=HomeViewModel()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signOut()
        checkIfUserLoggedin()
        configureUI()
        configureAuthorizationStatus()
        getUserData()
    }

    //MARK: - Helpers
    
    private func checkIfUserLoggedin(){
        viewModel.checkIfUserIsLogged {[weak self] in
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: false, completion: nil)
        }
    }
    
    private func getUserData(){
        homeViewModel.fetchUser {[weak self] user in
            self?.homeViewModel.user = user
            DispatchQueue.main.async {
                self?.inputLocationView.titleLabel.text = self?.homeViewModel.fullname
            }
        }
    }
    
    private func signOut(){
        viewModel.signOut {[weak self] in
            self?.checkIfUserLoggedin()
            print("Successfully signed user out...")
        }
    }
    
    private func configureUI(){
        configureMapView()
        
        view.addSubview(inputLocationActivationView)
        inputLocationActivationView.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 32,paddingLeft: 32,paddingRight: 32,height: 50)
        inputLocationActivationView.alpha = 0
        inputLocationActivationView.delegate = self
        UIView.animate(withDuration: 3) {[weak self] in
            self?.inputLocationActivationView.alpha = 1
        }
        
        view.addSubview(inputLocationView)
        inputLocationView.anchor(top:view.topAnchor,left: view.leftAnchor,right: view.rightAnchor,height: inputLocationActivationViewHeight)
        inputLocationView.delegate = self
        inputLocationView.alpha = 0
        
        configureTableView()
    }
    
    private func configureMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    private func configureTableView(){
        
        view.addSubview(tableView)
        let height = view.frame.height-inputLocationActivationViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationsCell.self, forCellReuseIdentifier: LocationsCell.identifier)
        
    }
}

    //MARK: - AuthenticationProtocol

extension HomeController:AuthenticationProtocol{
    func didCompleteSignup() {
        dismiss(animated: true, completion: nil)
    }
}

    //MARK: - LocationServices

extension HomeController:CLLocationManagerDelegate{
    
    func configureAuthorizationStatus(){
        locationManager.delegate = self
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted,.denied:
            print("DEBUG: Authorization is Denied.")
            break
        case .authorizedAlways:
            print("DEBUG: Authorization has been set to Always.")
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        @unknown default:
            print("DEBUG: Default")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
    }
}

extension HomeController:LocationInputActivationViewDelegate{
    func presentLocationInputView() {
        inputLocationActivationView.alpha = 0
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.inputLocationView.alpha = 1
            self?.tableView.frame.origin.y = (self?.inputLocationView.frame.height)!
        }
    }
}

extension HomeController:InputLocationViewDelegate{
    func dismissInputLocationView() {
        inputLocationView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.inputLocationActivationView.alpha = 1
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.tableView.frame.origin.y = (self?.view.frame.height)!
            }
        }
    }
}

extension HomeController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationsCell.identifier, for: indexPath) as! LocationsCell
        return cell
    }
    
}

extension HomeController:UITableViewDelegate{
    
}
