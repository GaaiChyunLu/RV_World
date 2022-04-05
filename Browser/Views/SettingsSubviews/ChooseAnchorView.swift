import SwiftUI

struct ChooseAnchorView: View {
    @ObservedObject var userData: UserData
    
    @State private var selection = Set<String>()
    @State private var isEditMode: EditMode = .active
    
    let items = [
        "Item 1",
        "Item 2",
        "Item 3",
        "Item 4"
    ]
    
    var body: some View {
        NavigationView {
            List(items, id: \.self, selection: $selection) { name in
                Text(name)
            }
            .environment(\.editMode, self.$isEditMode)
            .navigationTitle("Anchor Test")
        }
    }
    
}

struct StayPoints_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAnchorView(userData: UserData())
    }
}
