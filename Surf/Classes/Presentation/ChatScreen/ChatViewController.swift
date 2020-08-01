//
//  ChatViewController.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 07/06/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

import UIKit
import RxSwift

final class ChatViewController: UIViewController {
    var chatView = ChatView()
    
    weak var delegate: ChatViewControllerDelegate?
    
    private var attachView: ChatAttachView?
    
    private let disposeBag = DisposeBag()
    private var detectAttachViewTappedDisposable: Disposable?
    
    private var chat: Chat!
    private var viewModel: ChatViewModel!
    
    private lazy var imagePicker = makeImagePicker()
    
    init(chat: Chat) {
        self.chat = chat
        self.viewModel = ChatViewModel(chat: chat)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeAnalytics.shared.log(with: .chatScr)
        
        addInterlocutorPhoto()
        chatView.emptyView.setup(interlocutor: chat.interlocutor)
        
        viewModel
            .chatRemoved()
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .sender()
            .subscribe()
            .disposed(by: disposeBag)
        
        chatView
            .tableView.rx
            .reachedTop
            .emit(to: viewModel.nextPage)
            .disposed(by: disposeBag)
        
        chatView
            .tableView.rx
            .viewedMessage
            .emit(to: viewModel.viewedMessage)
            .disposed(by: disposeBag)
        
        chatView
            .tableView.rx
            .viewedMessage
            .filter { !$0.isOwner }
            .throttle(RxTimeInterval.milliseconds(500))
            .emit(onNext: { [weak self] message in
                guard let `self` = self else {
                    return
                }
                
                self.delegate?.chatViewController(markedRead: self.chat, message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .newMessages
            .drive(onNext: { [weak self] newMessages in
                self?.chatView.tableView.add(messages: newMessages)
            })
            .disposed(by: disposeBag)
            
        let hideKeyboardGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(hideKeyboardGesture)
        
        hideKeyboardGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        chatView
            .chatInputView
            .sendTapped
            .asObservable()
            .withLatestFrom(chatView.chatInputView.text)
            .subscribe(onNext: { [weak self] text in
                guard let message = text?.trimmingCharacters(in: .whitespaces), !message.isEmpty else {
                    return
                }

                self?.viewModel.sendText.accept(message)
                self?.chatView.chatInputView.set(text: "")
            })
            .disposed(by: disposeBag)

        chatView
            .chatInputView
            .attachTapped
            .emit(onNext: { [weak self] state in
                self?.attachTapped(state: state)
            })
            .disposed(by: disposeBag)
        
        chatView
            .tableView.rx
            .selectedMessage
            .emit(onNext: { [weak self] message in
                self?.messageTapped(message: message)
            })
            .disposed(by: disposeBag)
        
        chatView
            .tableView.rx
            .changedElementsCount
            .startWith(0)
            .emit(onNext: { [weak self] count in
                self?.chatView.tableView.isHidden = count == 0
                self?.chatView.emptyView.isHidden = count != 0
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.disconnect()
    }
}

// MARK: Make

extension ChatViewController {
    static func make(with chat: Chat) -> ChatViewController {
        ChatViewController(chat: chat)
    }
}

// MARK: ImagePickerDelegate

extension ChatViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        viewModel.sendImage.accept(image)
    }
}

// MARK: InterlocutorProfileViewControllerDelegate

extension ChatViewController: InterlocutorProfileViewControllerDelegate {
    func interlocutorProfileViewController(unmatched: Chat) {
        delegate?.chatViewController(unmatched: unmatched)
        
        navigationController?.popViewController(animated: true)
    }
    
    func interlocutorProfileViewController(reported: Chat) {
        delegate?.chatViewController(reported: reported)
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Private

private extension ChatViewController {
    func addInterlocutorPhoto() {
        guard let photoPath = chat.interlocutor.photos.sorted(by: { $0.order < $1.order }).first?.url, let photoUrl = URL(string: photoPath) else {
            return
        }
        
        let interlocutorImageView = UIImageView()
        interlocutorImageView.layer.cornerRadius = 20.scale
        interlocutorImageView.layer.masksToBounds = true
        interlocutorImageView.contentMode = .scaleAspectFill
        interlocutorImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToInterlocutorScreen))
        interlocutorImageView.addGestureRecognizer(tapGesture)
        
        interlocutorImageView.kf.setImage(with: photoUrl)
        
        let barItem = UIBarButtonItem(customView: interlocutorImageView)
        
        NSLayoutConstraint.activate([
            interlocutorImageView.widthAnchor.constraint(equalToConstant: 40.scale),
            interlocutorImageView.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc
    func goToInterlocutorScreen() {
        let vc = InterlocutorProfileViewController.make(chat: chat)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func attachTapped(state: ChatAttachButton.State) {
        switch state {
        case .attach:
            guard attachView == nil else {
                return
            }
            
            let attachView = ChatAttachView(frame: CGRect(x: 8.scale,
                                                          y: chatView.chatInputView.frame.origin.y - chatView.chatInputView.frame.height - 10.scale,
                                                          width: 260.scale,
                                                          height: 60.scale))
            self.attachView = attachView
            view.addSubview(attachView)
            
            detectAttachViewTapped()
        case .close:
            attachView?.removeFromSuperview()
            attachView = nil
        }
    }
    
    func detectAttachViewTapped() {
        detectAttachViewTappedDisposable?.dispose()
        
        detectAttachViewTappedDisposable = attachView?.caseTapped
            .emit(onNext: { [weak self] tapped in
                guard let `self` = self else {
                    return
                }
                
                switch tapped {
                case .photo:
                    self.attachView?.removeFromSuperview()
                    self.attachView = nil
                    
                    self.chatView.chatInputView.set(attachState: .attach)
                    
                    self.imagePicker.present(from: self.view)
                }
            })
    }
    
    func messageTapped(message: Message) {
        switch message.type {
        case .image:
            guard let url = URL(string: message.body) else {
                return
            }
            
            goToImageScreen(with: url)
        case .text:
            break
        }
    }
    
    func goToImageScreen(with imageUrl: URL) {
        let vc = ImageViewController.make(imageUrl: imageUrl)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Lazy initialization

private extension ChatViewController {
    func makeImagePicker() -> ImagePicker {
        ImagePicker(presentationController: self, delegate: self)
    }
}
