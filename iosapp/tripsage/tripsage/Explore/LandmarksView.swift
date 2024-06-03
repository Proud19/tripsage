import SwiftUI

struct LandmarksView: View {
    var landmark_images = ["exp-1", "exp-2", "exp-3", "exp-4"]

    var body: some View {
        VStack(spacing: 8) {
            // landmark images
            TabView {
                ForEach(landmark_images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2) // Adjust the height as needed
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .tabViewStyle(.page)

            // landmark details
            VStack {
                // first line
                HStack {
                    // landmark name
                    Text("Memorial Church").fontWeight(.semibold)
                    Spacer()
                    // distance away
                    Text("1 mile away")
                }
                // second line
                HStack {
                    // city / town name
                    Text("Stanford, CA").foregroundStyle(.gray)

                    // like button
                    Spacer()
                    HeartButton()
                }

                // other details
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text("Stanford Memorial Church is located on the Main Quad at the center of the Stanford University campus in Stanford, California, United States. It was built during the American Renaissance by Jane Stanford as a memorial to her husband Leland.")
                        Spacer()
                    }
                    Spacer()
                }
                .background(Color.gray)
                .cornerRadius(5)
            }
            .font(.footnote)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make it take the whole screen
        .padding(10)
    }
}

#Preview {
    LandmarksView()
}
