import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    @Binding var pois: [UserDataPOI]
    
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = false
        
        var avgLatitude: Double = 0
        var avgLongitude: Double = 0
        for poi in pois {
            avgLatitude += poi.point.latitude
            avgLongitude += poi.point.longitude
        }
        avgLatitude /= Double(pois.count)
        avgLongitude /= Double(pois.count)
        
        let location = CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        for poi in pois {
            let pinCoordinate = CLLocationCoordinate2DMake(poi.point.latitude, poi.point.longitude)
            let pin = MKPointAnnotation()
            pin.coordinate = pinCoordinate
            pin.title = poi.typeCode
            
            uiView.addAnnotation(pin)
        }
        
        uiView.setRegion(uiView.regionThatFits(region), animated: true)
    }
    
}

struct TrackMapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    var points: [DisplayPoint]
    
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = false
        
        var avgLatitude: Double = 0
        var avgLongitude: Double = 0
        for point in points {
            avgLatitude += point.latitude!
            avgLongitude += point.longitude!
        }
        avgLatitude /= Double(points.count)
        avgLongitude /= Double(points.count)
        
        let location = CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        for point in points {
            let pinCoordinate = CLLocationCoordinate2DMake(point.latitude!, point.longitude!)
            let pin = MKPointAnnotation()
            pin.coordinate = pinCoordinate
            
            uiView.addAnnotation(pin)
        }
        
        uiView.setRegion(uiView.regionThatFits(region), animated: true)
    }
}
