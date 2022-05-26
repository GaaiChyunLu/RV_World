import SwiftUI

struct MappingSettingsView: View {
    @ObservedObject var userData: UserData
    var body: some View {
        Form {
            Section(content: {
                Stepper(value: $userData.selectedCityNum, in: 1 ... anchors.count) {
                    Text("Number of positions: \(userData.selectedCityNum)", tableName: "LocalizableWithVariable")
                }
            }, footer: {
                Text("Set the number of virtual positions. When you send a request with location, the browser will pop up the corresponding number of interfaces.")
            })
            
            Section(content: {
                ForEach(0 ..< anchors.count, id: \.self) { index in
                    HStack {
                        SelectState(cityIndex: index, selectedCityNum: self.userData.selectedCityNum)
                        Text(anchors[index].name)
                    }
                }
            }, header: {
                Text("Choose Anchors")
            })
        }
        .navigationBarTitle("Mapping Settings", displayMode: .inline)
    }
    
    func SelectState(cityIndex: Int, selectedCityNum: Int) -> some View {
        if cityIndex < selectedCityNum {
            return Image(systemName: "checkmark.circle.fill").font(.title2)
        } else {
            return Image(systemName: "circle").font(.title2)
        }
    }
}

struct SetKValueView_Previews: PreviewProvider {
    static var previews: some View {
        MappingSettingsView(userData: UserData())
    }
}
