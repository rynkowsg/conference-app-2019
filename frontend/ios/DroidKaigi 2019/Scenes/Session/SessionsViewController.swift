//
//  SessionsViewController.swift
//  DroidKaigi 2019
//
//  Created by 菊池 紘 on 2019/01/09.
//

import UIKit
import ios_combined
import MaterialComponents.MaterialSnackbar
import RxSwift
import RxCocoa

final class SessionsViewController: UIViewController, StoryboardInstantiable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    @IBOutlet private weak var tableView: UITableView!

    private var viewModel = SessionsViewModel()
    private let bag = DisposeBag()

    private func bind() {
        let input = SessionsViewModel.Input(initTrigger: Observable.just(()))
        let output = viewModel.transform(input: input)
        output.error
              .drive(onNext: { errorMessage in
                  if let errMsg = errorMessage {
                      MDCSnackbarManager.show(MDCSnackbarMessage(text: errMsg))
                  }
              })
              .disposed(by: bag)
        output.sessions
              .drive(tableView.rx.items(cellIdentifier: "Cell")) { indexPath, element, cell in
                  switch element {
                  case let serviceSession as ServiceSession:
                      cell.textLabel?.text = serviceSession.title.getByLang(lang: LangKt.defaultLang())
                  case let speechSession as SpeechSession:
                      cell.textLabel?.text = speechSession.title.getByLang(lang: LangKt.defaultLang())
                  default:
                      break
                  }
              }
              .disposed(by: bag)
    }
}
