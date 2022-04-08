import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @Binding var latitude: CLLocationDegrees
    @Binding var longitude: CLLocationDegrees
    
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = false
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let pinCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let pin = MKPointAnnotation()
        pin.coordinate = pinCoordinate
        
        uiView.addAnnotation(pin)
        uiView.setRegion(uiView.regionThatFits(region), animated: true)
    }
    
}

struct TestView: View {
    
    var locationManager = LocationManager()
    
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    @State private var updateLocationTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var mapLatitude: CLLocationDegrees = 0
    @State private var mapLongitude: CLLocationDegrees = 0

    var body: some View {
        NavigationView {
            NavigationLink(destination: MapView(latitude: self.$mapLatitude, longitude: self.$mapLongitude)) {
                Text("showMap")
                }
                .onAppear() {
                    self.mapLatitude = self.latitude
                    self.mapLongitude = self.longitude
            }
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(latitude: 30.660897, longitude: 104.088089)
    }
}
