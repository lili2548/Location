
import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!

    let presenter = MapPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupPresenterDelegate(self)
        presenter.callToGetPosition()
    }
    
    func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D){
       let annotation = MKPointAnnotation()
       annotation.coordinate = location
       annotation.title = "Aquí"
       annotation.subtitle = "ISS"
       let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
       map.setRegion(coordinateRegion, animated: true)
       map.addAnnotation(annotation)
    }
    
    private func cleanAnnotations(){
        map.removeAnnotations(self.map.annotations)
    }
}

extension MapViewController: MapPresenterDelegate{
    func onResultInfo(_ model: ISSModel) {
        cleanAnnotations()
        let location = CLLocation (latitude: CLLocationDegrees(model.latitude), longitude: CLLocationDegrees(model.longitude))
        setPinUsingMKPointAnnotation(location: location.coordinate)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            self.presenter.callToGetPosition()
        })
    }
}
