import SwiftUI


enum ActivityViewState {
    case tripNotStarted
    case tripInSession
    case tripFinished
    case savingFinishedTrip
}

struct InactiveView: View {
    
    @StateObject var activityViewModel: ActivityViewModel
    
    private let sageImage: UIImage = {
        guard let image = UIImage(named: "sageImage") else { return UIImage() }
        return image
    }()
    @State private var pulse = false
    var tripDelegate: TripDelegate?
    
    var body: some View {
        VStack {
            MessageView(message: Message(userId: "", text: "Start a trip to hear what Sage has in store for you!", PhotoURL: "", createdAt: Date(), isFromUser: false))
            Spacer()
            if activityViewModel.isLoadingForTripStart {
                ProgressView("Starting Trip...")
            } else {
                Button(action: {
                    activityViewModel.startTrip()
                }) {
                    Image(systemName: "play")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.sageOrange)
                        .clipShape(Circle())
                        .scaleEffect(pulse ? 1.5 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true),
                            value: pulse
                        )
                }
            }
            Spacer().frame(height: 20)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            pulse = true
        }
        .padding()
    }
}



struct ActivityView: View {
    
    @StateObject var activityViewModel: ActivityViewModel
    @State var text = ""
    
    var tripDelegate: TripDelegate?
    
    
    var body: some View {
        NavigationView {
            Group {
                if activityViewModel.activityViewPageState == .tripInSession {
                    VStack {
                        ScrollViewReader { scrollViewProxy in
                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(activityViewModel.mockData) { message in
                                        MessageView(message: message)
                                            .id(message.id) // Ensure each message has a unique ID
                                    }
                                }
                            }
                            .onChange(of: activityViewModel.mockData) { _ in
                                if let lastMessage = activityViewModel.mockData.last {
                                    withAnimation {
                                        scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        HStack {
                            TextField("Hello there", text: $text, axis: .vertical)
                                .padding()
                            Button {
                                if text.count >= 2 {
                                    activityViewModel.postMessageToSage(text: text)
                                    text = ""
                                }
                            } label: {
                                Text("Send")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.mint)
                                    .cornerRadius(50)
                                    .padding(.trailing)
                            }
                        }
                        .background(Color(uiColor: .systemGray6))
                    }
                    .padding([.top], 10)
                    .onAppear {
                        activityViewModel.requestForInitialMessages()
                    }
                } else if activityViewModel.activityViewPageState == .tripFinished {
                    FinishedTripView()
                } else if activityViewModel.activityViewPageState == .savingFinishedTrip {
                    SavingTripView()
                } else {
                    InactiveView(activityViewModel: activityViewModel, tripDelegate: tripDelegate)
                }
            }
            .background(
                Image("tripSage") // Assuming "TripSage" is the name of your image asset
                    .frame(height: UIScreen.main.bounds.width)
                    .opacity(0.1) // Adjust the opacity as needed
            )
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
}


struct FinishedTripView: View {
    var body: some View {
        Text("Trip Finished, hope you learnt a lot!")
            .font(.largeTitle)
            .padding()
            .navigationTitle("Finished Trip")
    }
}

struct SavingTripView: View {
    var body: some View {
        Text("Saving Trip!")
            .font(.largeTitle)
            .padding()
            .navigationTitle("Saving Trip")
    }
}

protocol TripDelegate: AnyObject {
    func userDidStartTrip()
}


#Preview {
    ActivityView(activityViewModel: ActivityViewModel())
}
