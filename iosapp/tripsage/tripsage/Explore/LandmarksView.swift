import SwiftUI

struct LandmarksView: View {
    let landmark: Landmark

    var body: some View {
        VStack(spacing: 8) {
            // landmark images
            TabView {
                ForEach(landmark.photoUrls, id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
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
                    Text(landmark.name).fontWeight(.semibold)
                    Spacer()
                    // distance away
                    // Assuming you have some method to calculate distance
                    Text("\(calculateDistance(from: landmark)) miles away")
                }
                // second line
                HStack {
                    // city / town name
                    Text(landmark.address).foregroundStyle(.gray)

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
                        Text(landmark.description)
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
    
    // Mock function for distance calculation, replace with actual implementation
    func calculateDistance(from landmark: Landmark) -> Double {
        return 1.0
    }
}
