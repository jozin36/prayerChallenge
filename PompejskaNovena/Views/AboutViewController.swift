//
//  AboutViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

final class AboutViewController: UIViewController {
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    private let pageControl = UIPageControl()

    private var pages: [InfoPage] = InfoPage.makePages()
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "O aplikácii"

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleTextSizeChange),
            name: .didChangeTextSize,
            object: nil
        )

        setupUI()
        setupNavigation()
        showPage(at: currentIndex, direction: .forward, animated: false)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        view.backgroundColor = ColorProvider.shared.backgroundColour

        addChild(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.backgroundColor = ColorProvider.shared.backgroundColour

        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentIndex
        pageControl.currentPageIndicatorTintColor = ColorProvider.shared.primaryColour
        pageControl.pageIndicatorTintColor = ColorProvider.shared.primaryColour.withAlphaComponent(0.25)
        pageControl.backgroundColor = ColorProvider.shared.backgroundColour
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor),

            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(showContents)
        )
        navigationItem.rightBarButtonItem?.accessibilityLabel = "Obsah"
    }

    @objc private func handleTextSizeChange() {
        pages = InfoPage.makePages()
        showPage(at: currentIndex, direction: .forward, animated: false)
    }

    @objc private func pageControlChanged() {
        let nextIndex = pageControl.currentPage
        let direction: UIPageViewController.NavigationDirection = nextIndex >= currentIndex ? .forward : .reverse
        showPage(at: nextIndex, direction: direction, animated: true)
    }

    @objc private func showContents() {
        let alertController = UIAlertController(
            title: "Obsah",
            message: nil,
            preferredStyle: .actionSheet
        )

        for (index, page) in pages.enumerated() {
            let title = index == currentIndex ? "✓ \(page.title)" : page.title
            alertController.addAction(UIAlertAction(title: title, style: .default) { [weak self] _ in
                self?.navigateToPage(at: index)
            })
        }

        alertController.addAction(UIAlertAction(title: "Zrušiť", style: .cancel))

        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.barButtonItem = navigationItem.rightBarButtonItem
        }

        present(alertController, animated: true)
    }

    private func navigateToPage(at index: Int) {
        guard pages.indices.contains(index), index != currentIndex else { return }

        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        showPage(at: index, direction: direction, animated: true)
    }

    private func showPage(
        at index: Int,
        direction: UIPageViewController.NavigationDirection,
        animated: Bool
    ) {
        guard pages.indices.contains(index) else { return }

        currentIndex = index
        pageControl.currentPage = index

        pageViewController.setViewControllers(
            [makePageController(for: index)],
            direction: direction,
            animated: animated
        )
    }

    private func makePageController(for index: Int) -> InfoPageContentViewController {
        let viewController = InfoPageContentViewController(page: pages[index])
        viewController.pageIndex = index
        return viewController
    }

    private func index(of viewController: UIViewController) -> Int? {
        (viewController as? InfoPageContentViewController)?.pageIndex
    }
}

extension AboutViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = index(of: viewController), index > 0 else { return nil }
        return makePageController(for: index - 1)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = index(of: viewController), index < pages.count - 1 else { return nil }
        return makePageController(for: index + 1)
    }
}

extension AboutViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            completed,
            let visibleController = pageViewController.viewControllers?.first,
            let index = index(of: visibleController)
        else {
            return
        }

        currentIndex = index
        pageControl.currentPage = index
    }
}

private final class InfoPageContentViewController: UIViewController {
    var pageIndex = 0

    private let page: InfoPage
    private let scrollView = UIScrollView()
    private let textView = UITextView()

    init(page: InfoPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = ColorProvider.shared.backgroundColour

        scrollView.backgroundColor = ColorProvider.shared.backgroundColour
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        textView.attributedText = page.attributedText
        textView.backgroundColor = ColorProvider.shared.grouppedBackroundColor
        textView.layer.cornerRadius = AppDesign.Radius.small
        textView.layer.cornerCurve = .continuous
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(
            top: AppDesign.Spacing.md,
            left: AppDesign.Spacing.md,
            bottom: AppDesign.Spacing.md,
            right: AppDesign.Spacing.md
        )
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppDesign.Spacing.sm),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppDesign.Spacing.sm),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            textView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: AppDesign.Spacing.sm),
            textView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -AppDesign.Spacing.sm),
            textView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
}

private struct InfoPage {
    let title: String
    let body: String
    
    private static let subtitleTitles = [
        "Na bludných cestách",
        "Milosť obrátenia",
        "Apoštol ruženca",
        "Blahoslavený",
        "Prosebná časť novény",
        "Ďakovná časť novény"
    ]

    var attributedText: NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(makeTitle(title))
        text.append(makeBody(body))
        
        let titles = ["Ako sa modliť novénu", "Životopis Bartolomeja Longa"]
        if (titles.contains(title)) {
            applySubtitleStyle(to: text)
        }
        return text
    }

    private func makeTitle(_ text: String) -> NSAttributedString {
        NSAttributedString(
            string: "\(text)\n\n",
            attributes: [
                .font: FontProvider.shared.titleFont(),
                .foregroundColor: UIColor.label
            ]
        )
    }

    private func makeBody(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .justified
        paragraphStyle.paragraphSpacing = AppDesign.Spacing.sm

        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: FontProvider.shared.font(for: .body),
                .foregroundColor: UIColor.label
            ]
        )
        
        return attributedText
    }

    private func applySubtitleStyle(to text: NSMutableAttributedString) {
        let source = text.string as NSString

        for subtitle in Self.subtitleTitles {
            let range = source.range(of: subtitle)
            guard range.location != NSNotFound else { continue }

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.hyphenationFactor = 1.0
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .natural
            paragraphStyle.paragraphSpacing = AppDesign.Spacing.sm
            paragraphStyle.paragraphSpacingBefore = AppDesign.Spacing.lg

            text.addAttributes(
                [
                    .font: FontProvider.shared.title2Font(),
                    .foregroundColor: UIColor.label,
                    .paragraphStyle: paragraphStyle
                ],
                range: range
            )
        }
    }

    static func makePages() -> [InfoPage] {
        [
            InfoPage(
                title: "Pompejská novéna",
                body: """
                Čo je novéna? Novéna (slovo pochádza z latinského výrazu novem, deväť) je tradičná pobožnosť, ktorá sa vykonáva súkromne alebo spoločne počas deviatich po sebe nasledujúcich dní a je obetovaná na určitý úmysel alebo sa vykonáva z príležitosti blížiacich sa slávností (napr. Božieho narodenia, zoslania Ducha Svätého, nedele Božieho milosrdenstva, patróna farnosti...). Pompejská novéna pozostáva z troch prosebných a troch ďakovných novén – trvá 54 dní.
                """
            ),
            InfoPage(
                title: "Vznik Pompejskej novény",
                body: """
                Na príhovor Panny Márie Pompejskej bolo vyprosených mnoho milostí a zázrakov. Zázračne uzdravená bola napríklad aj matka Bartolomeja Longa. Jedno z takýchto uzdravení – nevyliečiteľne chorej Fortunatíny Agrelli z Neapolu – prispelo k vzniku Pompejskej novény.
                Fortunatíne sa jedného dňa zjavila Panna Mária. „Obracala si sa na mňa rôznymi osloveniami a vždy si získala moju milosť. Teraz ma vzývaš titulom, ktorý je mi najmilší: Kráľovná svätého ruženca, preto nemôžem odmietnuť tvoju prosbu. Vždy, keď budeš chcieť odo mňa získať nejakú milosť, vykonaj si na moju počesť tri prosebné a potom tri ďakovné novény, modliac sa pätnásť tajomstiev môjho ruženca.“
                Prvým šíriteľom Pompejskej novény sa stal Bartolomej Longo.
                Blahoslavený Bartolo Longo dostal od Panny Márie prisľúbenie:
                „Každý, kto chce dostať milosti, nech sa modlí túto novénu na moju počesť.“
                Novéna k Panne Márii z Pompejí znamená, že človek sa má 54 dní denne pomodliť tri časti ruženca. Je to modlitba, ktorá si vyžaduje čas a trpezlivosť, ale jej ovocie vždy prekvapí tých, ktorí sa pre ňu rozhodli. K jej šíreniu prispel blahoslavený Bartolo Longo, advokát s mimoriadnou charizmou povzbudzovať k ružencovej modlitbe. Bartolo prežil hlboké obrátenie. V mladosti bol antiklerikál a voľnomyšlienkar, zaujímal sa o ezoteriku a zúčastňoval sa na špiritistických seansách. Jedného dňa, keď prežíval hlboké zúfalstvo, začul vo svojom srdci slová: „Ten, kto šíri ruženec, bude zachránený!“
                Blahoslavený Bartolo písal o ruženci ako o účinnom prostriedku posvätenia:
                „O, požehnaný Máriin ruženec, sladká reťaz, ktorá nás spája s Bohom; puto lásky, ktoré nás spája s anjelmi; veža záchrany pred pekelnými útokmi; bezpečný pristav v morskej búrke. Nikdy sa ťa nevzdáme. Budeš nám útechou v hodine smrti. Tebe patrí posledný bozk vyhasínajúceho života…“
                """
            ),
            InfoPage(
                title: "Ako sa modliť novénu",
                body: """
                Novéna k Panne Márii z Pompejí trvá 54 dní. Každý deň sa modlíme tri časti posvätného ruženca (radostný, bolestný a slávnostný). Môžeme sa pomodliť aj štvrtú časť – ruženec svetla.
                
                Pred začiatkom každej z troch častí ruženca povieme najskôr úmysel (iba jeden) a potom dodáme:
                „Tento ruženec sa modlím na tvoju česť, Kráľovná posvätného ruženca.“
                Prosebná časť novény
                Prvých 27 dní sa modlíme prosebnú časť novény k Panne Márii z Pompejí a každý deň po zakončení každej časti ruženca sa pomodlíme ešte nasledujúcu modlitbu:
                „Spomeň si, milosrdná Panna Mária, Kráľovná posvätného ruženca z Pompejí, že nikdy nebolo počuť, žeby bol niekto z tých, čo si ťa ctia a ružencom prosia o pomoc, opustený. Matka večného Slova, nezavrhni moje slová, ale ma milostivo vypočuj a vyslyš moju ružencovú modlitbu pre zaľúbenie, aké nachádzaš vo svojom chráme v Pompejach. Amen.“
                Ďakovná časť novény
                Ďalších 27 dní sa modlíme ďakovnú časť novény a každý deň po zakončení každej časti ruženca sa pomodlíme ešte nasledujúcu modlitbu:

                „Čo ti môžem dať, Kráľovná plná lásky? Zverujem ti celý svoj život. Panna posvätného ruženca z Pompejí, budem šíriť tvoju chválu, koľko mi len sily budú stačiť, lebo som vzýval tvoju pomoc a prišla mi Božia pomoc. Všade budem svedčiť o tvojom milosrdenstve. Budem šíriť ružencovú pobožnosť, koľko len budem vládať, a všetkým budem hovoriť o tvojej dobrote voči mne, aby k tebe prišli aj nehodní hriešnici ako ja. Keby celý svet vedel, aká si dobrá a ako sa zmilúvaš nad tými, čo trpia, všetky stvorenia by sa utiekali k tebe. Amen.“

                Okrem toho každú z troch častí ruženca končíme zvolaním, ktoré trikrát zopakujeme:
                „Kráľovná posvätného ruženca, oroduj za nás!“

                Ak sa ruženec budeme modliť s detskou dôverou, úprimne a v jednoduchosti srdca, ak všetkým všetko odpustíme a nebudeme v srdci prechovávať pocit krivdy, táto modlitba nám prinesie veľké milosti. Mať čisté srdce znamená žiť v posväcujúcej milosti, a preto si pred začatím novény k Panne Márii z Pompejí očistime srdce vo sviatosti zmierenia. Skrze ruženec dostávame oveľa viac milostí než iba tie, o ktoré prosíme. Nezabudnime sa preto poďakovať za všetky dary, ktoré dostávame skrze ruky Matky ušľachtilej lásky, a vydávajme o nich svedectvo aj iným.
                """
            ),
            InfoPage(
                title: "Životopis Bartolomeja Longa",
                body: """
                Bartolomej Longo sa narodil v zbožnej katolíckej rodine 10. februára 1841, v talianskom meste Latiano v južnom Taliansku. Jeho otec Bartolomej bol lekárom a matka Antónia sa starala o domácnosť. Už od útleho detstva ho zbožná matka učila modliť sa ruženec. Bartolomeja podľa vtedajšej praxe už ako 5-ročného poslali do Kolégia Školských bratov vo Francavilla Fontana. Bol veľmi živým a nadaným dieťaťom. Hral na klavíri a flaute, bol dirigentom školského orchestra. Mal veľké literárne nadanie, zaujímal sa aj o šerm a tanec.

                V roku 1858, po absolvovaní strednej školy, nastúpil Bartolomej Longo na právnickú fakultu univerzity v Neapole, kde získal doktorát a stal sa advokátom.
                Na bludných cestách
                Bolo to búrlivé obdobie v histórii Talianska. Univerzity boli nakazené ateizmom, materializmom a liberalizmom. Mnoho študentov, dokonca aj profesorov, sa zaoberalo špiritizmom a okultizmom. Katolíckym učením sa zjavne opovrhovalo a svoj vplyv výrazne rozširovalo aj slobodomurárstvo. Niektorí profesori priamo vystupovali proti Cirkvi. Študentom odporúčali protináboženskú literatúru. Pod týmto vplyvom sa viera Bartolomeja Longa zrútila.

                Stal sa obeťou satanistickej sekty, ktorá zosmiešňovala biskupov, kňazov a celú Cirkev. Robil také „pokroky“, že anti-biskup ho „vysvätil“ za kňaza satana. Bartolomej neskôr napísal, že počas tejto ceremónie, „kostol“ satana sa zmenil na skutočné peklo.

                V osídlách satana zotrval Longo jeden a pol roka. V tom čase vykonával obrady, ktoré boli posmešným napodobňovaním sviatostí, zaoberal sa okultizmom, organizoval špiritistické seansy, zúčastňoval sa na verejných protipápežských vystúpeniach, ktoré organizovali slobodomurári.
                Milosť obrátenia
                Jedného dňa sa Bartolomejovi Longovi zdalo, že počuje hlas svojho zomrelého otca, ktorý ho povzbudzuje, aby sa vrátil k Bohu a do Cirkvi. Pohnutý týmto zážitkom sa obrátil o pomoc k svojmu dlhoročnému priateľovi, profesorovi Vincentovi Pepemu, ktorý ho poznal ešte z rodného mesta.

                Dlhé rozhovory s priateľom ho presvedčili, aby sa vzdal satanizmu a opustil sektu. Profesor Pepo ho zaviedol k dominikánskemu pátrovi Albertovi Radentemu, ktorý ho vyspovedal, a zakrátko si ho Bartolomej vybral za svojho duchovného vodcu. Bartolomej sa obrátil a začal horieť túžbou vynahradiť svoje hriechy. Neskôr ho prijal do dominikánskeho tretieho rádu. Za svoje rehoľné meno si zvoli meno „Rosario“ – brat „Ruženec“.

                Avšak to ešte nebol koniec jeho ťažkej situácie. Satan sa ho snažil presvedčiť, že je jeho kňazom na celú večnosť a že v pekle je pre neho pripravené miesto. Jeho zúfalstvo bolo také veľké, že uvažoval dokonca o samovražde.

                Jedného októbrového dňa v roku 1872 sa počas dlhej prechádzky ocitol na mieste, ktoré okolití muži volali Arpaia (brloh upírov). Prosil Boha o svetlo, aby spoznal čo má robiť, aby odčinil svoje hriechy a našiel pokoj svedomia. Zrazu vo svojom srdci počul hlas: „Ak hľadáš pokoj duše a jej spásu, rozširuj ruženec, pretože ten, kto to robí, nikdy nezahynie. Tak to sľúbila Matka Božia sv. Dominikovi.“

                Bartolomej si vtedy kľakol a začal sa modliť: „Ak je tvoj prísľub, Matka, pravdivý, tak určite získam vytúžený pokoj svedomia a budem spasený. Neopustím tento kraj, kým nerozšírim modlitbu ruženca.“ Tak sa aj stalo. Zvyšok života Bartolomej Longo zasvätil šíreniu ruženca Najsvätejšej Panny Márie.
                Apoštol ruženca
                Ďalším významným bodom v živote mladého právnika bolo stretnutie s bohatou vdovou, kňažnou Mariannou de Fusco. Našiel v nej spriaznenú dušu. Stal sa vychovávateľom jej synov a správcom jej majetku. Boli neoddeliteľnými spoločníkmi v charitatívnej činnosti. Ako správca jej majetku sa dostal do Pompejí. Stretol tam zástupy úbožiakov, analfabetov, ktorí žili v „dierach“ ako pohania, nemorálne a bez poznania najzákladnejších zásad kresťanstva. Zaumienil si priblížiť týchto ľudí k Bohu a predovšetkým naučiť ich modlitbu ruženca. Putoval od chatrče ku chatrči, rozdával úbožiakom ružence, učil ich základné modlitby...

                Bartolomej Longo a Marianna de Fusco v roku 1885 uzavreli manželstvo; zároveň si však sľúbili, že budú žiť v čistote, ako brat a sestra. Vzájomne si pomáhali, jeden druhého obdivovali a rešpektovali.

                V blízkosti Pompejí našiel Bartolomej Longo malý opustený kostolík. Rozhodol sa, že ho obnoví a urobí ho centrom svojej evanjelizácie. V tom čase založil Ružencové bratstvo. Na oltári v kostolíku túžil mať obraz Ružencovej Panny Márie. Otec Radente mu daroval vhodný obraz, ktorý kúpil od neapolského obchodníka so starožitnosťami. Obraz bol veľký, ale špinavý a roztrhaný. Po zreštaurovaní začal priťahovať mnohých pútnikov a malý kostolík praskal vo švíkoch. Obraz predstavuje Pannu Máriu sediacu na tróne, na kolenách má dieťa Ježiša, ktorý podáva ruženec sv. Dominikovi. Matka Božia podáva ruženec sv. Kataríne Sienskej.

                K úcte Ružencovej Panny Márie – vďaka veľkému úsiliu Bartolomeja Longa pri získavaní finančných prostriedkov – bola v Pompejach postavená krásna bazilika. Bazilika Matky Božej Ružencovej sa stala národnou svätyňou Talianska, ktorá šíri modlitbu svätého ruženca.

                Bartolomej Longo sa z lásky k Panne Márii stal aj spisovateľom. Vykročil na namáhavú cestu propagovania ružencovej modlitby medzi obyvateľmi Pompejskej doliny. Spočiatku mu to šlo ťažko, ale po mnohých rokoch prinieslo jeho úsilie nádherné ovocie: ľudia si ruženec obľúbili.

                Horliví apoštol ruženca neostal iba pri stavbe baziliky. Jeho ďalšími dielami okrem iného bolo založenie sirotinca, domu starostlivosti o deti, ktorých rodičia boli vo väzení, ako aj ženskej rehoľnej kongregácie Dcéry svätého ruženca. Vybudoval tiež dielne, v ktorých sa deti učili remeslám. V okolí baziliky vznikla aj tlačiareň.
                Blahoslavený 
                Bartolomej Longo žil heroický čnostný život. Počas jeho štyridsaťročnej práce na šírení úcty k Panne Márii Ružencovej sa obrátilo mnoho ľudí k Bohu. Bartolomej si však „získal“ aj mnohých nepriateľov, ktorí či už z nevedomosti alebo zo závisti šírili o ňom rôzne nepravdivé a ohováračské reči.

                Veľký apoštol ruženca zomrel 5. októbra 1926 vo veku 85 rokov, na obojstranný zápal pľúc. Pochovaný bol k nohám trónu jeho láskyplnej Kráľovnej, ako si prial.

                Už 8. mája 1934 bol začatý beatifikačný proces. 26. októbra 1980 bol tento bývalý satanista, ktorý konvertoval a stal sa šíriteľom modlitby ruženca, povýšený k úcte na oltári. Ján Pavol II. pri tejto príležitosti vyhlásil, že život Bartolomeja Longa je „modelom pre dnešných laických katolíkov.“ Jeho pamiatka sa slávi 6. októbra.

                V súčasnej dobe prebieha proces jeho svätorečenia a zároveň sa otvoril aj proces blahorečenia jeho manželky Marianny de Fusco.
                """
            )
        ]
    }
}
