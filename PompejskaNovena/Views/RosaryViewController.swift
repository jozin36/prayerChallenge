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
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    private let chevron = UIImageView()

    private var isExpanded = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(cgColor: CGColor(gray: 1.0, alpha: 1.0))
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.05
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4

        questionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        questionLabel.numberOfLines = 0
        questionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        answerLabel.font = .systemFont(ofSize: 15)
        answerLabel.numberOfLines = 0
        answerLabel.textColor = .darkGray
        answerLabel.isHidden = true // hidden initially

        chevron.image = UIImage(systemName: "chevron.down")
        chevron.tintColor = .gray
        chevron.translatesAutoresizingMaskIntoConstraints = false

        let topRow = UIStackView(arrangedSubviews: [questionLabel, chevron])
        topRow.axis = .horizontal
        topRow.spacing = 8
        topRow.alignment = .center

        let stack = UIStackView(arrangedSubviews: [topRow, answerLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        contentView.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),

            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),

            chevron.widthAnchor.constraint(equalToConstant: 16),
            chevron.heightAnchor.constraint(equalToConstant: 16),
        ])
    }

    func configure(with item: FAQItem) {
        questionLabel.text = item.question
        answerLabel.text = item.answer
        isExpanded = item.isExpanded

        // Animate visibility of answer
        UIView.animate(withDuration: 0.5) {
            //self.answerLabel.alpha = item.isExpanded ? 1 : 0
            self.answerLabel.isHidden = !item.isExpanded
        }

        // Animate chevron rotation
        UIView.animate(withDuration: 0.5) {
            self.chevron.transform = item.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
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
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = UIStackView()
        contentView.axis = .vertical
        contentView.spacing = 10
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FAQCardCell.self, forCellReuseIdentifier: "FAQCardCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return faqItems.count
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            let item = faqItems[indexPath.row]
            return item.isExpanded ? UITableView.automaticDimension : 60
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            faqItems[indexPath.row].isExpanded.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let item = faqItems[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCardCell", for: indexPath) as! FAQCardCell
            cell.configure(with: item)
            cell.selectionStyle = .none
            return cell
        }
}
