//
//  AddView.swift
//  kirby's kitchen 2
//
//  Created by zhenhailong wang on 1/2/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var image: Data = .init(count: 0)
    
    @State private var name = ""
    @State private var description = ""
    
    @State var showingAddView = false
    var body: some View {
        
        NavigationView {
            VStack{
                if self.image.count != 0 {
                    Button(action:{
                            self.showingAddView.toggle()
                    }){
                        Image(uiImage: UIImage(data: self.image)!)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 200, height: 150)
                            .cornerRadius(10)
                            .padding()
                    }
                } else {
                    Button(action: {
                        self.showingAddView.toggle()
                    }){
                        Image(systemName: "photo.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                VStack{
                    
                    HStack {
                        Spacer()
                        TextField("food name", text:self.$name)
                            .padding()
                            .background(Color(red: 50/255, green: 50/255, blue: 50/255))
                            .cornerRadius(15)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        TextField("description", text:self.$description)
                            .padding()
                            //                    .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                            .background(Color(red: 50/255, green: 50/255, blue: 50/255))
                            .cornerRadius(15)
                        Spacer()
                    }
                    
                }.padding()
                
                Button(action:{
                    let add = Saving(context: self.moc)
                    add.username = self.name
                    add.descriptions = self.description
                    add.imageD = self.image
                    
                    try? self.moc.save()
                    self.presentationMode.wrappedValue.dismiss()
                    
                    self.name = ""
                    self.description = ""
                }){
                    Text("Add")
                        .fixedSize()
                        .frame(width: 150, height: 50)
                        .foregroundColor((self.name.count > 0 && self.description.count > 0 && self.image.count > 0) ? Color.white : Color.black)
                        .background((self.name.count > 0 && self.description.count > 0 && self.image.count > 0) ? Color.blue : Color(red: 50/255, green: 50/255, blue: 50/255))
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Add New Recipe",displayMode: .inline)
            .navigationBarItems(trailing: Button(action:{self.presentationMode.wrappedValue.dismiss()}){Text("Cancel")})
        }
        .sheet(isPresented: self.$showingAddView, content: {
            ImagePicker(show: self.$showingAddView, image: self.$image)})
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView().previewLayout(.fixed(width: 375, height: 1000)).environment(\.colorScheme, .dark)
    }
}
