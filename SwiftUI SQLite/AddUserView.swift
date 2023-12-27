//
//  AddUserView.swift
//  SwiftUI SQLite
//
//  Created by DB-MBP-012 on 25/12/23.
//

import SwiftUI

struct AddUserView: View {
    
    //Create variable to store user input values
    @State var name: String = ""
    @State var email: String = ""
    @State var age: String = ""
    
    //To go back on home screen when useer is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            //Create Name field
            TextField("Enter Name", text: $name)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
            
            //Create Email field
            TextField("Enter Email", text: $email)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            //Create Age field
            TextField("Enter Age", text: $age)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
            
            //Button to add user
            Button(action: {
                //Call func to add row in SQLite db
                DB_Manager().addUser(nameValue: self.name, emailValue: self.email, ageValue: Int64(self.age) ?? 0)
                
                //Go back to home page
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Add User")
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }.padding()
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}
