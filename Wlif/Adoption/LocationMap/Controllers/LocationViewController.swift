//
//  LocationViewController.swift
//  Fleen
//
//  Created by Mina Eid on 22/01/2024.
//

import UIKit
import MapKit
import CoreLocation
import MOLH

class LocationViewController: UIViewController , CLLocationManagerDelegate  ,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var keepLocationLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var additionalLabel: UILabel!
    @IBOutlet weak var optionalLabel: UILabel!
    @IBOutlet weak var additionalTextField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var additionalView: UIView!
    @IBOutlet weak var textView: UIView!
    
    var locationManager = CLLocationManager()
    var previousLoc: CLLocation?
    var viewModel = LocationViewModel()
    var spinnerView: UIView?
    
    var saved: Int = 0 {
        didSet {
            updateViewsVisibility()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLocationManager()
        checkLocationServiceAuthorization()
        
    }
    
    private func setupUI() {
        setNavigation()
        setFonts()
        hideViews()
        checkLanguage()
    }
    
    func checkLanguage(){
        let isArabic = MOLHLanguage.currentAppleLanguage() == "ar"
        let alignment: NSTextAlignment = isArabic ? .right : .left
        
        locationTitleLabel.textAlignment = alignment
        keepLocationLabel.textAlignment = alignment
        additionalLabel.textAlignment = alignment
        optionalLabel.textAlignment = alignment
        additionalTextField.textAlignment = alignment
    }
    
    private func setNavigation(){
        navigationController?.navigationBar.tintColor = .black
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setFonts(){
        
        locationTitleLabel.font = UIFont(name: "DMSans-Bold", size: 22)
        keepLocationLabel.font = UIFont(name: "DMSans18pt-Regular", size: 14)
        additionalLabel.font = UIFont(name: "DMSans-Bold", size: 14)
        optionalLabel.font = UIFont(name: "DMSans18pt-Regular", size: 12)
        additionalTextField.font = UIFont(name: "DMSans18pt-Regular", size: 12)
        let attributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: UIFont(name: "DMSans18pt-Regular", size: 14)!]
        segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        confirmBtn.titleLabel?.font = UIFont(name: "DMSans18pt-Regular", size: 16)
        checkBtn.setTitle("", for: .normal)
        
        keepLocationLabel.text = "Keep the address to use later" .localized
        segmentedControl.setTitle("Home" .localized, forSegmentAt: 0)
        segmentedControl.setTitle("rest" .localized, forSegmentAt: 1)
        segmentedControl.setTitle("shop" .localized, forSegmentAt: 2)
        additionalLabel.text = "Additional details".localized
        optionalLabel.text = "Optional".localized
        additionalTextField.placeholder = "Additional details".localized
        confirmBtn.setTitle("Confirm Location".localized, for: .normal)
        
    }
    
    private func hideViews(){
        segmentView.isHidden = true
        additionalView.isHidden = true
        textView.isHidden = true
        
    }
    
    private func showViews(){
        segmentView.isHidden = false
        additionalView.isHidden = false
        textView.isHidden = false
        
    }
    
    private func updateViewsVisibility() {
        let image = saved == 1 ? UIImage(named: "true") : UIImage(named: "Rectangle")
        checkBtn.setImage(image, for: .normal)
        saved == 1 ? showViews() : hideViews()
    }
       
    // MARK: - Location Services
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        mapView.delegate = self
    }
    
    private func checkLocationServiceAuthorization() {
        isLocationServiceEnabled { isEnabled in
            if isEnabled {
                print("Location services are enabled.")
                self.checkAuthorization()
            } else {
                print("Location services are not enabled.")
                self.showAlert(msg: "Please allow location".localized)
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
       
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            zoomToUserLocation(location: location)
            viewModel.lat = Float(location.coordinate.latitude)
            viewModel.lon = Float(location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        if previousLoc == nil || previousLoc!.distance(from: newLocation) > 10 {
            getLocationInfo(location: newLocation)
        }
        
    }
    
    // MARK: - Helper Methods
    
    func showAlert(msg : String){
        let alert = UIAlertController(title: "Alert".localized, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close".localized, style: .default))
        alert.addAction(UIAlertAction(title: "Settings".localized, style: .default, handler: { action in
            
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        
        present(alert, animated: true)
    }
    
    func zoomToUserLocation(location : CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
    }
    
    func getLocationInfo(location : CLLocation){
        
        previousLoc = location
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { places, error in
            guard let place = places?.first , error == nil else { return }
            self.viewModel.default_address = "\(place.name.orEmpty), \(place.locality.orEmpty), \(place.administrativeArea.orEmpty), \(place.country.orEmpty)"
            self.locationTitleLabel.text = "\(place.name!) \(place.country!)"
        }
    }
        
    func isLocationServiceEnabled(completion: @escaping (Bool) -> Void) {

        // Check if the service is enabled asynchronously
        DispatchQueue.global(qos: .background).async {
            let isEnabled = CLLocationManager.locationServicesEnabled()

            // Return the result on the main thread
            DispatchQueue.main.async {
                completion(isEnabled)
            }
        }
    }
    
    func checkAuthorization(){
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            case .denied:
                showAlert(msg: "Please allow the location".localized)
                break
            case .restricted:
                break
            @unknown default:
                print("default..")
                break
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            case .denied:
                showAlert(msg: "Please allow the location".localized)
            default:
                break
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch locationManager.authorizationStatus {
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            case .denied:
                showAlert(msg: "Please allow the location")
                break
            case .restricted:
                showAlert(msg: "Authorization restricted")
                break
            @unknown default:
                print("default..")
                break
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            case .denied:
                showAlert(msg: "Please allow the location")
            default:
                break
            }
        }
    }
    
    func bindingViewModel(){
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self,
                  let isLoading = isLoading else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingIndicator()
                } else {
                    self.hideLoadingIndicator()
                }
            }
        }
    }
    
    func showLoadingIndicator() {
        spinnerView = displaySpinner(onView: self.view)
    }
    
    func hideLoadingIndicator() {
        if let sv = spinnerView{
            removeSpinner(spinner: sv)
        }
    }
    

    @IBAction func didTapCheckBtn(_ sender: Any) {
        saved = saved == 0 ? 1 : 0
    }
    
    @IBAction func didTapSegementControl(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        viewModel.address_type = selectedIndex + 1
    }
    


    @IBAction func didTapConfirmBtn(_ sender: Any) {
        
        isLocationServiceEnabled { [weak self] isEnabled in
            guard let self = self else { return }
            
            if isEnabled {
                
                self.viewModel.address = self.additionalTextField.text
                bindingViewModel()
                self.sendLocationToServer()
                
            } else {
                self.showAlert(msg: "Location services are not enabled.".localized)
            }
        }
    }
    
    private func sendLocationToServer() {
        
        viewModel.sendLocation(viewController: self,
                               lat: viewModel.lat ?? 0,
                               lon: viewModel.lon ?? 0,
                               saved: saved ,
                               address_type: viewModel.address_type ?? 1,
                               address: viewModel.address ?? "",
                               default_address: viewModel.default_address ?? "",
                               successCallback: { [weak self] in
            guard let self = self else { return }
            
            if let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        })
    }
}
