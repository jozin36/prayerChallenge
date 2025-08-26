//
//  AboutViewController.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 17/07/2025.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView()
        let contentView = UIStackView()
        contentView.axis = .vertical
        contentView.spacing = 10
        
        let textView = UITextView()
        
        let attributedText = makeMutableHeading(from: "Pompejská novéna")
        let paragraph1 = makeParagraph(from:"""
        Čo je novéna? Novéna (slovo pochádza z latinského výrazu novem, deväť) je tradičná pobožnosť, ktorá sa vykonáva súkromne alebo spoločne počas deviatich po sebe nasledujúcich dní a je obetovaná na určitý úmysel alebo sa vykonáva z príležitosti blížiacich sa slávností (napr. Božieho narodenia, zoslania Ducha Svätého, nedele Božieho milosrdenstva, patróna farnosti...). Pompejská novéna pozostáva z troch prosebných a troch ďakovných novén – trvá 54 dní.
        """)
        attributedText.append(paragraph1)
        attributedText.append(makeHeading(from: "Vznik Pompejskej novény"))
                              
        let infoText = """
        Na príhovor Panny Márie Pompejskej bolo vyprosených mnoho milostí a zázrakov. Zázračne uzdravená bola napríklad aj matka Bartolomeja Longa. Jedno z takýchto uzdravení – nevyliečiteľne chorej Fortunatíny Agrelli z Neapolu – prispelo k vzniku Pompejskej novény.

        Fortunatíne sa jedného dňa zjavila Panna Mária. „Obracala si sa na mňa rôznymi osloveniami a vždy si získala moju milosť. Teraz ma vzývaš titulom, ktorý je mi najmilší: Kráľovná svätého ruženca, preto nemôžem odmietnuť tvoju prosbu. Vždy, keď budeš chcieť odo mňa získať nejakú milosť, vykonaj si na moju počesť tri prosebné a potom tri ďakovné novény, modliac sa pätnásť tajomstiev môjho ruženca.“

        Prvým šíriteľom Pompejskej novény sa stal Bartolomej Longo.
        
        Blahoslavený Bartolo Longo dostal od Panny Márie prisľúbenie:

        „Každý, kto chce dostať milosti, nech sa modlí túto novénu na moju počesť.“

        Novéna k Panne Márii z Pompejí znamená, že človek sa má 54 dní denne pomodliť tri časti ruženca. Je to modlitba, ktorá si vyžaduje čas a trpezlivosť, ale jej ovocie vždy prekvapí tých, ktorí sa pre ňu rozhodli. K jej šíreniu prispel blahoslavený Bartolo Longo, advokát s mimoriadnou charizmou povzbudzovať k ružencovej modlitbe. Bartolo prežil hlboké obrátenie. V mladosti bol antiklerikál a voľnomyšlienkar, zaujímal sa o ezoteriku a zúčastňoval sa na špiritistických seansách. Jedného dňa, keď prežíval hlboké zúfalstvo, začul vo svojom srdci slová: „Ten, kto šíri ruženec, bude zachránený!“

        Blahoslavený Bartolo písal o ruženci ako o účinnom prostriedku posvätenia:

        „O, požehnaný Máriin ruženec, sladká reťaz, ktorá nás spája s Bohom; puto lásky, ktoré nás spája s anjelmi; veža záchrany pred pekelnými útokmi; bezpečný pristav v morskej búrke. Nikdy sa ťa nevzdáme. Budeš nám útechou v hodine smrti. Tebe patrí posledný bozk vyhasínajúceho života…“
        """
        attributedText.append(makeParagraph(from: infoText))
        
        attributedText.append(makeHeading(from: "Ako sa treba modliť novénu k Panne Márii z Pompejí?"))
        let howToPray = """
        Novéna k Panne Márii z Pompejí trvá 54 dní. Každý deň sa modlíme tri časti posvätného ruženca (radostný, bolestný a slávnostný). Môžeme sa pomodliť aj štvrtú časť – ruženec svetla.

        1)  Pred začiatkom každej z troch častí ruženca povieme najskôr úmysel (iba jeden) a potom dodáme:

        „Tento ruženec sa modlím na tvoju česť, Kráľovná posvätného ruženca.“

        2)  Prvých 27 dní sa modlíme prosebnú časť novény k Panne Márii z Pompejí a každý deň po zakončení každej časti ruženca sa pomodlíme ešte nasledujúcu modlitbu:

        „Spomeň si, milosrdná Panna Mária, Kráľovná posvätného ruženca z Pompejí, že nikdy nebolo počuť, žeby bol niekto z tých, čo si ťa ctia a ružencom prosia o pomoc, opustený. Matka večného Slova, nezavrhni moje slová, ale ma milostivo vypočuj a vyslyš moju ružencovú modlitbu pre zaľúbenie, aké nachádzaš vo svojom chráme v Pompejach. Amen.“

        3)  Ďalších 27 dní sa modlíme ďakovnú časť novény a každý deň po zakončení každej časti ruženca sa pomodlíme ešte nasledujúcu modlitbu:

        „Čo ti môžem dať, Kráľovná plná lásky? Zverujem ti celý svoj život. Panna posvätného ruženca z Pompejí, budem šíriť tvoju chválu, koľko mi len sily budú stačiť, lebo som vzýval tvoju pomoc a prišla mi Božia pomoc. Všade budem svedčiť o tvojom milosrdenstve. Budem šíriť ružencovú pobožnosť, koľko len budem vládať, a všetkým budem hovoriť o tvojej dobrote voči mne, aby k tebe prišli aj nehodní hriešnici ako ja. Keby celý svet vedel, aká si dobrá a ako sa zmilúvaš nad tými, čo trpia, všetky stvorenia by sa utiekali k tebe. Amen.“

        4)  Okrem toho každú z troch častí ruženca končíme zvolaním, ktoré trikrát zopakujeme: 

        „Kráľovná posvätného ruženca, oroduj za nás!“

        Ak sa ruženec budeme modliť s detskou dôverou, úprimne a v jednoduchosti srdca, ak všetkým všetko odpustíme a nebudeme v srdci prechovávať pocit krivdy, táto modlitba nám prinesie veľké milosti. Mať čisté srdce znamená žiť v posväcujúcej milosti, a preto si pred začatím novény k Panne Márii z Pompejí očistime srdce vo sviatosti zmierenia. Skrze ruženec dostávame oveľa viac milostí než iba tie, o ktoré prosíme. Nezabudnime sa preto poďakovať za všetky dary, ktoré dostávame skrze ruky Matky ušľachtilej lásky, a vydávajme o nich svedectvo aj iným.
        """
        attributedText.append(makeParagraph(from: howToPray))
        attributedText.append(makeHeading(from: "Životopis Bartolomeja Longo"))
        
        let biography1: String = """
        Bartolomej Longo sa narodil v zbožnej katolíckej rodine 10. februára 1841, v talianskom meste Latiano v južnom Taliansku. Jeho otec Bartolomej bol lekárom a matka Antónia sa starala o domácnosť. Už od útleho detstva ho zbožná matka učila modliť sa ruženec. Bartolomeja podľa vtedajšej praxe už ako 5-ročného poslali do Kolégia Školských bratov vo Francavilla Fontana. Bol veľmi živým a nadaným dieťaťom. Hral na klavíri a flaute, bol dirigentom školského orchestra. Mal veľké literárne nadanie, zaujímal sa aj o šerm a tanec.
        """
        attributedText.append(makeParagraph(from: biography1))
        
        attributedText.append(makeHeading(from: "Na bludných cestách", size: 16))
        let biography2 = """
        V roku 1858, po absolvovaní strednej školy, nastúpil Bartolomej Longo na právnickú fakultu univerzity v Neapole, kde získal doktorát a stal sa advokátom. Bolo to búrlivé obdobie v histórii Talianska. Univerzity boli nakazené ateizmom, materializmom a liberalizmom. Mnoho študentov, dokonca aj profesorov, sa zaoberalo špiritizmom a okultizmom. Katolíckym učením sa zjavne opovrhovalo a svoj vplyv výrazne rozširovalo aj slobodomurárstvo. Niektorí profesori priamo vystupovali proti Cirkvi. Študentom odporúčali protináboženskú literatúru. Pod týmto vplyvom sa viera Bartolomeja Longa zrútila.

        Stal sa obeťou satanistickej sekty, ktorá zosmiešňovala biskupov, kňazov a celú Cirkev. Robil také „pokroky“, že anti-biskup ho „vysvätil“ za kňaza satana. Bartolomej neskôr napísal, že počas tejto ceremónie, „kostol“ satana sa zmenil na skutočné peklo.

        V osídlach satana zotrval Longo jeden a pol roka. V tom čase vykonával obrady, ktoré boli posmešným napodobňovaním sviatostí, zaoberal sa okultizmom, organizoval špiritistické seansy, zúčastňoval sa na verejných protipápežských vystúpeniach, ktoré organizovali slobodomurári.
        """
        attributedText.append(makeParagraph(from: biography2))
        
        attributedText.append(makeHeading(from: "Milosť obrátenia", size: 16))
        let biography3 = """
        Jedného dňa sa Bartolomejovi Longovi zdalo, že počuje hlas svojho zomrelého otca, ktorý ho povzbudzuje, aby sa vrátil k Bohu a do Cirkvi. Pohnutý týmto zážitkom sa obrátil o pomoc k svojmu dlhoročnému priateľovi, profesorovi Vincentovi Pepemu, ktorý ho poznal ešte z rodného mesta.

        Dlhé rozhovory s priateľom ho presvedčili, aby sa vzdal satanizmu a opustil sektu. Profesor Pepo ho zaviedol k dominikánskemu pátrovi Albertovi Radentemu, ktorý ho vyspovedal, a zakrátko si ho Bartolomej vybral za svojho duchovného vodcu. Bartolomej sa obrátil a začal horieť túžbou vynahradiť svoje hriechy. Neskôr ho prijal do dominikánskeho tretieho rádu. Za svoje rehoľné meno si zvoli meno „Rosario“ – brat „Ruženec“.

        Avšak to ešte nebol koniec jeho ťažkej situácie. Satan sa ho snažil presvedčiť, že je jeho kňazom na celú večnosť a že v pekle je pre neho pripravené miesto. Jeho zúfalstvo bolo také veľké, že uvažoval dokonca o samovražde.

        Jedného októbrového dňa v roku 1872 sa počas dlhej prechádzky ocitol na mieste, ktoré okolití muži volali Arpaia (brloh upírov). Prosil Boha o svetlo, aby spoznal čo má robiť, aby odčinil svoje hriechy a našiel pokoj svedomia. Zrazu vo svojom srdci počul hlas: „Ak hľadáš pokoj duše a jej spásu, rozširuj ruženec, pretože ten, kto to robí, nikdy nezahynie. Tak to sľúbila Matka Božia sv. Dominikovi.“

        Bartolomej si vtedy kľakol a začal sa modliť: „Ak je tvoj prísľub, Matka, pravdivý, tak určite získam vytúžený pokoj svedomia a budem spasený. Neopustím tento kraj, kým nerozšírim modlitbu ruženca.“ Tak sa aj stalo. Zvyšok života Bartolomej Longo zasvätil šíreniu ruženca Najsvätejšej Panny Márie.
        """
        attributedText.append(makeParagraph(from: biography3))
        
        attributedText.append(makeHeading(from: "Apoštol ruženca", size: 16))
        let biography4 = """
        Ďalším významným bodom v živote mladého právnika bolo stretnutie s bohatou vdovou, kňažnou Mariannou de Fusco. Našiel v nej spriaznenú dušu. Stal sa vychovávateľom jej synov a správcom jej majetku. Boli neoddeliteľnými spoločníkmi v charitatívnej činnosti. Ako správca jej majetku sa dostal do Pompejí. Stretol tam zástupy úbožiakov, analfabetov, ktorí žili v „dierach“ ako pohania, nemorálne a bez poznania najzákladnejších zásad kresťanstva. Zaumienil si priblížiť týchto ľudí k Bohu a predovšetkým naučiť ich modlitbu ruženca. Putoval od chatrče ku chatrči, rozdával úbožiakom ružence, učil ich základné modlitby...

        Bartolomej Longo a Marianna de Fusco v roku 1885 uzavreli manželstvo; zároveň si však sľúbili, že budú žiť v čistote, ako brat a sestra. Vzájomne si pomáhali, jeden druhého obdivovali a rešpektovali.

        V blízkosti Pompejí našiel Bartolomej Longo malý opustený kostolík. Rozhodol sa, že ho obnoví a urobí ho centrom svojej evanjelizácie. V tom čase založil Ružencové bratstvo. Na oltári v kostolíku túžil mať obraz Ružencovej Panny Márie. Otec Radente mu daroval vhodný obraz, ktorý kúpil od neapolského obchodníka so starožitnosťami. Obraz bol veľký, ale špinavý a roztrhaný. Po zreštaurovaní začal priťahovať mnohých pútnikov a malý kostolík praskal vo švíkoch. Obraz predstavuje Pannu Máriu sediacu na tróne, na kolenách má dieťa Ježiša, ktorý podáva ruženec sv. Dominikovi. Matka Božia podáva ruženec sv. Kataríne Sienskej.

        K úcte Ružencovej Panny Márie – vďaka veľkému úsiliu Bartolomeja Longa pri získavaní finančných prostriedkov – bola v Pompejach postavená krásna bazilika. Bazilika Matky Božej Ružencovej sa stala národnou svätyňou Talianska, ktorá šíri modlitbu svätého ruženca.

        Bartolomej Longo sa z lásky k Panne Márii stal aj spisovateľom. Vykročil na namáhavú cestu propagovania ružencovej modlitby medzi obyvateľmi Pompejskej doliny. Spočiatku mu to šlo ťažko, ale po mnohých rokoch prinieslo jeho úsilie nádherné ovocie: ľudia si ruženec obľúbili.

        Horliví apoštol ruženca neostal iba pri stavbe baziliky. Jeho ďalšími dielami okrem iného bolo založenie sirotinca, domu starostlivosti o deti, ktorých rodičia boli vo väzení, ako aj ženskej rehoľnej kongregácie Dcéry svätého ruženca. Vybudoval tiež dielne, v ktorých sa deti učili remeslám. V okolí baziliky vznikla aj tlačiareň.
        """
        attributedText.append(makeParagraph(from: biography4))
        
        attributedText.append(makeHeading(from: "Blahoslavený", size: 16))
        let biography5 = """
        Bartolomej Longo žil heroický čnostný život. Počas jeho štyridsaťročnej práce na šírení úcty k Panne Márii Ružencovej sa obrátilo mnoho ľudí k Bohu. Bartolomej si však „získal“ aj mnohých nepriateľov, ktorí či už z nevedomosti alebo zo závisti šírili o ňom rôzne nepravdivé a ohováračské reči.

        Veľký apoštol ruženca zomrel 5. októbra 1926 vo veku 85 rokov, na obojstranný zápal pľúc. Pochovaný bol k nohám trónu jeho láskyplnej Kráľovnej, ako si prial.

        Už 8. mája 1934 bol začatý beatifikačný proces. 26. októbra 1980 bol tento bývalý satanista, ktorý konvertoval a stal sa šíriteľom modlitby ruženca, povýšený k úcte na oltári. Ján Pavol II. pri tejto príležitosti vyhlásil, že život Bartolomeja Longa je „modelom pre dnešných laických katolíkov.“ Jeho pamiatka sa slávi 6. októbra.

        V súčasnej dobe prebieha proces jeho svätorečenia a zároveň sa otvoril aj proces blahorečenia jeho manželky Marianny de Fusco.
        """
        attributedText.append(makeParagraph(from: biography5))
        
        textView.attributedText = attributedText
        
        scrollView.backgroundColor = ColorProvider.shared.backgroundColour
        textView.backgroundColor = ColorProvider.shared.backgroundColour
        contentView.backgroundColor = ColorProvider.shared.backgroundColour
        
        scrollView.tintColor = ColorProvider.shared.backgroundColour
        
        textView.textColor = .black
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        
        contentView.addArrangedSubview(textView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func makeMutableHeading(from text: String, size: Int = 18)-> NSMutableAttributedString {
        return NSMutableAttributedString(
            string: "\n\(text)\n\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: CGFloat(size)),
                .foregroundColor: UIColor.black
            ]
        )
    }
    
    private func makeHeading(from text: String, size: Int = 18)-> NSAttributedString {
        return NSAttributedString(
            string: "\n\n\(text)\n\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: CGFloat(size)),
                .foregroundColor: UIColor.black
            ]
        )
    }
    
    private func makeParagraph(from text: String)-> NSAttributedString {
        return NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: CGFloat(14)),
            ]
        )
    }
}
