import WebKit
import Foundation
import SwiftUI

struct CherookWebViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: CherookWebContentLoader

    func makeCoordinator() -> CherookWebViewCoordinator {
        CherookWebViewCoordinator { state in
            DispatchQueue.main.async {
                self.viewModel.loadState = state
            }
        }
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = CherookHexColor.uiColor(from: "#141f2b")
        webView.isOpaque = false
        clearWebData()
        debugPrint("Renderer: \(viewModel.urlToLoad)")
        webView.navigationDelegate = context.coordinator
        viewModel.provideWebView { webView }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        clearWebData()
    }

    private func clearWebData() {
        let types: Set<String> = [
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeLocalStorage
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: Date.distantPast) {}
    }
}

