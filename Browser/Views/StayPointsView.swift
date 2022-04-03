import SwiftUI
import MapKit

struct StayPointsView: View {
    @ObservedObject var userData: UserData
    var locationManager = LocationManager()
    var latitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    var longitude: CLLocationDegrees {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    @State private var updateLocationTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020), latitudinalMeters: 750, longitudinalMeters: 750
    )
    var body: some View {
        Map(coordinateRegion: $region)
    }
}

struct StayPoints_Previews: PreviewProvider {
    static var previews: some View {
        StayPointsView(userData: UserData())
    }
}

//        NavigationView {
//            Form {
//                ForEach(userData.stayPoints.indices, id: \.self) { i in
//                    Section {
//                        Text("latitude: \(userData.stayPoints[i].point.latitude)")
//                        Text("longitude: \(userData.stayPoints[i].point.longtitude)")
//                        Text("leave time: \(userData.stayPoints[i].leaveTime)")
//                        Text("leave time: \(userData.stayPoints[i].leaveTime)")
//                    }
//                }
//            }
//            .navigationTitle("Stay Points")
//        }
