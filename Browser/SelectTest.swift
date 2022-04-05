//import SwiftUI
//
//struct MultipleSelectionRow: View {
//    var title: String
//    var isSelected: Bool
//    var action: () -> Void
//
//    var body: some View {
//        Button(action: self.action) {
//            HStack {
//                Text(self.title)
//                if self.isSelected {
//                    Spacer()
//                    Image(systemName: "checkmark")
//                }
//            }
//        }
//        .foregroundColor(.black)
//    }
//}
//
//struct SelectionDemo: View {
//    @State var items: [String] = ["Apples", "Oranges", "Bananas", "Pears", "Mangos", "Grapefruit"]
//    @State var selections: [String] = []
//    
//    var body: some View {
//        List {
//            ForEach(self.items, id: \.self) { item in
//                MultipleSelectionRow(title: item, isSelected: self.selections.contains(item)) {
//                    if self.selections.contains(item) {
//                        self.selections.removeAll(where: {
//                            $0 == item
//                        })
//                    }
//                    else {
//                        self.selections.append(item)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct SelectTest_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionDemo()
//    }
//}
