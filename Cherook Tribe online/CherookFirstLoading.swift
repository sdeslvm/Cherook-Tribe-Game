import SwiftUI
import Foundation

enum CherookOverlayType {
    case progress(Double)
    case error(Error)
    case offline
    case none
}

struct CherookLaunchScreenView: View {
    @StateObject private var loader: CherookWebContentLoader

    init(viewModel: CherookWebContentLoader) {
        _loader = StateObject(wrappedValue: viewModel)
    }

    private var overlay: CherookOverlayType {
        switch loader.loadState.type {
        case .progress:
            if let percent = loader.loadState.percent {
                return .progress(percent)
            }
        case .error:
            if let err = loader.loadState.error {
                return .error(err)
            }
        case .offline:
            return .offline
        default:
            break
        }
        return .none
    }

    var body: some View {
        ZStack {
            CherookWebViewContainer(viewModel: loader)
                .opacity(loader.loadState.type == .success ? 1 : 0.5)
            CherookOverlayView(type: overlay)
        }
    }
}

struct CherookOverlayView: View {
    let type: CherookOverlayType

    var body: some View {
        switch type {
        case .progress(let percent):
            GeometryReader { proxy in
                CherookProgressView(progress: percent)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .background(Color.black)
            }
        case .error(let error):
            CherookErrorView(error: error)
        case .offline:
            CherookOfflineView()
        case .none:
            EmptyView()
        }
    }
}

struct CherookProgressView: View {
    let progress: Double
    var body: some View {
        CherookLoadingOverlay(cherookProgress: progress)
    }
}

struct CherookErrorView: View {
    let error: Error
    var body: some View {
        Text("Error: \(error.localizedDescription)").foregroundColor(.red)
    }
}

struct CherookOfflineView: View {
    var body: some View {
        Text("")
    }
}
