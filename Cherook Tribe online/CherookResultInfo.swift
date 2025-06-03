import WebKit
import Foundation
import SwiftUI
import Combine

class CherookWebContentLoader: ObservableObject {
    @Published var loadState: CherookWebLoadState = CherookWebLoadState.idle()
    let urlToLoad: URL
    private var cancellables = Set<AnyCancellable>()
    private var progressSubject = PassthroughSubject<Double, Never>()
    private var webViewProvider: (() -> WKWebView)?
    
    init(url: URL) {
        self.urlToLoad = url
        setupProgressListener()
    }
    
    func provideWebView(_ provider: @escaping () -> WKWebView) {
        self.webViewProvider = provider
        startLoading()
    }
    
    private func setupProgressListener() {
        progressSubject
            .removeDuplicates()
            .sink { [weak self] prog in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if prog < 1.0 {
                        self.loadState = CherookWebLoadState.progress(prog)
                    } else {
                        self.loadState = CherookWebLoadState.success()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func startLoading() {
        guard let webView = webViewProvider?() else { return }
        let req = URLRequest(url: urlToLoad, timeoutInterval: 15.0)

        DispatchQueue.main.async {
            self.loadState = CherookWebLoadState.progress(0.0)
        }

        webView.load(req)
        observeWebViewProgress(webView)
    }
    
    private func observeWebViewProgress(_ webView: WKWebView) {
        webView.publisher(for: \.estimatedProgress)
            .sink { [weak self] prog in
                self?.progressSubject.send(prog)
            }
            .store(in: &cancellables)
    }
    
    func setNetworkStatus(_ connected: Bool) {
        if connected && loadState.type == .offline {
            startLoading()
        } else if !connected {
            self.loadState = CherookWebLoadState.offline()
        }
    }
}
