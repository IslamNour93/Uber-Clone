//
//  HomeController.swift
//  Uber
//
//  Created by Islam NourEldin on 27/09/2022.
//

import UIKit
import MapKit

private enum ActionButtonConfiguration{
    case showMenu
    case dismissActionView
    
    init(){
        self = .showMenu
    }
}

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    private var placemarksResults = [MKPlacemark]()
    
    private var viewModel=AuthenticationViewModel()
    
    private let mapView:MKMapView={
        let mv = MKMapView()
        #if targetEnvironment(simulator)
        mv.showsTraffic = false
        #endif
        return mv
    }()
    
    private let locationManager = CLLocationManager()
    
    private let inputLocationActivationView=InputLocationActivationView()
    
    private let inputLocationView = InputLocationView()
    
    private let tableView = UITableView()
    
    private final let inputLocationActivationViewHeight:CGFloat = 200
    
    private final let confirmTripViewHeight:CGFloat = 300
    
    private var homeViewModel=HomeViewModel()
    
    private let confirmTripView = ConfirmTripView()
    
    private var actionButtonConfiguration:ActionButtonConfiguration?
    
    private let actionButton:UIButton={
        let button = UIButton()
        button.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        signOut() 
        checkIfUserLoggedin()
        configureAuthorizationStatus()
        configureUI()
        getUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getDriversLocation()
    }

    //MARK: - Actions
    
    @objc func didTapActionButton(){
        switch actionButtonConfiguration{
        case .showMenu:
            print("")
        case .dismissActionView:
            print("")
            let annotations = mapView.annotations.filter {!$0.isKind(of: DriverAnnotation.self)}
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.inputLocationActivationView.alpha = 1
                self?.mapView.overlays.forEach({ overlay in
                    self?.mapView.removeOverlay(overlay)
                })
                self?.customizeActionButton(actionButtonConfig: .showMenu)
            }
            presentCofirmTripView(shouldShow:false)
            mapView.removeAnnotations(annotations)
            
        case .none:
            print("")
        }
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
    
    private func getDriversLocation(){
        guard let location = locationManager.location else {
            return
        }
        
        homeViewModel.fetchDrivers(location: location) { [weak self] driver in
            
            guard let driver = driver, let strongSelf = self else {
                return
            }
            let coordinate = driver.location?.coordinate
            let driverAnnotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate!)
            
            var driverIsVisible:Bool{
                return strongSelf.mapView.annotations.contains(where: { annotation -> Bool in
                    guard let driverAnnotation = annotation as? DriverAnnotation else {return false}
                    if driverAnnotation.uid == driver.uid{
                        driverAnnotation.updateDriverAnnotation(coordinate: coordinate!)
                        return true
                    }
                    return false
                })
            }
            
            if !driverIsVisible{
                self?.mapView.addAnnotation(driverAnnotation)
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
        configureConfirmTripView()
        
        view.addSubview(actionButton)
        actionButton.anchor(top:view.safeAreaLayoutGuide.topAnchor,left: view.leftAnchor,paddingTop: 16,paddingLeft: 16,width: 30,height: 30)
        
        view.addSubview(inputLocationActivationView)
        inputLocationActivationView.anchor(top:actionButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 32,paddingRight: 32,height: 50)
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
        mapView.delegate = self
    }
    
    private func configureTableView(){
        
        view.addSubview(tableView)
        tableView.rowHeight = 60
        let height = view.frame.height-inputLocationActivationViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationsCell.self, forCellReuseIdentifier: LocationsCell.identifier)
        
    }
    
    private func configureConfirmTripView(){
        view.addSubview(confirmTripView)
        confirmTripView.delegate = self
        confirmTripView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: confirmTripViewHeight)
    }
    
    private func presentCofirmTripView(shouldShow:Bool,destination:MKPlacemark?=nil){
        if shouldShow{
            confirmTripView.frame = CGRect(x: 0, y: view.frame.height-confirmTripViewHeight, width: view.frame.width, height: confirmTripViewHeight)
            if let destination = destination {
                confirmTripView.selectedPlacemark = destination
            }
        }else{
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let self = self else {return}
                self.confirmTripView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.confirmTripViewHeight)
            }
        }
    }
    
    private func dismissInputView(completion:((Bool)->Void)? = nil){
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.inputLocationView.alpha = 0
            self?.tableView.frame.origin.y = (self?.view.frame.height)!
            UIView.animate(withDuration: 0.5, animations: {
                [weak self] in
                self?.inputLocationActivationView.alpha = 1
            }, completion: completion)
        }
    }
    
    private func customizeActionButton(actionButtonConfig:ActionButtonConfiguration){
        switch actionButtonConfig {
        case .showMenu:
            actionButton.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfiguration = .showMenu
        case .dismissActionView:
            actionButton.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
            actionButtonConfiguration = .dismissActionView
            inputLocationActivationView.alpha = 0
        }
    }
    
    private func generateTripLine(toDestination destination: MKMapItem){
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = destination
        request.transportType = .automobile
        
        let directionRequest = MKDirections(request: request)
        
        directionRequest.calculate { response, error in
            if let error = error{
                print("Can't find specific route:\(error.localizedDescription)")
            }
            guard let response = response else {return}
            
            for route in response.routes{
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            
        }
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

//MARK: - LocationInputActivationViewDelegate

extension HomeController:LocationInputActivationViewDelegate{
    func presentLocationInputView() {
        inputLocationActivationView.alpha = 0
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.inputLocationView.alpha = 1
            self?.tableView.frame.origin.y = (self?.inputLocationView.frame.height)!
        }
    }
}

//MARK: - SearchFunctions

private extension HomeController{
    private func searchBy(naturalLanguageQuery:String,completion:@escaping([MKPlacemark])->()){
        var results = [MKPlacemark]()
        
        let request = MKLocalSearch.Request()
        request.region = mapView.region
        request.naturalLanguageQuery = naturalLanguageQuery
        
        let search = MKLocalSearch(request: request)
        
        search.start { localSearch, error in
            localSearch?.mapItems.forEach({ item in
                results.append(item.placemark)
            })
            completion(results)
        }
    }
}

//MARK: - InputLocationViewDelegate

extension HomeController:InputLocationViewDelegate{
    func excuteSearch(query: String) {
        searchBy(naturalLanguageQuery: query) { [weak self] results in
            guard let strongSelf = self else{return}
            strongSelf.placemarksResults = results
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    func dismissInputLocationView() {
        dismissInputView { _ in
            
        }
    }
}
// MARK: - MKMapViewDelegate

extension HomeController:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? DriverAnnotation{
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: DriverAnnotation.identifier)
            annotationView.image = UIImage(named: "driverAnnotation")
            return annotationView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let overlay =  overlay as? MKPolyline  {
               let render = MKPolylineRenderer(overlay: overlay)
                render.strokeColor = .blueTintColor
                render.lineWidth = 3
            return render
        }
        fatalError("Polyline Renderer could not be initialized")
    }
}

//MARK: - ConfirmTripDelegate

extension HomeController:ConfirmTripDelegate{
    func confirmTrip(_ confirmTripView: ConfirmTripView) {
        guard let pickupLocation = mapView.userLocation.location?.coordinate,let destination = confirmTripView.selectedPlacemark?.coordinate else{return}
        
        homeViewModel.uploadTrip(pickupLocation: pickupLocation, destination: destination) { error, dataRef in
            if let error = error{
                print("DEBUG: can't upload a trip:\(error.localizedDescription)")
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension HomeController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Saved Location" : "Locations"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 2
        case 1:
           return placemarksResults.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationsCell.identifier, for: indexPath) as! LocationsCell
        switch indexPath.section{
        case 0:
            print("DEBUG: Cell in section 1")
        case 1:
            cell.placemark = placemarksResults[indexPath.row]
            return cell
        default:
            print("DEBUG: Cell defult case")
        }
        return LocationsCell()
    }
}

//MARK: - UITableViewDelegate

extension HomeController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            print("Saved Locations Section")
        case 1:
            let selectedPlace = placemarksResults[indexPath.row]
            let destination = MKMapItem(placemark: selectedPlace)
            generateTripLine(toDestination: destination)
            
            self.customizeActionButton(actionButtonConfig: .dismissActionView)
            dismissInputView { [weak self] _ in
                let annotation = MKPointAnnotation()
                annotation.coordinate = selectedPlace.coordinate
                self?.mapView.addAnnotation(annotation)
                self?.mapView.selectAnnotation(annotation, animated: true)
                print("Destination is:\(destination.placemark.coordinate),and annotation coordinates are:\(annotation.coordinate)")
                
                if let annotations = self?.mapView.annotations.filter({!$0.isKind(of: DriverAnnotation.self)}){
                    self?.mapView.showAnnotations(annotations, animated: true)}
                
                self?.presentCofirmTripView(shouldShow: true, destination: selectedPlace)
            }
        default:
            print("DEBUG: Did select Default case ")
        }
    }
}
