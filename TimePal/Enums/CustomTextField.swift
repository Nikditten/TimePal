import SwiftUI

struct CustomTextField: View {
    
    var label: String
    @Binding var value: String
    
    var keyboardType: UIKeyboardType

    init(label: String, value: Binding<String>, keyboardType: UIKeyboardType = .default) {
        self.label = label
        self._value = value
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(Color("Text"))
                .font(.footnote)
            TextField("", text: $value)
                .keyboardType(keyboardType)
                .padding(15)
                .padding(.trailing, 30)
                .background(Color("Background"))
                .cornerRadius(10)
                .foregroundColor(Color("Text"))
        }
    }
}
