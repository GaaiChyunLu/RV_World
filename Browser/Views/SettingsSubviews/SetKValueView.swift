import SwiftUI

struct SetKValueView: View {
    @ObservedObject var userData: UserData
    var body: some View {
        Form {
            Section(content: {
                Stepper(value: $userData.selectedCityNum, in: 1...5) {
                    Text("Number of positions: \(userData.selectedCityNum)", tableName: "LocalizableWithVariable")
                }
            }, footer: {
                Text("Set the number of virtual positions. When you send a request with location, the browser will pop up the corresponding number of interfaces.")
            })
        }
        .navigationBarTitle("Set K Value", displayMode: .inline)
    }
}

struct SetKValueView_Previews: PreviewProvider {
    static var previews: some View {
        SetKValueView(userData: UserData())
    }
}
