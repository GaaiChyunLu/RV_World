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
        
        uiView.setRegion(uiView.regionThatFits(region), animated: true)
    }
    
}

struct TestView: View {
    
    var locationManager = LocationManager()
    
    @State private var updateLocationTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var latitude: CLLocationDegrees = 0
    @State private var longitude: CLLocationDegrees = 0

    var body: some View {
        NavigationView {
            NavigationLink(destination: MapView(latitude: self.$latitude, longitude: self.$longitude)) {
                Text("showMap")
                }
                .onAppear() {
                    self.latitude = locationManager.lastLocation?.coordinate.latitude ?? 0
                    self.longitude = locationManager.lastLocation?.coordinate.longitude ?? 0
            }
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
