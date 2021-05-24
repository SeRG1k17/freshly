//
//  URLViewController.swift
//  Presentation
//
//  Created by Sergey Pugach on 18.05.21.
//

import SafariServices
import RxSwift
import RxRelay

public class URLViewController: UIViewController, BindableType {
    
    public typealias ViewModel = URLViewModelType
    
    private let dismissSubject = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    public let viewModel: ViewModel
    public init(with viewModel: ViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
    }
}

// MARK: - Bindings

extension URLViewController {
    
    public func bind(to viewModel: ViewModel) {
        
        dismissSubject
            .subscribe(viewModel.input.dismiss)
            .disposed(by: disposeBag)
        
        viewModel.output.url
            .drive(onNext: { [weak self] (url: URL) in
                self?.open(with: url)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - SFSafariViewControllerDelegate

extension URLViewController: SFSafariViewControllerDelegate {
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismissSubject.accept(())
    }
    
    public func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        dismissSubject.accept(())
    }
}

private extension URLViewController {
    
    func open(with url: URL) {
        let vc = SFSafariViewController(url: url)
        vc.delegate = self
        addChild(vc, to: view, layout: {
            $0.fillSuperviewWithLayout()
        })
    }
}
