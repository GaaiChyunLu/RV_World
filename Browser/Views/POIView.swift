import SwiftUI
import MapKit
import CoreData

struct POIView: View {
    @ObservedObject var userData: UserData
    
    @State private var userPois = [UserDataPOI]()
    @State private var virtualPois = [UserDataPOI]()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    NavigationLink(destination: MapView(pois: $userPois), label: {
                        Text("Chengdu")
                    })
                    .onAppear {
                        self.userPois = [UserDataPOI]()
                        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
                        fetchRequest.fetchLimit = 10
                        fetchRequest.fetchOffset = 0
                        let predicate = NSPredicate(format: "isReal = 1", "")
                        fetchRequest.predicate = predicate
                        do {
                            let userProfiles = try self.viewContext.fetch(fetchRequest)
                            for userProfile in userProfiles {
                                let persistantPois = (userProfile.pois?.allObjects as? [POI])!.sorted(by: {return $0.id < $1.id})
                                for poi in persistantPois {
                                    self.userPois.append(UserDataPOI(poi: poi))
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }, header: {
                    Text("Real")
                })
                
                Section(content: {
                    NavigationLink(destination: MapView(pois: $virtualPois), label: {
                        Text("Beijing")
                    })
                    .onAppear() {
                        self.virtualPois = [UserDataPOI]()
                        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
                        fetchRequest.fetchLimit = 10
                        fetchRequest.fetchOffset = 0
                        let predicate = NSPredicate(format: "isReal = 0 || city = 'Beijing'", "")
                        fetchRequest.predicate = predicate
                        do {
                            let virtualProfiles = try self.viewContext.fetch(fetchRequest)
                            for virtualProfile in virtualProfiles {
                                let persistantPois = (virtualProfile.pois?.allObjects as? [POI])!.sorted(by: { return $0.id < $1.id })
                                for poi in persistantPois {
                                    self.virtualPois.append(UserDataPOI(poi: poi))
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                }, header: {
                    Text("Virtual")
                })
            }
            .navigationTitle("Mapping")
        }
    }
}


struct StayPointView_Previews: PreviewProvider {
    static var previews: some View {
        POIView(userData: UserData())
    }
}
