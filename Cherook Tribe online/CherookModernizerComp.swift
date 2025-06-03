import SwiftUI

struct CherookLoadingOverlay: View {
    let cherookProgress: Double

    var body: some View {
        ZStack {
            CherookLoadingBackground()
            VStack(spacing: 0) {
                HStack {
//                    Spacer()
//                    Image("big-png-0")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(maxWidth: 180, maxHeight: 120)
//                        .padding(.top, 60)
                    Spacer()
                }
                Spacer()
                VStack(spacing: 24) {
                    Text("Delivering your goods...")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .padding(.top, 10)
                    CherookTruckProgress(progress: cherookProgress)
                        .frame(height: 120)
                    Text("\(Int(cherookProgress * 100))% delivered")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                }
                .padding(.bottom, 80)
            }
        }
        .ignoresSafeArea()
    }
}

struct CherookLoadingBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.55, green: 0.80, blue: 1.0), // sky blue
                    Color(red: 0.85, green: 0.95, blue: 1.0)  // lighter sky
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            CherookCloudsLayer()
            VStack {
                Spacer()
                CherookGrassLayer()
//                CherookRoadLayer()
            }
        }
    }
}

struct CherookCloudsLayer: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                CherookCloud()
                    .offset(x: geo.size.width * 0.1, y: geo.size.height * 0.12)
                    .scaleEffect(1.1)
                CherookCloud()
                    .offset(x: geo.size.width * 0.7, y: geo.size.height * 0.18)
                    .scaleEffect(0.8)
                CherookCloud()
                    .offset(x: geo.size.width * 0.4, y: geo.size.height * 0.08)
                    .scaleEffect(1.3)
            }
        }
    }
}

struct CherookCloud: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.white.opacity(0.85))
                .frame(width: 90, height: 36)
            Capsule()
                .fill(Color.white.opacity(0.7))
                .frame(width: 60, height: 28)
                .offset(x: -30, y: 10)
            Capsule()
                .fill(Color.white.opacity(0.7))
                .frame(width: 50, height: 20)
                .offset(x: 30, y: 8)
        }
        .blur(radius: 0.5)
    }
}

struct CherookGrassLayer: View {
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.4, green: 0.8, blue: 0.3),
                        Color(red: 0.2, green: 0.6, blue: 0.1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 60)
            .overlay(
                CherookGrassBlades()
            )
    }
}

struct CherookGrassBlades: View {
    var body: some View {
        GeometryReader { geo in
            ForEach(0..<Int(geo.size.width/12), id: \.self) { i in
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 2, height: CGFloat.random(in: 16...28))
                    .offset(x: CGFloat(i) * 12, y: CGFloat.random(in: 20...35))
            }
        }
    }
}

struct CherookRoadLayer: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 0.25, green: 0.25, blue: 0.28))
                .frame(height: 38)
                .padding(.horizontal, 24)
            CherookRoadMarkings()
        }
        .padding(.bottom, 0)
    }
}

struct CherookRoadMarkings: View {
    var body: some View {
        GeometryReader { geo in
            let dashCount = Int(geo.size.width / 40)
            HStack(spacing: 16) {
                ForEach(0..<dashCount, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.7))
                        .frame(width: 22, height: 4)
                }
            }
            .frame(height: geo.size.height)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}

struct CherookTruckProgress: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            let roadWidth = geo.size.width * 0.88
            let clampedProgress = min(max(progress, 0), 1)
            let truckX = geo.size.width * 0.06 + roadWidth * clampedProgress
            ZStack {
                // Road
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 0.25, green: 0.25, blue: 0.28))
                    .frame(height: 38)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.7)
                // Road markings
                CherookRoadMarkings()
                    .frame(height: 38)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.7)
                // Truck (flipped horizontally)
                CherookTruckView()
                    .frame(width: 90, height: 54)
                    .scaleEffect(x: -1, y: 1)
                    .position(x: truckX, y: geo.size.height * 0.7 - 18)
            }
        }
    }
}

struct CherookTruckView: View {
    var body: some View {
        ZStack {
            // Trailer
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.85, green: 0.85, blue: 0.9))
                .frame(width: 54, height: 24)
                .offset(x: 10, y: 0)
            // Cabin
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(red: 0.2, green: 0.4, blue: 0.8))
                .frame(width: 22, height: 22)
                .offset(x: -18, y: 1)
            // Window
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.7))
                .frame(width: 10, height: 10)
                .offset(x: -20, y: -4)
            // Wheels
            HStack(spacing: 18) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color.black)
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color.black)
                    .frame(width: 10, height: 10)
            }
            .offset(x: 2, y: 13)
        }
        .shadow(radius: 2, y: 2)
    }
}

#Preview {
    CherookLoadingOverlay(cherookProgress: 0.4)
}

