//
//  ContentView.swift
//  SwiftUI SQLite
//
//  Created by DB-MBP-012 on 25/12/23.
//

import SwiftUI

struct ContentView: View {
    
    //Array of user model
    @State var userModel: [UserModel] = []
    //Check if the user is selected for edit
    @State var userSelected: Bool = false
    //id of selected user
    @State var selecteduserId: Int64 = 0
    
    var body: some View {
        //Create navigation view
        NavigationView {
            VStack {
                //Create link to add user
                HStack {
                    Spacer()
                    NavigationLink(destination: AddUserView(), label: {
                        Text("Add User")
                    })
                }
                
                //Navigation link to go to edit user page
                NavigationLink(destination: EditUserView(id: $selecteduserId), isActive: $userSelected) {
                    EmptyView()
                }
                
                //Create list view to show all user
                List(self.userModel) { (model) in
                    
                    //Show Name, Email & Age Horzontally
                    HStack {
                        Text(model.name)
                        Spacer()
                        Text(model.email)
                        Spacer()
                        Text("\(model.age)")
                        
                        //Button to edit user
                        Button(action: {
                            self.selecteduserId = model.id
                            self.userSelected = true
                        }, label: {
                            Text("Edit")
                                .foregroundColor(Color.blue)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        //Button to delete user
                        Button(action: {
                            //create db manager instance
                            let dbManager: DB_Manager = DB_Manager()
                            //call delete function
                            dbManager.deleteUser(idValue: model.id)
                            
                            //refersh users array
                            self.userModel = dbManager.getUsers()
                        }, label: {
                            Text("Delet")
                                .foregroundColor(.red)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                
            }.padding()
            //Load data is user model array
                .onAppear(perform: {
                    self.userModel = DB_Manager().getUsers()
                })
                .navigationBarTitle("Users")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
