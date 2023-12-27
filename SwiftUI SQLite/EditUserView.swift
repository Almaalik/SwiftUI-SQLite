//
//  EditUserView.swift
//  SwiftUI SQLite
//
//  Created by DB-MBP-012 on 25/12/23.
//

import SwiftUI

struct EditUserView: View {
    
    //Id receving of user from previous screen
    @Binding var id: Int64
    //variables to store values from input field
    @State var name: String = ""
    @State var email: String = ""
    @State var age: String = ""
    
    //To go back previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            //Creaye name field
            TextField("Enter name", text: $name)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
            
            //Create email field
            TextField("Enter email", text: $email)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            //Create age field
            TextField("Enter age", text: $age)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(.numberPad)
                .disableAutocorrection(true)
            
            //Button to update user
            Button(action: {
                //Call func to updaterow in sqlite database
                DB_Manager().updateUser(idValue: self.id, nameValue: self.name, emailValue: self.email, ageValue: Int64(self.age) ?? 0)
                //go to home page
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Edit user")
            })
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }.padding()
        //populate user data when view loaded
            .onAppear(perform: {
                //get data from database
                let userModel: UserModel = DB_Manager().getUser(idValue: self.id)
                
                //Populate in text field
                self.name = userModel.name
                self.email = userModel.email
                self.age = String(userModel.age)
            })
    }
}

struct EditUserView_Previews: PreviewProvider {
    //When using @Binding, do this in preview provider
    @State static var id: Int64 = 0
    
    static var previews: some View {
        
        EditUserView(id: $id)
    }
}
