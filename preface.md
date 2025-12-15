# Preface

# Writing the Bitcoin Book

I (Andreas) first stumbled upon Bitcoin in mid-2011. My immediate reaction was more or less "Pfft\! Nerd money\!" and I ignored it for another six months, failing to grasp its importance. This is a reaction that I have seen repeated among many of the smartest people I know, which gives me some consolation. The second time I came across Bitcoin, in a mailing list discussion, I decided to read the whitepaper written by Satoshi Nakamoto and see what it was all about. I still remember the moment I finished reading those nine pages, when I realized that Bitcoin was not simply a digital currency, but a network of trust that could also provide the basis for so much more than just currencies. The realization that "this isn’t money, it’s a decentralized trust network," started me on a four-month journey to devour every scrap of information about Bitcoin I could find. I became obsessed and enthralled, spending 12 or more hours each day glued to a screen, reading, writing, coding, and learning as much as I could. I emerged from this state of fugue, more than 20 pounds lighter from lack of consistent meals, determined to dedicate myself to working on Bitcoin.

Two years later, after creating a number of small startups to explore various Bitcoin-related services and products, I decided that it was time to write my first book. Bitcoin was the topic that had driven me into a frenzy of creativity and consumed my thoughts; it was the most exciting technology I had encountered since the internet. It was now time to share my passion about this amazing technology with a broader audience.

# Intended Audience

This book is mostly intended for coders. If you can use a programming language, this book will teach you how cryptographic currencies work, how to use them, and how to develop software that works with them. The first few chapters are also suitable as an in-depth introduction to Bitcoin for noncoders—those trying to understand the inner workings of Bitcoin and cryptocurrencies.

# Why Are There Bugs on the Cover?

The leafcutter ant is a species that exhibits highly complex behavior in a colony super-organism, but each individual ant operates on a set of simple rules driven by social interaction and the exchange of chemical scents (pheromones). Per Wikipedia: "Next to humans, leafcutter ants form the largest and most complex animal societies on Earth." Leafcutter ants don’t actually eat leaves, but rather use them to farm a fungus, which is the central food source for the colony. Get that? These ants are farming\!

Although ants form a caste-based society and have a queen for producing offspring, there is no central authority or leader in an ant colony. The highly intelligent and sophisticated behavior exhibited by a multimillion-member colony is an emergent property from the interaction of the individuals in a social network.

Nature demonstrates that decentralized systems can be resilient and can produce emergent complexity and incredible sophistication without the need for a central authority, hierarchy, or complex parts.

Bitcoin is a highly sophisticated decentralized trust network that can support myriad financial processes. Yet, each node in the Bitcoin network follows a few simple rules. The interaction between many nodes is what leads to the emergence of the sophisticated behavior, not any inherent complexity or trust in any single node. Like an ant colony, the Bitcoin network is a resilient network of simple nodes following simple rules that together can do amazing things without any central coordination.

# Conventions Used in This Book

The following typographical conventions are used in this book:

  - *Italic*  
    Indicates new terms, URLs, email addresses, filenames, and file extensions.

  - Constant width  
    Used for program listings, as well as within paragraphs to refer to program elements such as variable or function names, databases, data types, environment variables, statements, and keywords.

  - **`Constant width bold`**  
    Shows commands or other text that should be typed literally by the user.

  - *Constant width italic*  
    Shows text that should be replaced with user-supplied values or by values determined by context.

<div class="tip">

This element signifies a tip or suggestion.

</div>

<div class="note">

This element signifies a general note.

</div>

<div class="warning">

This element indicates a warning or caution.

</div>

# Code Examples

All the code snippets can be replicated on most operating systems with a minimal installation of compilers and interpreters for the corresponding languages. Where necessary, we provide basic installation instructions and step-by-step examples of the output of those instructions.

Some of the code snippets and code output have been reformatted for print. In all such cases, the lines have been split by a backslash (\\) character, followed by a newline character. When transcribing the examples, remove those two characters and join the lines again and you should see identical results as shown in the example.

All the code snippets use real values and calculations where possible, so that you can build from example to example and see the same results in any code you write to calculate the same values.

# Using Code Examples

This book is here to help you get your job done. In general, if example code is offered with this book, you may use it in your programs and documentation. You do not need to contact us for permission unless you’re reproducing a significant portion of the code. For example, writing a program that uses several chunks of code from this book does not require permission. Selling or distributing examples from O’Reilly books does require permission. Answering a question by citing this book and quoting example code does not require permission. Incorporating a significant amount of example code from this book into your product’s documentation does require permission.

We appreciate, but do not require, attribution. An attribution usually includes the title, author, publisher, and ISBN. For example: “*Mastering Bitcoin*, 3rd ed., by Andreas M. Antonopoulos and David A. Harding (O’Reilly). Copyright 2024 David Harding, ISBN 978-1-098-15009-9.”

Some editions of this book are offered under an open source license, such as [CC-BY-NC](https://oreil.ly/RzUHE), in which case the terms of that license apply.

If you feel your use of code examples falls outside fair use or the permission given above, feel free to contact us at permissions@oreilly.com.

# Changes Since the Previous Edition

A particular focus in the third edition has been modernizing the 2017 second edition text and the remaining 2014 first edition text. In addition, many concepts that are relevant to contempory Bitcoin development in 2023 have been added:

  - [???](#ch04_keys_addresses)  
    We rearranged the address info so that we work through everything in historical order, adding a new section with P2PK (where "address" was "IP address"), refreshed the previous P2PKH and P2SH sections, and then added new sections for segwit/bech32 and taproot/bech32m.

  - Old Chapters 6 and 7  
    Text from previous versions of Chapter 6, "Transactions," and Chapter 7, "Advanced Transactions," has been rearranged and expanded across four new chapters: \#c\_transactions (the structure of transactions), \#c\_authorization\_authentication, \#c\_signatures, and \#tx\_fees.

  - [???](#c_transactions)  
    We added almost entirely new text describing the structure of a transaction.

  - [???](#c_authorization_authentication)  
    We added new text about MAST, P2C, scriptless multisignatures, taproot, and tapscript.

  - [???](#c_signatures)  
    We revised the ECDSA text and added new text about schnorr signatures, multisignatures, and threshold signatures.

  - [???](#tx_fees)  
    We added almost entirely new text about fees, RBF and CPFP fee bumping, transaction pinning, package relay, and CPFP carve-out.

  - [???](#bitcoin_network_ch08)  
    We added text about compact block relay, added a significant update to bloom filters that better describes their privacy problems, and new text about compact block filters.

  - [???](#blockchain)  
    We added text about signet.

  - [???](#mining)  
    We added text about BIP8 and speedy trial.

  - Appendixes  
    We removed library-specific appendixes. After the appendix containing the original whitepaper, we added a new appendix describing how the implementation and properties of Bitcoin differ from those proposed in the whitepaper.

# Bitcoin Addresses and Transactions in This Book

The Bitcoin addresses, transactions, keys, QR codes, and blockchain data used in this book are, for the most part, real. That means you can browse the blockchain, look at the transactions offered as examples, retrieve them with your own scripts or programs, etc.

However, note that the private keys used to construct addresses are either printed in this book or have been "burned." That means if you send money to any of these addresses, the money will either be lost forever, or in some cases everyone who can read the book can take it using the private keys printed in here.

<div class="warning">

DO NOT SEND MONEY TO ANY OF THE ADDRESSES IN THIS BOOK. Your money will be taken by another reader or lost forever.

</div>

# O’Reilly Online Learning

<div class="note">

For more than 40 years, O’Reilly Media has provided technology and business training, knowledge, and insight to help companies succeed.

</div>

Our unique network of experts and innovators share their knowledge and expertise through books, articles, and our online learning platform. O’Reilly’s online learning platform gives you on-demand access to live training courses, in-depth learning paths, interactive coding environments, and a vast collection of text and video from O’Reilly and 200+ other publishers. For more information, visit https://oreilly.com.

# How to Contact Us

Please address comments and questions concerning this book to the publisher:

O’Reilly Media, Inc.

1005 Gravenstein Highway North

Sebastopol, CA 95472

800-889-8969 (in the United States or Canada)

707-829-7019 (international or local)

707-829-0104 (fax)

support@oreilly.com

https://www.oreilly.com/about/contact.html

We have a web page for this book, where we list errata, examples, and any additional information. You can access this page at <https://oreil.ly/MasteringBitcoin3e>.

For news and information about our books and courses, visit <https://oreilly.com>.

Find us on LinkedIn: <https://linkedin.com/company/oreilly-media>.

Follow us on Twitter: <https://twitter.com/oreillymedia>.

Watch us on YouTube: <https://youtube.com/oreillymedia>.

# Contacting the Authors

You can contact Andreas M. Antonopoulos on his personal site:

https://antonopoulos.com

.

Follow Andreas on Facebook: <https://facebook.com/AndreasMAntonopoulos>.

Follow Andreas on Twitter: <https://twitter.com/aantonop>.

Follow Andreas on LinkedIn: <https://linkedin.com/company/aantonop>.

Many thanks to all of Andreas’s patrons who support his work through monthly donations. You can follow his Patreon page here: <https://patreon.com/aantonop>.

Information about *Mastering Bitcoin*, as well as Andreas’s Open Edition and translations, is available on <https://bitcoinbook.info>.

You can contact David A. Harding on his personal site: <https://dtrt.org>.

# Acknowledgments for the First and Second Editions

*By Andreas M. Antonopoulos*

This book represents the efforts and contributions of many people. I am grateful for all the help I received from friends, colleagues, and even complete strangers, who joined me in this effort to write the definitive technical book on cryptocurrencies and Bitcoin.

It is impossible to make a distinction between the Bitcoin technology and the Bitcoin community, and this book is as much a product of that community as it is a book on the technology. My work on this book was encouraged, cheered on, supported, and rewarded by the entire Bitcoin community from the very beginning until the very end. More than anything, this book has allowed me to be part of a wonderful community for two years and I can’t thank you enough for accepting me into this community. There are far too many people to mention by name—people I’ve met at conferences, events, seminars, meetups, pizza gatherings, and small private gatherings, as well as many who communicated with me by Twitter, on reddit, on bitcointalk.org, and on GitHub who have had an impact on this book. Every idea, analogy, question, answer, and explanation you find in this book was at some point inspired, tested, or improved through my interactions with the community. Thank you all for your support; without you this book would not have happened. I am forever grateful.

The journey to becoming an author starts long before the first book, of course. My first language (and schooling) was Greek, so I had to take a remedial English writing course in my first year of university. I owe thanks to Diana Kordas, my English writing teacher, who helped me build confidence and skills that year. Later, as a professional, I developed my technical writing skills on the topic of data centers, writing for *Network World* magazine. I owe thanks to John Dix and John Gallant, who gave me my first writing job as a columnist at *Network World* and to my editor Michael Cooney and my colleague Johna Till Johnson who edited my columns and made them fit for publication. Writing 500 words a week for four years gave me enough experience to eventually consider becoming an author.

Thanks also to those who supported me when I submitted my book proposal to O’Reilly by providing references and reviewing the proposal. Specifically, thanks to John Gallant, Gregory Ness, Richard Stiennon, Joel Snyder, Adam B. Levine, Sandra Gittlen, John Dix, Johna Till Johnson, Roger Ver, and Jon Matonis. Special thanks to Richard Kagan and Tymon Mattoszko, who reviewed early versions of the proposal and Matthew Taylor, who copyedited the proposal.

Thanks to Cricket Liu, author of the O’Reilly title *DNS and BIND*, who introduced me to O’Reilly. Thanks also to Michael Loukides and Allyson MacDonald at O’Reilly, who worked for months to help make this book happen. Allyson was especially patient when deadlines were missed and deliverables delayed as life intervened in our planned schedule. For the second edition, I thank Timothy McGovern for guiding the process, Kim Cofer for patiently editing, and Rebecca Panzer for illustrating many new diagrams.

The first few drafts of the first few chapters were the hardest, because Bitcoin is a difficult subject to unravel. Every time I pulled on one thread of the Bitcoin technology, I had to pull on the whole thing. I repeatedly got stuck and a bit despondent as I struggled to make the topic easy to understand and create a narrative around such a dense technical subject. Eventually, I decided to tell the story of Bitcoin through the stories of the people using Bitcoin and the whole book became a lot easier to write. I owe thanks to my friend and mentor, Richard Kagan, who helped me unravel the story and get past the moments of writer’s block. I thank Pamela Morgan, who reviewed early drafts of each chapter in the first and second edition of the book and asked the hard questions to make them better. Also, thanks to the developers of the San Francisco Bitcoin Developers Meetup group as well as Taariq Lewis and Denise Terry for helping test the early material. Thanks also to Andrew Naugler for infographic design.

During the development of the book, I made early drafts available on GitHub and invited public comments. More than a hundred comments, suggestions, corrections, and contributions were submitted in response. Those contributions are explicitly acknowledged, with my thanks, in [Early Release Draft (GitHub Contributions)](#github_contrib). Most of all, my sincere thanks to my volunteer GitHub editors Ming T. Nguyen (1st edition) and Will Binns (2nd edition), who worked tirelessly to curate, manage, and resolve pull requests, issue reports, and perform bug fixes on GitHub.

Once the book was drafted, it went through several rounds of technical review. Thanks to Cricket Liu and Lorne Lantz for their thorough review, comments, and support.

Several Bitcoin developers contributed code samples, reviews, comments, and encouragement. Thanks to Amir Taaki and Eric Voskuil for example code snippets and many great comments; Chris Kleeschulte for contributing information about Bitcore; Vitalik Buterin and Richard Kiss for help with elliptic curve math and code contributions; Gavin Andresen for corrections, comments, and encouragement; Michalis Kargakis for comments, contributions, and btcd writeup; and Robin Inge for errata submissions improving the second print. In the second edition, I again received a lot of help from many Bitcoin Core developers, including Eric Lombrozo who demystified segregated witness, Luke Dashjr who helped improve the chapter on transactions, Johnson Lau who reviewed segregated witness and other chapters, and many others. I owe thanks to Joseph Poon, Tadge Dryja, and Olaoluwa Osuntokun who explained Lightning Network, reviewed my writing, and answered questions when I got stuck.

I owe my love of words and books to my mother, Theresa, who raised me in a house with books lining every wall. My mother also bought me my first computer in 1982, despite being a self-described technophobe. My father, Menelaos, a civil engineer who just published his first book at 80 years old, was the one who taught me logical and analytical thinking and a love of science and engineering.

Thank you all for supporting me throughout this journey.

# Acknowledgments for the Third Edition

*By David A. Harding*

The introduction to the noninteractive schnorr signature protocol that starts with first describing the interactive schnorr identity protocol in [???](#schnorr_signatures) was heavily influenced by the introduction to the subject in "Borrommean Ring Signatures" (2015) by Gregory Maxwell and Andrew Poelstra. I am deeply indebted to each of them for all of their freely provided assistance over the past decade.

Invaluable technical reviews on drafts of this manuscript were provided by Jorge Lesmes, Olaoluwa Osuntokun, René Pickhardt, and Mark "Murch" Erhardt. In particular, Murch’s incredibly in-depth and insightful review, and his willingness to evaluate multiple iterations of the same text, have elevated the quality of this book beyond my highest expectations.

I also owe a debt of gratitude to Jimmy Song for suggesting me for this project, to my coauthor Andreas for allowing me to update his bestselling text, to Angela Rufino for guiding me through the O’Reilly authorship process, and to all of the other staff at O’Reilly for making the writing of the third edition a pleasant and productive experience.

Finally, I don’t know how I can thank all of the Bitcoin contributors who have helped me on my journey—​from creating the software I use, to teaching me how it works, to helping me pass on what little knowledge I’ve gained. There are too many of you to list your names, but I think of you often and know that my contributions to this book would not have been possible without all that you’ve done for me.

# Early Release Draft (GitHub Contributions)

Many contributors offered comments, corrections, and additions to the early-release draft on GitHub. Thank you all for your contributions to this book.

Following is a list of notable GitHub contributors, including their GitHub ID in parentheses:

Abdussamad Abdurrazzaq

(AbdussamadA)

Adán SDPC (aesedepece)

Akira Chiku (achiku)

Alex Waters (alexwaters)

Andrew Donald Kennedy (grkvlt)

Andrey Esaulov (andremaha)

andronoob

AnejaBK

Appaji (CITIZENDOT)

ariesunny

Arthur O'Dwyer (Quuxplusone)

bargitta

Basem Alasi (Bamskki)

bisqfan

bitcoinctf

blip151

Bryan Gmyrek (physicsdude)

Carlos Sims (simsbluebox)

Casey Flynn (cflynn07)

cclauss

Chapman Shoop (belovachap)

chrisd95

Christie D'Anna (avocadobreath)

Cihat Imamoglu (cihati)

Cody Scott (Siecje)

coinradar

Cragin Godley (cgodley)

Craig Dodd (cdodd)

dallyshalla

Dan Nolan (Dan-Nolan)

Dan Raviv (danra)

Darius Kramer (dkrmr)

Darko Janković (trulex)

David Huie (DavidHuie)

didongke

Diego Viola (diegoviola)

Dimitris Tsapakidis (dimitris-t)

Dirk Jäckel (biafra23)

Dmitry Marakasov (AMDmi3)

drakos (Jolly-Pirate)

drstrangeM

Ed Eykholt (edeykholt)

Ed Leafe (EdLeafe)

Edward Posnak (edposnak)

Elias Rodrigues (elias19r)

Eric Voskuil (evoskuil)

Eric Winchell (winchell)

Erik Wahlström (erikwam)

effectsToCause (vericoin)

Esteban Ordano (eordano)

ethers

Evlix

fabienhinault

Fan (whiteath)

Felix Filozov (ffilozov)

Francis Ballares (fballares)

François Wirion (wirion)

Frank Höger (francyi)

Gabriel Montes (gabmontes)

Gaurav Rana (bitcoinsSG)

genjix

Geremia

Gerry Smith (Hermetic)

gmr81

Greg (in3rsha)

Gregory Trubetskoy (grisha)

Gus (netpoe)

halseth

harelw

Harry Moreno (morenoh149)

Hennadii Stepanov (hebasto)

Holger Schinzel (schinzelh)

Ioannis Cherouvim (cherouvim)

Ish Ot Jr. (ishotjr)

ivangreene

James Addison (jayaddison)

Jameson Lopp (jlopp)

Jason Bisterfeldt (jbisterfeldt)

Javier Rojas (fjrojasgarcia)

Jordan Baczuk (JBaczuk)

Jeremy Bokobza (bokobza)

JerJohn15

jerzybrzoska

Jimmy DeSilva (jimmydesilva)

Jo Wo (jowo-io)

Joe Bauers (joebauers)

joflynn

Johnson Lau (jl2012)

Jonathan Cross (jonathancross)

Jorgeminator

jwbats

Kai Bakker (kaibakker)

kollokollo

krupawan5618

kynnjo

Liangzx

lightningnetworkstores

lilianrambu

Liu Yue (lyhistory)

Lobbelt

Lucas Betschart (lclc)

Matt Wesley (MatthewWesley)

Magomed Aliev (30mb1)

Mai-Hsuan Chia (mhchia)

Marco Falke (MarcoFalke)

María Martín (mmartinbar)

Marcus Kiisa (mkiisa)

Mark Erhardt (Xekyo)

Mark Pors (pors)

Martin Harrigan (harrigan)

Martin Vseticka (MartyIX)

Marzig (marzig76)

Matt McGivney (mattmcgiv)

Matthijs Roelink (Matthiti)

Maximilian Reichel (phramz)

MG-ng (MG-ng)

Michalis Kargakis (kargakis)

Michael C. Ippolito

(michaelcippolito)

Michael Galero (mikong)

Michael Newman

(michaelbnewman)

Mihail Russu (MihailRussu)

mikew (mikew)

milansismanovic

Minh T. Nguyen (enderminh)

montvid

Morfies (morfies)

Nagaraj Hubli (nagarajhubli)

Nekomata (nekomata-3)

nekonenene

Nhan Vu (jobnomade)

Nicholas Chen (nickycutesc)

Ning Shang (syncom)

Oge Nnadi (ogennadi)

Oliver Maerz (OliverMaerz)

Omar Boukli-Hacene (oboukli)

Óscar Nájera (Titan-C)

Parzival (Parz-val)

Paul Desmond Parker

(sunwukonga)

Philipp Gille (philippgille)

ratijas

rating89us

Raul Siles (raulsiles)

Reproducibility Matters

(TheCharlatan)

Reuben Thomas (rrthomas)

Robert Furse (Rfurse)

Roberto Mannai (robermann)

Richard Kiss (richardkiss)

rszheng

Ruben Alexander (hizzvizz)

Sam Ritchie (sritchie)

Samir Sadek (netsamir)

Sandro Conforto (sandroconforto)

Sanjay Sanathanan (sanjays95)

Sebastian Falbesoner (theStack)

Sergei Tikhomirov (s-tikhomirov)

Sergej Kotliar (ziggamon)

Seiichi Uchida (topecongiro)

shaysw

Simon de la Rouviere (simondlr)

simone-cominato

sindhoor7

Stacie (staciewaleyko)

Stephan Oeste (Emzy)

Stéphane Roche (Janaka-Steph)

takaya-imai

Thiago Arrais (thiagoarrais)

Thomas Kerin (afk11)

Tochi Obudulu (tochicool)

Tosin (tkuye)

Vasil Dimov (vasild)

venzen

Vlad Stan (motorina0)

Vijay Chavda (VijayChavda)

Vincent Déniel (vincentdnl)

weinim

wenxiaolong (QingShiLuoGu)

wenzhenxiang

Will Binns (wbnns)

wintercooled

wjx

wll2007

Wojciech Langiewicz (wlk)

Yancy Ribbens (yancyribbens)

yjjnls

Yoshimasa Tanabe (emag)

yuntai

yurigeorgiev4

Zheng Jia (zhengjia)

Zhou Liang (zhouguoguo)
