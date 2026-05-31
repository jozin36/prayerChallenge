//
//  RosaryViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import AVFoundation
import UIKit

struct FAQItem {
    let question: String
    let answer: String
    let audioFileName: String?
    let exerciseType: String?
    var isExpanded: Bool = false

    init(question: String, answer: String, audioFileName: String? = nil, exerciseType: String? = nil, isExpanded: Bool = false) {
        self.question = question
        self.answer = answer
        self.audioFileName = audioFileName
        self.exerciseType = exerciseType
        self.isExpanded = isExpanded
    }
}

class FAQCardCell: UITableViewCell {

    private let container = UIView()
    private let headerContainer = UIView()
    private let answerContainer = UIView()
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    private let chevron = UIImageView()
    private let audioButton = UIButton(type: .system)
    private let headerRow = UIStackView()
    private var answerTopConstraint: NSLayoutConstraint!
    private var answerBottomConstraint: NSLayoutConstraint!
    private var answerHeightConstraint: NSLayoutConstraint!

    private var isExpanded = false
    var onPlayAudio: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NotificationCenter.default.removeObserver(self, name: .didChangeTextSize, object: nil)
        onPlayAudio = nil
    }
    
    private func applyCurrentTextSize() {
        questionLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        answerLabel.font = AppDesign.Font.body()
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false

        container.backgroundColor = ColorProvider.shared.elevatedSurfaceColour
        container.layer.cornerRadius = AppDesign.Radius.small
        container.layer.cornerCurve = .continuous
        container.layer.borderWidth = 0
        container.layer.shadowOpacity = 0

        questionLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        questionLabel.textColor = .label
        questionLabel.numberOfLines = 0
        questionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        questionLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        answerLabel.font = AppDesign.Font.body()
        answerLabel.numberOfLines = 0
        answerLabel.textColor = ColorProvider.shared.mutedTextColour
        answerLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        chevron.image = UIImage(systemName: "triangle.fill")
        chevron.tintColor = ColorProvider.shared.primaryColour
        chevron.translatesAutoresizingMaskIntoConstraints = false

        audioButton.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        audioButton.tintColor = ColorProvider.shared.primaryColour
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        audioButton.accessibilityLabel = "Prehrať audio tajomstva"
        audioButton.addTarget(self, action: #selector(playAudioTapped), for: .touchUpInside)

        headerRow.axis = .horizontal
        headerRow.spacing = 8
        headerRow.alignment = .center
        headerRow.translatesAutoresizingMaskIntoConstraints = false
        headerRow.addArrangedSubview(audioButton)
        headerRow.addArrangedSubview(questionLabel)
        headerRow.addArrangedSubview(chevron)

        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(headerRow)

        answerContainer.translatesAutoresizingMaskIntoConstraints = false
        answerContainer.clipsToBounds = true
        answerContainer.addSubview(answerLabel)

        container.addSubview(headerContainer)
        container.addSubview(answerContainer)
        contentView.addSubview(container)

        answerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppDesign.Spacing.sm),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppDesign.Spacing.sm),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),

            headerContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: AppDesign.Spacing.md),
            headerContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: AppDesign.Spacing.md),
            headerContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -AppDesign.Spacing.md),

            headerRow.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            headerRow.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            headerRow.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            headerRow.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),

            answerContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: AppDesign.Spacing.md),
            answerContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -AppDesign.Spacing.md),

            answerLabel.topAnchor.constraint(equalTo: answerContainer.topAnchor),
            answerLabel.bottomAnchor.constraint(equalTo: answerContainer.bottomAnchor),
            answerLabel.leadingAnchor.constraint(equalTo: answerContainer.leadingAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: answerContainer.trailingAnchor),

            chevron.widthAnchor.constraint(equalToConstant: 14),
            chevron.heightAnchor.constraint(equalToConstant: 14),
            audioButton.widthAnchor.constraint(equalToConstant: 40),
            audioButton.heightAnchor.constraint(equalToConstant: 40),
        ])

        answerTopConstraint = answerContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0)
        answerBottomConstraint = answerContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -AppDesign.Spacing.md)
        answerHeightConstraint = answerContainer.heightAnchor.constraint(equalToConstant: 0)

        answerTopConstraint.isActive = true
        answerBottomConstraint.isActive = true
        answerHeightConstraint.isActive = true
    }

    func configure(with item: FAQItem, animated: Bool = false) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        isExpanded = item.isExpanded
        audioButton.isHidden = item.audioFileName == nil
        applyCurrentTextSize()

        if item.isExpanded {
            answerTopConstraint.constant = AppDesign.Spacing.md
            answerHeightConstraint.isActive = false
        } else {
            answerTopConstraint.constant = 0
            answerHeightConstraint.isActive = true
        }

        if animated {
            if item.isExpanded {
                answerContainer.isHidden = false
                answerLabel.alpha = 0
            } else {
                answerLabel.alpha = 0
                answerContainer.isHidden = false
            }

            UIView.performWithoutAnimation {
                self.contentView.layoutIfNeeded()
            }

            UIView.animate(withDuration: 0.25) {
                self.chevron.transform = item.isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
                self.answerLabel.alpha = item.isExpanded ? 1 : 0
            }

            if !item.isExpanded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    guard !self.isExpanded else { return }
                    self.answerContainer.isHidden = true
                }
            }
        } else {
            // reset transform immediately to avoid reuse bugs
            chevron.transform = item.isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
            answerLabel.alpha = isExpanded ? 1 : 0
            answerContainer.isHidden = !isExpanded
        }
    }

    @objc private func playAudioTapped() {
        onPlayAudio?()
    }
}

private struct RosaryAudioSelection {
    let title: String
    let fileName: String
    let exerciseType: String?
}

private final class RosaryAudioPlayerViewController: UIViewController, AVAudioPlayerDelegate {
    private let audio: RosaryAudioSelection
    private let onCompleted: (String) -> Bool
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var playbackSpeed: Float = 1
    private var didAutoStart = false

    private let titleLabel = UILabel()
    private let rewindButton = UIButton(type: .system)
    private let playPauseButton = UIButton(type: .system)
    private let forwardButton = UIButton(type: .system)
    private let progressSlider = UISlider()
    private let elapsedLabel = UILabel()
    private let durationLabel = UILabel()
    private let speedButton = UIButton(type: .system)
    private let snackbarLabel = UILabel()

    init(audio: RosaryAudioSelection, onCompleted: @escaping (String) -> Bool) {
        self.audio = audio
        self.onCompleted = onCompleted
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorProvider.shared.surfaceColour
        configureSheet()
        setupPlayer()
        setupUI()
        updatePlaybackUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didAutoStart, audioPlayer != nil else { return }
        didAutoStart = true
        play()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        audioPlayer?.stop()
    }

    private func configureSheet() {
        guard let sheetPresentationController else { return }
        let audioPlayerDetent = UISheetPresentationController.Detent.custom(
            identifier: UISheetPresentationController.Detent.Identifier("audioPlayer")
        ) { context in
            min(360, context.maximumDetentValue)
        }
        sheetPresentationController.detents = [audioPlayerDetent]
        sheetPresentationController.selectedDetentIdentifier = UISheetPresentationController.Detent.Identifier("audioPlayer")
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.preferredCornerRadius = AppDesign.Radius.large
    }

    private func setupPlayer() {
        guard let fileName = audio.fileName.split(separator: ".").first,
              let fileExtension = audio.fileName.split(separator: ".").last,
              let url = Bundle.main.url(forResource: String(fileName), withExtension: String(fileExtension)) else {
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.enableRate = true
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            progressSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
            durationLabel.text = formatAudioTime(audioPlayer?.duration ?? 0)
        } catch {
            audioPlayer = nil
        }
    }

    private func setupUI() {
        titleLabel.text = audio.title
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        configureIconButton(rewindButton, systemName: "gobackward.10", accessibilityLabel: "Späť o 10 sekúnd")
        configureIconButton(forwardButton, systemName: "goforward.10", accessibilityLabel: "Dopredu o 10 sekúnd")

        playPauseButton.backgroundColor = ColorProvider.shared.primaryContainerColour
        playPauseButton.tintColor = ColorProvider.shared.onPrimaryContainerColour
        playPauseButton.layer.cornerRadius = 40
        playPauseButton.layer.cornerCurve = .continuous
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)

        rewindButton.addTarget(self, action: #selector(rewindTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardTapped), for: .touchUpInside)

        progressSlider.minimumTrackTintColor = UIColor(red: 61/255, green: 125/255, blue: 82/255, alpha: 1)
        progressSlider.maximumTrackTintColor = ColorProvider.shared.primaryContainerColour
        progressSlider.thumbTintColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
        progressSlider.isContinuous = true
        progressSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)

        [elapsedLabel, durationLabel].forEach {
            $0.font = .systemFont(ofSize: 13, weight: .medium)
            $0.textColor = ColorProvider.shared.mutedTextColour
        }
        elapsedLabel.text = "00:00"
        durationLabel.text = formatAudioTime(audioPlayer?.duration ?? 0)

        configureSpeedButton()

        snackbarLabel.text = "Ruženec bol označený ako dokončený"
        snackbarLabel.font = AppDesign.Font.caption()
        snackbarLabel.textColor = ColorProvider.shared.onPrimaryContainerColour
        snackbarLabel.backgroundColor = ColorProvider.shared.primaryContainerColour
        snackbarLabel.textAlignment = .center
        snackbarLabel.numberOfLines = 0
        snackbarLabel.layer.cornerRadius = AppDesign.Radius.small
        snackbarLabel.layer.cornerCurve = .continuous
        snackbarLabel.clipsToBounds = true
        snackbarLabel.alpha = 0

        let controlsStack = UIStackView(arrangedSubviews: [rewindButton, playPauseButton, forwardButton])
        controlsStack.axis = .horizontal
        controlsStack.alignment = .center
        controlsStack.distribution = .fill
        controlsStack.spacing = 12
        controlsStack.translatesAutoresizingMaskIntoConstraints = false

        let controlsContainer = UIView()
        controlsContainer.translatesAutoresizingMaskIntoConstraints = false
        controlsContainer.addSubview(controlsStack)

        let timeRow = UIStackView(arrangedSubviews: [elapsedLabel, durationLabel])
        timeRow.axis = .horizontal
        timeRow.distribution = .equalSpacing

        let speedRow = UIStackView(arrangedSubviews: [UIView(), speedButton])
        speedRow.axis = .horizontal
        speedRow.alignment = .center

        let stack = UIStackView(arrangedSubviews: [titleLabel, controlsContainer, speedRow, progressSlider, timeRow, snackbarLabel])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppDesign.Spacing.lg),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppDesign.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppDesign.Spacing.md),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppDesign.Spacing.md),

            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            rewindButton.widthAnchor.constraint(equalToConstant: 52),
            rewindButton.heightAnchor.constraint(equalToConstant: 52),
            playPauseButton.widthAnchor.constraint(equalToConstant: 80),
            playPauseButton.heightAnchor.constraint(equalToConstant: 80),
            forwardButton.widthAnchor.constraint(equalToConstant: 52),
            forwardButton.heightAnchor.constraint(equalToConstant: 52),
            controlsStack.topAnchor.constraint(equalTo: controlsContainer.topAnchor),
            controlsStack.bottomAnchor.constraint(equalTo: controlsContainer.bottomAnchor),
            controlsStack.centerXAnchor.constraint(equalTo: controlsContainer.centerXAnchor),
            controlsContainer.heightAnchor.constraint(equalToConstant: 80),
            speedButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 76),
            speedButton.heightAnchor.constraint(equalToConstant: 30),
            snackbarLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])

        let isAvailable = audioPlayer != nil
        [rewindButton, playPauseButton, forwardButton, progressSlider, speedButton].forEach { $0.isEnabled = isAvailable }
    }

    private func configureIconButton(_ button: UIButton, systemName: String, accessibilityLabel: String) {
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tintColor = .label
        button.accessibilityLabel = accessibilityLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 34, weight: .regular), forImageIn: .normal)
    }

    private func configureSpeedButton() {
        speedButton.tintColor = ColorProvider.shared.primaryColour
        speedButton.titleLabel?.font = AppDesign.Font.caption()
        speedButton.setTitle("1x", for: .normal)
        speedButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        speedButton.semanticContentAttribute = .forceRightToLeft
        speedButton.showsMenuAsPrimaryAction = true
        speedButton.menu = makeSpeedMenu()
    }

    private func makeSpeedMenu() -> UIMenu {
        let speeds: [Float] = [1, 1.5, 2]
        return UIMenu(children: speeds.map { speed in
            UIAction(
                title: formatPlaybackSpeed(speed),
                state: speed == playbackSpeed ? .on : .off
            ) { [weak self] _ in
                self?.setPlaybackSpeed(speed)
            }
        })
    }

    private func setPlaybackSpeed(_ speed: Float) {
        playbackSpeed = speed
        audioPlayer?.rate = speed
        speedButton.setTitle(formatPlaybackSpeed(speed), for: .normal)
        speedButton.menu = makeSpeedMenu()
    }

    @objc private func playPauseTapped() {
        guard let audioPlayer else { return }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            timer?.invalidate()
        } else {
            play()
        }
        updatePlaybackUI()
    }

    private func play() {
        guard let audioPlayer else { return }
        if audioPlayer.currentTime >= audioPlayer.duration {
            audioPlayer.currentTime = 0
        }
        audioPlayer.rate = playbackSpeed
        audioPlayer.play()
        startTimer()
        updatePlaybackUI()
    }

    @objc private func rewindTapped() {
        seek(to: (audioPlayer?.currentTime ?? 0) - 10)
    }

    @objc private func forwardTapped() {
        seek(to: (audioPlayer?.currentTime ?? 0) + 10)
    }

    @objc private func sliderChanged() {
        seek(to: TimeInterval(progressSlider.value))
    }

    private func seek(to time: TimeInterval) {
        guard let audioPlayer else { return }
        audioPlayer.currentTime = min(max(time, 0), audioPlayer.duration)
        updatePlaybackUI()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updatePlaybackUI()
        }
    }

    private func updatePlaybackUI() {
        let currentTime = audioPlayer?.currentTime ?? 0
        progressSlider.value = Float(currentTime)
        elapsedLabel.text = formatAudioTime(currentTime)

        let imageName = audioPlayer?.isPlaying == true ? "pause.fill" : "play.fill"
        playPauseButton.setImage(UIImage(systemName: imageName), for: .normal)
        playPauseButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 44, weight: .regular), forImageIn: .normal)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        updatePlaybackUI()

        if let exerciseType = audio.exerciseType, onCompleted(exerciseType) {
            showCompletionMessage()
        }
    }

    private func showCompletionMessage() {
        UIView.animate(withDuration: 0.2) {
            self.snackbarLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 2.2) {
                self.snackbarLabel.alpha = 0
            }
        }
    }

    private func formatAudioTime(_ seconds: TimeInterval) -> String {
        let totalSeconds = max(Int(seconds), 0)
        return String(format: "%02d:%02d", totalSeconds / 60, totalSeconds % 60)
    }

    private func formatPlaybackSpeed(_ speed: Float) -> String {
        speed == floor(speed) ? "\(Int(speed))x" : "\(speed)x"
    }
}

class RosaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    
    private var faqItems: [FAQItem] = [
        FAQItem(
            question: "Ako sa modliť ruženec",
            answer: """
                    Počas pompejskej novény začíname modlitbu ruženca slovami: „Tento ruženec sa modlím na tvoju česť, Kráľovná posvätného ruženca.“

                    Úvod:
                    Znamenie kríža
                    Apoštolské vyznanie viery (Verím v Boha)
                    Otče náš
                    3x Zdravas‘ Mária; po mene Ježiš nasleduje príslušné tajomstvo k preddesiatku
                    Sláva Otcu a fatimská modlitba

                    Nasleduje päť desiatkov:
                    Na začiatku každého desiatku uvedieme názov tajomstva (môže sa tiež opakovať po mene Ježiš v Zdravase)
                    * Otče náš
                    * 10x Zdravas’ Mária
                    * Sláva Otcu
                    * fatimská modlitba: „Ó, Ježišu, odpusť nám naše hriechy, zachráň nás od pekelného ohňa a priveď do neba všetky duše, najmä tie, ktoré najviac potrebujú tvoje milosrdenstvo.“
                    
                    Počas pompejskej novény na záver pridáme ešte zvolanie:
                    Kráľovná posvätného ruženca, oroduj za nás! (3x) a modlitbu prosebnej alebo ďakovnej časti, podľa toho v ktorej časti novény sa nachádzame.
                    """
        ),
        FAQItem(
            question: "Radostný ruženec",
            answer: """
                    (modlí sa v pondelok a sobotu, v Adventnom období aj v iné dni)

                    Prosby k preddesiatku: 
                    a) Ježiš, ktorý nech rozmnožuje našu vieru.
                    b) Ježiš, ktorý nech posilňuje našu nádej.
                    c) Ježiš, ktorý nech roznecuje našu lásku.

                    1. Ježiš, ktorého si, Panna, z Ducha Svätého počala.
                    2. Ježiš, ktorého si, Panna, pri návšteve Alžbety v živote nosila.
                    3. Ježiš, ktorého si, Panna, v Betleheme porodila.
                    4. Ježiš, ktorého si, Panna, so svätým Jozefom v chráme obetovala.
                    5. Ježiš, ktorého si, Panna, so svätým Jozefom v chráme našla.
                    """,
            audioFileName: "joyful_mysteries.mp3",
            exerciseType: "Radostný"
        ),
        FAQItem(
            question: "Bolestný ruženec",
            answer: """
                    (modlí sa v utorok a piatok, v Pôstnom období aj v iné dni)

                    Prosby k preddesiatku: 
                    a) Ježiš, ktorý nech osvecuje náš rozum.
                    b) Ježiš, ktorý nech upevňuje našu vôľu.
                    c) Ježiš, ktorý nech posilňuje našu pamäť.

                    1. Ježiš, ktorý sa pre nás krvou potil.
                    2. Ježiš, ktorý bol pre nás bičovaný.
                    3. Ježiš, ktorý bol pre nás tŕním korunovaný.
                    4. Ježiš, ktorý pre nás kríž niesol.
                    5. Ježiš, ktorý bol pre nás ukrižovaný.
                    """,
            audioFileName: "sorrowful_mysteries.mp3",
            exerciseType: "Bolestný"
        ),
        FAQItem(
            question: "Slávnostný ruženec",
            answer: """
                    (modlí sa v stredu a nedeľu, vo Veľkonočnom období aj v iné dni)

                    Prosby k preddesiatku: 
                    a) Ježiš, ktorý nech usporadúva naše myšlienky.
                    b) Ježiš, ktorý nech riadi naše slová.
                    c) Ježiš, ktorý nech spravuje naše skutky.

                    1. Ježiš, ktorý slávne vstal z mŕtvych.
                    2. Ježiš, ktorý slávne vystúpil do neba.
                    3. Ježiš, ktorý nám zoslal Ducha Svätého.
                    4. Ježiš, ktorý ťa, Panna, vzal do neba.
                    5. Ježiš, ktorý ťa, Panna, v nebi korunoval.
                    """,
            audioFileName: "glorious_mysteries.mp3",
            exerciseType: "Slávnostný"
        ),
        FAQItem(
            question: "Ruženec svetla",
            answer: """
                    (modlí sa vo štvrtok)

                    Prosby k preddesiatku:
                    a) Ježiš, ktorý nech je svetlom nášho života.
                    b) Ježiš, ktorý nech nás uzdravuje  milosrdnou láskou.
                    c) Ježiš, ktorý nech nás vezme k sebe do večnej slávy.

                    1. Ježiš, ktorý bol pokrstený v Jordáne a začal svoje verejné účinkovanie.
                    2. Ježiš, ktorý zázrakom v Káne Galilejskej otvoril srdcia učeníkov pre vieru.
                    3. Ježiš, ktorý ohlasoval Božie kráľovstvo a vyzýval ľud na pokánie.
                    4. Ježiš, ktorý sa ukázal v božskej sláve na vrchu premenenia.
                    5. Ježiš, ktorý nám dal seba samého za pokrm a nápoj v Oltárnej sviatosti.
                    """,
            audioFileName: "luminous_mysteries.mp3",
            exerciseType: nil
        ),
        FAQItem(
            question: "Ruženec svetla (skrátená verzia)",
            answer: """
                    Skrátená verzia tajomstiev ruženca svetla (schválená Konferenciou Biskupov Slovenska r. 2003):
                    
                    1. Ježiš, ktorý bol pokrstený v Jordáne.
                    2. Ježiš, ktorý zjavil seba samého na svadbe v Káne.
                    3. Ježiš, ktorý ohlasoval Božie kráľovstvo a pokánie.
                    4. Ježiš, ktorý sa premenil na vrchu Tábor.
                    5. Ježiš, ktorý ustanovil Oltárnu sviatosť.
                    """
        ),
        FAQItem(
            question: "Modlitba prosebnej časti:",
            answer: """
                    Spomeň si, milosrdná Panna Mária, Kráľovná posvätného ruženca z Pompejí, že nikdy nebolo počuť, žeby bol niekto z tých, čo si ťa ctia a ružencom prosia o pomoc, opustený. Matka večného Slova, nezavrhni moje slová, ale ma milostivo vypočuj a vyslyš moju ružencovú modlitbu pre zaľúbenie, aké nachádzaš vo svojom chráme v Pompejach. Amen.
                    """
        ),
        FAQItem(
            question: "Modlitba ďakovnej časti:",
            answer: """
                    Čo ti môžem dať, Kráľovná plná lásky? Zverujem ti celý svoj život. Panna posvätného ruženca z Pompejí, budem šíriť tvoju chválu, koľko mi len sily budú stačiť, lebo som vzýval tvoju pomoc a prišla mi Božia pomoc. Všade budem svedčiť o tvojom milosrdenstve. Budem šíriť ružencovú pobožnosť, koľko len budem vládať, a všetkým budem hovoriť o tvojej dobrote voči mne, aby k tebe prišli aj nehodní hriešnici ako ja. Keby celý svet vedel, aká si dobrá a ako sa zmilúvaš nad tými, čo trpia, všetky stvorenia by sa utiekali k tebe. Amen.
                    """
        ),
        FAQItem(
            question: "Čo ak som sa nestihol pomodliť niektorý z ružencov v daný deň?",
            answer: """
                    Pokiaľ sa vám stane, že ste sa nestihli pomodliť všetky ružence za daný deň, je potrebné sa ich nasledujúci deň domodliť (okrem tých, ktoré už máte na daný deň), tak aby boli pomodlené všetky. V prípade, že takýmto spôsobom sa vám ružence po čase nabalia a mustíe "dobiehať" príliš veľa ružencov naraz, odporúčame začať sa modliť novénu odzačiatku. Všeobecne by malo platiť, že za celých 54 dní sa pomodlíte každý deň aspoň jeden ruženec. Pokiaľ sa vám stane. že sa vám nepodarí v niektorý deň pomodliť sa ani jeden ruženec, je potrebné začať novénu odznovu.
                    """
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorProvider.shared.backgroundColour
        title = "Ruženec"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FAQCardCell.self, forCellReuseIdentifier: "FAQCardCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: AppDesign.Spacing.lg,
            right: 0
        )
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableHeaderView = makeHeaderView()

        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppDesign.Spacing.lg),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppDesign.Spacing.lg)
        ])

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextSizeChange),
            name: .didChangeTextSize,
            object: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeTableSupplementaryViews()
    }

    private func makeHeaderView() -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = "Svätý ruženec"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Ruženec je mocná modlitba, ktorá spája ústnu modlitbu a rozjímanie nad tajomstvami našej viery."
        descriptionLabel.font = AppDesign.Font.body()
        descriptionLabel.textColor = ColorProvider.shared.mutedTextColour
        descriptionLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = AppDesign.Spacing.md
        stack.translatesAutoresizingMaskIntoConstraints = false

        let headerView = UIView()
        headerView.backgroundColor = .clear
        headerView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: headerView.topAnchor, constant: AppDesign.Spacing.lg),
            stack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -AppDesign.Spacing.md)
        ])

        return headerView
    }

    private func resizeTableSupplementaryViews() {
        resizeSupplementaryView(\.tableHeaderView)
        resizeSupplementaryView(\.tableFooterView)
    }

    private func resizeSupplementaryView(_ keyPath: ReferenceWritableKeyPath<UITableView, UIView?>) {
        guard let view = tableView[keyPath: keyPath] else { return }

        let fittingSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = view.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height

        guard abs(view.frame.height - height) > 0.5 else { return }

        view.frame.size = CGSize(width: tableView.bounds.width, height: height)
        tableView[keyPath: keyPath] = view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqItems.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previouslyExpandedIndex = faqItems.firstIndex { $0.isExpanded }
        let shouldExpandTappedItem = !faqItems[indexPath.row].isExpanded
        
        for i in 0..<faqItems.count {
            faqItems[i].isExpanded = i == indexPath.row && shouldExpandTappedItem
        }

        var affectedIndexPaths = [indexPath]
        if let previouslyExpandedIndex, previouslyExpandedIndex != indexPath.row {
            affectedIndexPaths.append(IndexPath(row: previouslyExpandedIndex, section: indexPath.section))
        }

        UIView.performWithoutAnimation {
            affectedIndexPaths.forEach { affectedIndexPath in
                guard let cell = tableView.cellForRow(at: affectedIndexPath) as? FAQCardCell else { return }
                cell.configure(with: faqItems[affectedIndexPath.row], animated: false)
            }

            tableView.beginUpdates()
            tableView.endUpdates()
        }

        affectedIndexPaths.forEach { affectedIndexPath in
            guard let cell = tableView.cellForRow(at: affectedIndexPath) as? FAQCardCell else { return }
            cell.configure(with: faqItems[affectedIndexPath.row], animated: true)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = faqItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCardCell", for: indexPath) as! FAQCardCell
        cell.configure(with: item)
        cell.onPlayAudio = { [weak self] in
            self?.presentAudioPlayer(for: item)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    @objc private func handleTextSizeChange() {
        tableView.reloadData()
    }

    private func presentAudioPlayer(for item: FAQItem) {
        guard let audioFileName = item.audioFileName else { return }

        let playerViewController = RosaryAudioPlayerViewController(
            audio: RosaryAudioSelection(
                title: item.question,
                fileName: audioFileName,
                exerciseType: item.exerciseType
            ),
            onCompleted: { [weak self] exerciseType in
                self?.markCurrentDayRosaryCompleted(exerciseType: exerciseType) ?? false
            }
        )
        present(playerViewController, animated: true)
    }

    private func markCurrentDayRosaryCompleted(exerciseType: String) -> Bool {
        let manager = CoreDataManager.shared
        let challenge = manager.getCurrentChallenge() ?? manager.findActiveChallenge()
        guard let challenge else { return false }

        let date = Calendar.current.startOfDay(for: Date())
        let entries = manager.getAllExercises(for: date, challenge: challenge)
        let entry = entries.first { $0.type == exerciseType } ?? {
            let newEntry = ExerciseEntry(context: manager.context)
            newEntry.date = date
            newEntry.type = exerciseType
            newEntry.isCompleted = false
            newEntry.challenge = challenge
            return newEntry
        }()

        guard !entry.isCompleted else { return false }
        entry.isCompleted = true
        manager.saveContext()
        return true
    }
}
