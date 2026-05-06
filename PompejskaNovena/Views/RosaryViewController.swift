//
//  RosaryViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

struct FAQItem {
    let question: String
    let answer: String
    var isExpanded: Bool = false
}

class FAQCardCell: UITableViewCell {

    private let container = UIView()
    private let headerContainer = UIView()
    private let answerContainer = UIView()
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    private let chevron = UIImageView()
    private let headerRow = UIStackView()
    private var answerTopConstraint: NSLayoutConstraint!
    private var answerBottomConstraint: NSLayoutConstraint!
    private var collapsedBottomConstraint: NSLayoutConstraint!

    private var isExpanded = false

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

        headerRow.axis = .horizontal
        headerRow.spacing = 8
        headerRow.alignment = .center
        headerRow.translatesAutoresizingMaskIntoConstraints = false
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
        ])

        answerTopConstraint = answerContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: AppDesign.Spacing.md)
        answerBottomConstraint = answerContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -AppDesign.Spacing.md)
        collapsedBottomConstraint = headerContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -AppDesign.Spacing.md)

        collapsedBottomConstraint.isActive = true
    }

    func configure(with item: FAQItem, animated: Bool = false) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        isExpanded = item.isExpanded
        applyCurrentTextSize()

        if item.isExpanded {
            collapsedBottomConstraint.isActive = false
            answerTopConstraint.isActive = true
            answerBottomConstraint.isActive = true
        } else {
            answerTopConstraint.isActive = false
            answerBottomConstraint.isActive = false
            collapsedBottomConstraint.isActive = true
        }

        if animated {
            if item.isExpanded {
                answerContainer.isHidden = false
                answerLabel.alpha = 0
            } else {
                answerLabel.alpha = 0
                answerContainer.isHidden = false
            }

            UIView.animate(withDuration: 0.25) {
                self.chevron.transform = item.isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
                self.answerLabel.alpha = item.isExpanded ? 1 : 0
                self.contentView.layoutIfNeeded()
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
                    """
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
                    """
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
                    """
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
                    """
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
                    Prvých 27 dní sa modlíme prosebnú časť novény k Panne Márii z Pompejí a každý deň po zakončení každej časti ruženca sa pomodlíme ešte nasledujúcu modlitbu:
                    
                    Spomeň si, milosrdná Panna Mária, Kráľovná posvätného ruženca z Pompejí, že nikdy nebolo počuť, žeby bol niekto z tých, čo si ťa ctia a ružencom prosia o pomoc, opustený. Matka večného Slova, nezavrhni moje slová, ale ma milostivo vypočuj a vyslyš moju ružencovú modlitbu pre zaľúbenie, aké nachádzaš vo svojom chráme v Pompejach. Amen.
                    """
        ),
        FAQItem(
            question: "Modlitba ďakovnej časti:",
            answer: """
                    Ďalších 27 dní sa modlíme ďakovnú časť novény a každý deň po zakončení každej časti ruženca sa pomodlíme ešte nasledujúcu modlitbu:
                    
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

        affectedIndexPaths.forEach { affectedIndexPath in
            guard let cell = tableView.cellForRow(at: affectedIndexPath) as? FAQCardCell else { return }
            cell.configure(with: faqItems[affectedIndexPath.row], animated: false)
        }

        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = faqItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCardCell", for: indexPath) as! FAQCardCell
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc private func handleTextSizeChange() {
        tableView.reloadData()
    }
}
