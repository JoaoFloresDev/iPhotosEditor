import SwiftUI

struct PhotoEditView: View {
    init(image initImage: UIImage?) {
        guard let image = initImage else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0)) {
            PECtl.shared.setImage(image: image)
        }
    }
    
    @State private var showImagePicker = true
    @State private var pickImage: UIImage?
    @EnvironmentObject var shared: PECtl
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.myBackground
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                        Spacer()
                        if shared.previewImage != nil {
                            NavigationLink(destination: ExportView()) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.white)
                                    .imageScale(.large)
                                    .padding(.horizontal)
                                    .padding(.top, 8)
                            }
                        }
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .imageScale(.large)
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                    }
                    .zIndex(1)
                    .padding(.horizontal)
                    PhotoEditorView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .zIndex(0)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showImagePicker, onDismiss: self.loadImage) {
            ZStack {
                ImagePicker(image: self.$pickImage)
            }
        }
    }
    
    func loadImage() {
        print("Photo edit: pick image finish")
        guard let image = self.pickImage else {
            return
        }
        self.pickImage = nil
        print("Photo edit: pick then setImage")
        self.shared.setImage(image: image)
    }
}

struct PhotoEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoEditView(image: UIImage(named: "carem"))
                .background(Color(UIColor.systemBackground))
                .environment(\.colorScheme, .dark)
                .environmentObject(PECtl.shared)
        }
    }
}
