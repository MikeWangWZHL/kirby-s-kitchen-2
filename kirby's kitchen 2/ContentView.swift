//
//  ContentView.swift
//  kirby's kitchen 2
//
//  Created by zhenhailong wang on 1/2/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saving.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Saving.username, ascending: true),
        NSSortDescriptor(keyPath: \Saving.imageD, ascending: true),
        NSSortDescriptor(keyPath: \Saving.favo, ascending: false),
        NSSortDescriptor(keyPath: \Saving.descriptions, ascending: true)
    ]) var savings : FetchedResults<Saving>
    
    @State var image : Data = .init(count: 0)
    
    @State var showingAddView = false
    func removeInstance(at offsets: IndexSet){
        for index in offsets{
            let object = savings[index]
            self.moc.delete(object)
        }
    }

    var body: some View {
        NavigationView{
//           ScrollView(.vertical, showsIndicators: false){
            List{
                   ForEach(savings, id:\.self){ save in
                        VStack(alignment: .leading){
                            Image(uiImage: UIImage(data: save.imageD ?? self.image)!)
                                .resizable()
                                .frame(width: 320, height: 210)
                                .cornerRadius(15)
                            
                            HStack {
                                Text("\(save.descriptions ?? "")")
                                Spacer()
                                Button(action: {
                                    save.favo.toggle()
                                    try? self.moc.save()
                                }){
                                    Image(systemName: save.favo ? "heart.fill": "heart")
                                }
                            }
                            Text("\(save.username ?? "")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                   }
                   .onDelete(perform: removeInstance)
                   .padding()
                   .listRowBackground(Color.black)
            }.listStyle(InsetGroupedListStyle()).offset(x:-10)
            
//        }
            .navigationBarItems(trailing: Button(action:{
                self.showingAddView.toggle()
            }){
                Image(systemName: "plus")
            })
            .navigationBarTitle("Kirby's Secret Menu", displayMode: .inline)
        }
        .sheet(isPresented: self.$showingAddView){
            AddView().environment(\.managedObjectContext, self.moc)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 375, height: 1000)).environment(\.colorScheme, .dark)
    }
}
