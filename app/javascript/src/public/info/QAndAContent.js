import React from 'react'
import { buildFeedbackPath, buildRegisterPath } from '../../util/routeUtil'

const testUrl = 'https://testi.hirviurheilu.com'

export default function QAndAContent() {
  return (
    <div>
      <h2>Yleistä Hirviurheilu-palvelusta</h2>
      <div className="cards">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mikä on Hirviurheilu?</div>
            <div className="card__middle-row">Hirviurheilu on helppokäyttöinen, internet-pohjainen tulospalvelu
              metsästäjäliiton urheilulajeihin.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä lajeja Hirviurheilu tukee?</div>
            <div className="card__middle-row">
              <ul>
                <li>Hirvenhiihto ja hirvenhiihtely</li>
                <li>Hirvenjuoksu ja hirvikävely</li>
                <li>Ilmahirvi ja ilmaluodikko</li>
                <li>Metsästyshirvi ja metsästysluodikko</li>
                <li>Metsästyshaulikko ja metsästystrap</li>
                <li>Pohjoismainen metsästysammunta</li>
                <li>Eurooppalainen metsästysammunta</li>
              </ul>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä kilpailumuotoja palvelu tukee?</div>
            <div className="card__middle-row">
              <ul>
                <li>Normaali yksilökilpailu</li>
                <li>Joukkuekilpailu</li>
                <li>Viesti (hirvenhiihto ja hirvenjuoksu)</li>
                <li>Cup</li>
              </ul>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä voin tehdä, jos palveluun tarvittaisiin mielestäni ehdottomasti uusi
              ominaisuus?
            </div>
            <div className="card__middle-row">
              <a href={buildFeedbackPath()}>Ota rohkeasti yhteyttä ja kerro ideasi!</a>
            </div>
          </div>
        </div>
      </div>
      <h2>Palvelun hyödyt</h2>
      <div className="cards">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä hyötyä palvelusta on kilpailun järjestäjille?</div>
            <div className="card__middle-row">
              <ul>
                <li>Tulospalvelun järjestäminen onnistuu palvelun kautta vaivattomasti. Palvelun käyttöönotto on
                  erittäin nopeaa ja sen käyttäminen helppoa.
                </li>
                <li>Palvelu tarjoaa luotettavan tavan tulosten laskemiseen.</li>
                <li>
                  Järjestäjien ei tarvitse huolehtia lähtölistojen tai eräluetteloiden ja tulosten julkaisemisesta,
                  koska ne ovat kaikkien saatavilla internetissä ilman ylimääräisiä toimenpiteitä.
                </li>
                <li>
                  Palvelu on hyvin joustava. Kilpailun järjestäjä voi esimerkiksi syöttää juuri ne sarjat, jotka
                  kilpailussa tullaan järjestämään.
                  Mitään tiettyjä sarjoja ei tarvitse käyttää.
                </li>
                <li>Järjestäjät voivat ladata tulosraportin myös lehdistölle sopivassa muodossa.</li>
                <li>Kaikki palveluun tehtävät uudet ominaisuudet ovat automaattisesti järjestäjien käytössä ilman
                  erillistä päivitystä.
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä hyötyä palvelusta on kilpailijoille?</div>
            <div className="card__middle-row">
              <ul>
                <li>Ennakkoon ilmoittautuneilla kilpailijoilla on mahdollisuus katsoa lähtölistat tai eräluettelot
                  etukäteen internetistä.
                </li>
                <li>Kilpailijat näkevät tulokset reaaliaikaisina internetin kautta välittömästi heti, kun toimitsijat
                  syöttävät ne järjestelmään.
                </li>
                <li>
                  Tulokset ovat näkyvillä mahdollisimman yksityiskohtaisesti, joten kilpailijat
                  voivat helposti varmistaa, että tulokset on syötetty ja laskettu oikein.
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
      <h2>Käyttö – kaikki lajit</h2>
      <div className="results-cards">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Kuinka palvelun käyttöönotto tapahtuu?</div>
            <div className="card__middle-row">
              Hirviurheilu-palvelun käyttöönotto on erittäin helppoa:
              <a href={buildRegisterPath()}>Rekisteröidy palveluun</a>
              ja pääset syöttämään tulospalveluun ensimmäisen kilpailusi tiedot.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä sarjoja tulospalvelussa käytetään?</div>
            <div className="card__middle-row">
              Voit itse päättää täysin, mitä sarjoja kilpailuusi syötät.
              Kilpailun luomisen nopeuttamiseksi tarjolla on myös valmiit oletussarjat, jotka perustuvat lajikohtaisesti
              Metsästäjäliiton määrittämiin sarjajakoihin. Näiden käyttäminen ei ole kuitenkaan pakollista,
              ja vaikka niitä käyttäisitkin, voit tehdä oletussarjoihin mitä tahansa muutoksia.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä asioita pitää tehdä ennen kilpailua?</div>
            <div className="card__middle-row">
              Ennen kilpailua sinun täytyy lisätä tulospalveluun kilpailun
              perustiedot kuten sen nimi, ajankohta ja paikkakunta sekä sarjojen nimet.
              Tämän jälkeen voit lisätä sarjoihin ilmoittautuneita kilpailijoita.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Voiko useampi toimitsija käyttää järjestelmää yhtä aikaa?</div>
            <div className="card__middle-row">Kyllä voi. Kilpailun perustaja voi kutsua muita henkilöitä toimitsijaksi
              samaan kilpailuun.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Onko mahdollista kokeilla palvelun käyttämistä jossain?</div>
            <div className="card__middle-row">
              Osoitteessa
              <a href={testUrl} target="_blank" rel="noreferrer">{testUrl}</a>
              voit harjoitella toimitsijana toimimista. Testipalvelua ei ole tarkoitettu käytettäväksi oikeiden
              kilpailuiden tuloslaskentaan.
            </div>
            <div className="card__middle-row">
              Huom! Testipalvelu ({testUrl}) ja varsinainen palvelu (https://www.hirviurheilu.com)
              käyttävät eri tietokantoja, joten toiseen palveluun luodut käyttäjätunnukset eivät ole käytössä toisessa.
              Voit kuitenkin halutessasi käyttää molemmissa samoja kirjautumistietoja (sähköposti ja salasana).
            </div>
          </div>
        </div>
      </div>
      <h2>Käyttö – liikuntalajit (hirvenhiihto, hirvenjuoksu, hirvenhiihtely, hirvikävely)</h2>
      <div className="results-cards">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Kuinka lähtölistat luodaan?</div>
            <div className="card__middle-row">
              Kilpailua lisätessäsi voit valita kahdesta vaihtoehdosta sinulle sopivamman:
              <ul>
                <li>Lähtölistojen luonti sarjoittain</li>
                <li>Lähtöaikojen määrittäminen suoraan kilpailijoille</li>
              </ul>
            </div>
            <div className="card__middle-row">
              Ensimmäinen vaihtoehto on kätevä erityisesti silloin, kun kilpailijat ilmoittautuvat
              etukäteen ja lähtölistat voidaan näin ollen luoda valmiiksi ennen kilpailua.
              Lähtölistojen luonti on helppoa. Kun olet lisännyt kilpailijat, mene toimitsijan sivuilla
              Kilpailijat-sivulle. Sivulla sinun pitää kertoa, mikä on sarjan
              lähtöaika ja ensimmäinen kilpailunumero. Lisäksi voit päättää, noudattaako
              kilpailijoiden lähtöjärjestys heidän lisäämisjärjestystä vai arvotaanko se.
              Näiden asetusten jälkeen saat luotua yhden sarjan lähtölistan automaattisesti.
            </div>
            <div className="card__middle-row">
              Toinen vaihtoehto sopii paremmin kilpailuihin, joissa kilpailijat lisätään järjestelmään
              vasta kisapaikalla, jolloin heidän ilmoittautumisjärjestyksensä on samalla heidän
              lähtöjärjestyksensä sarjoista välittämättä. Tässä vaihtoehdossa sinun täytyy määrittää
              kilpailijan lähtönumero ja -aika samalla, kun syötät kilpailijan muut tiedot.
              Lähtölista syntyy näin samalla, kun syötät kilpailijoita.
            </div>
            <div className="card__middle-row">
              Huom! Riippumatta siitä kumman tavan valitset voit määrittää yksittäiselle kilpailijalle
              minkä tahansa lähtöajan ja -numeron. Eli vaikka kilpailijat lähtisivätkin sarjoittain,
              järjestelmään pystyy aina lisäämään jälki-ilmoittautuneita lähtölistan loppupäähän.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Voiko kilpailijoita lisätä vielä sen jälkeen, kun lähtölista on jo luotu?</div>
            <div className="card__middle-row">
              Kyllä voi. Vaikka osa kilpailijoista olisi jo tullut
              maaliin ja heille olisi jopa syötetty tuloksia, voit edelleen lisätä uusia
              kilpailijoita. Kun lisäät kilpailijoita lähtölistan luonnin jälkeen,
              sinun täytyy vain itse määrittää heille lähtöaika sekä kilpailunumero.
              Palvelu tosin ehdottaa automaattisesti sopivaa aikaa sekä numeroa.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Miten tulosten syöttäminen tapahtuu kilpailun aikana?</div>
            <div className="card__middle-row">
              Tulosten syöttämiseen on kolme vaihtoehtoa. Voit itse päättää,
              mitä vaihtoehtoa haluat käyttää tulosten syöttämiseen.
              <ol>
                <li>
                  Pikasyöttö: Ns. pikasyötössä voit syöttää yhden kilpailijan aika-,
                  arviointi- tai ammuntatiedon kirjoittamalla kilpailijan numeron ja
                  tuloksen. Esimerkiksi kilpailijan 13 arviot 118 ja 87 metriä
                  syötetään muodossa 13,118,87. Pikasyöttö on kaikista nopein tapa syöttää
                  tuloksia.
                </li>
                <li>
                  Sarja- ja tulospaikkakohtainen syöttö: Tässä näkymässä voit syöttää
                  yhden sarjan esimerkiksi kaikki ammuntatulokset kerralla. Samanlaiset
                  näkymät löytyvät siis myös saapumisajoille ja arvioille. Tämä
                  vaihtoehto sopii hyvin tilanteeseen, jossa yhden toimitsijan vastuulla
                  on yksi tulospaikka. Lisäksi se antaa hyvän kokonaiskuvan sarjojen
                  tilanteesta.
                </li>
                <li>
                  Kilpailijakohtainen lomake: Jos kilpailijan tiedot avaa sen jälkeen,
                  kun lähtölista on luotu, hänelle voi syöttää samassa näkymässä kaikki tulostiedot kerralla.
                </li>
              </ol>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Pitääkö ammuntatulokset syöttää summana vai yksittäisinä laukauksina?</div>
            <div className="card__middle-row">Saat päättää tämän itse. Molemmat vaihtoehdot ovat mahdollisia.</div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Kuinka sarjojen oikeat arviointimatkat määritetään?</div>
            <div className="card__middle-row">
              Oikeat arviointimatkat määritetään kilpailunumeroiden perusteella.
              Voit esimerkiksi määrittää, että numeroiden 1-50 oikeat matkat ovat 100 ja 120 metriä
              ja että numeroilla 51-100 matkat ovat 95 ja 125 metriä.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä asioita täytyy tehdä kilpailun jälkeen?</div>
            <div className="card__middle-row">
              Kun olet syöttänyt kaikille kilpailijoille tulokset sekä määrittänyt kilpailulle oikeat arviointimatkat,
              muista merkitä vielä kilpailu päättyneeksi Yhteenveto-sivulta. Tämä vaikuttaa mm. siihen,
              että tarkat arviointitiedot julkaistaan kilpailijoille. Niin kauan kuin kilpailu on kesken,
              kilpailijat eivät näe arviointitietojen osalta muuta kuin pisteet.
            </div>
          </div>
        </div>
      </div>
      <h2>Käyttö – ammuntalajit</h2>
      <div className="results-cards">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Kuinka eräluettelot luodaan?</div>
            <div className="card__middle-row">
              Eräluetteloiden tekeminen alkaa sillä, että kilpailun perustiedoissa määritetään ratojen määrä sekä
              ammuntapaikkojen määrä / rata. Näitä tietoja käytetään sekä alkukilpailun että loppukilpailun
              eräluetteloiden tekemiseen.
            </div>
            <div className="card__middle-row">
              Alkukilpailun eräluettelot on helpointa tehdä arpomalla ne sarjakohtaisesti sen jälkeen,
              kun sarjan kilpailijat on syötetty. Voit määrittää hyvin joustavasti, miten kilpailijat sijoitetaan eriin,
              esimerkiksi joka toiselle paikalla tai jättämällä tiettyjä paikkoja tyhjiksi.
            </div>
            <div className="card__middle-row">
              Loppukilpailun eräluettelot voi luoda samaan tyyliin kuin alkukilpailuissa. Oleellinen ero on siinä,
              että toimitsija määrittää sarjakohtaisesti, kuinka monta kilpailijaa loppukilpailuun pääsee ja ohjelma
              poimii kilpailijat automaattisesti.
            </div>
            <div className="card__middle-row">
              Eräluetteloita pystyy myös luomaan ja muokkaamaan yksittäin ilman automaattista sijoittelua.
              Erien hallinta -sivulta voi sekä määrittää erien tiedot että asetella niihin kilpailijat.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Miten tulosten syöttäminen tapahtuu kilpailun aikana?</div>
            <div className="card__middle-row">
              Tulosten syöttämiseen on peräti neljä vaihtoehtoa. Voit itse päättää,
              mitä vaihtoehtoa haluat käyttää tulosten syöttämiseen.
              <ol>
                <li>
                  Pikasyöttö: Ns. pikasyötössä voit syöttää yhden kilpailijan ammuntatuloksen kirjoittamalla kilpailijan
                  numeron ja
                  tuloksen. Tallennus tapahtuu erikseen alku- ja loppukilpailulle.
                </li>
                <li>
                  Ammunta sarjoittain: Tässä näkymässä näet yhden sarjan kaikki kilpailijat kerralla ja voit tallentaa
                  heille
                  ammuntatuloksen joko summana tai laukauksittain.
                </li>
                <li>
                  Ammunta erittäin: Tämä näkymä on samanlainen kuin ammunta sarjoittain mutta se listaa kilpailijat
                  erittäin.
                </li>
                <li>
                  Kilpailijakohtainen lomake: Tuloksen voi syöttää myös kilpailijan lomakkeella.
                  Tämä sopii lähinnä yksittäisen kilpailijan tietojen päivittämiseen.
                </li>
              </ol>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Miten uusintalaukaukset tallennetaan?</div>
            <div className="card__middle-row">Voit käyttää uusintalaukausten tallentamiseen samoja menetelmiä kuin alku-
              ja loppukilpailuillekin.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Pitääkö ammuntatulokset syöttää summana vai yksittäisinä laukauksina?</div>
            <div className="card__middle-row">Saat päättää tämän itse. Molemmat vaihtoehdot ovat mahdollisia.</div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Mitä asioita täytyy tehdä kilpailun jälkeen?</div>
            <div className="card__middle-row">
              Kun olet syöttänyt kaikille kilpailijoille tulokset, merkitse vielä kilpailu päättyneeksi
              Yhteenveto-sivulta.
              Ohjelma tarkastaa, ettei keneltäkään kilpailijalta esimerkiksi puutu laukauksia ja poistaa tuloksista
              teksti, joka kertoo kilpailun olevan kesken.
            </div>
          </div>
        </div>
      </div>
      <h2>Joukkuekilpailut</h2>
      <div className="cards">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Kuinka joukkuekilpailut tehdään?</div>
            <div className="card__middle-row">
              Joukkuekilpailuiden tekeminen on toimitsijalle erittäin helppoa. Riittää, että annat kilpailulle nimen
              (esim. ”Naiset”),
              määrität siihen kuuluvat sarjat (esim. ”N”, ”N50” ja ”T17”) sekä kerrot kuinka monta kilpailijaa
              joukkueeseen kuuluu (esim. 3).
              Tämän jälkeen Hirviurheilu osaa automaattisesti yhdistää kilpailijat samaan joukkueeseen seuran tai piirin
              perusteella
              ja laskea joukkueelle pisteet.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Voiko samasta seurasta tai piiristä olla useita joukkueita?</div>
            <div className="card__middle-row">
              Kyllä voi. Laitat vain joukkuekilpailun tiedoista tämän asetuksen päälle, niin ohjelma luo automaattisesti
              niin
              monta joukkuetta kuin seurasta tai piiristä on osallistujia. Esim. jos joukkuekilpailuun tulee mukaan 3
              kilpailijaa
              ja seurasta ”Järvikylän AS” on mukana 9 osallistujaa, Hirviurheilu laskeet pisteet joukkueille
              ”Järvikylän AS”, ”Järvikylän AS II” sekä ”Järvikylän AS III”.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Miten Hirviurheilu ottaa huomioon metsästyshaulikon ja -trapin
              uusintalaukaukset?
            </div>
            <div className="card__middle-row">
              Näissä kahdessa lajissa tosiaan ratkaistaan sijojen 1-3 tasapisteet uusinnalla. Tällöin toimitsija voi
              syöttää
              joukkuekilpailun asetuksiin uusintalaukausten tiedot jokaisen uusintaan osallistuvan joukkueen molemmille
              laukojille.
              Hirviurheilu ottaa nämä tiedot huomioon lopullisessa joukkueiden järjestyksessä ja näyttää myös
              uusintalaukaukset
              tuloksissa.
            </div>
          </div>
        </div>
      </div>
      <h2>Cup-kilpailut</h2>
      <div className="cards">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Kuinka cup-kilpailuita luodaan?</div>
            <div className="card__middle-row">
              Cup-kilpailuiden luominen on erittäin helppoa. Mene Toimitsijan etusivulle ja lisää sieltä uusi
              cup-kilpailu.
              Sinun tarvitsee vain kertoa cup-kilpailun nimi ja valita, mistä (osa)kilpailuista cup koostuu.
              Osakilpailut tarkoittavat tässä yhteydessä aivan normaaleja Hirviurheilun kilpailuita,
              joiden tulokset olet palveluun syöttänyt tai tulet syöttämään.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Kuinka cup-sarjat määritetään?</div>
            <div className="card__middle-row">
              Kun lisäät cup-kilpailun ja valitset siihen osakilpailut, järjestelmä luo automaattisesti ensimmäisen
              osakilpailun perusteella cup-sarjat käyttäen kyseisen osakilpailun sarjojen nimiä. Jos nämä sarjat ovat
              myös
              cup-sarjat, sinun ei tarvitse tehdä mitään.
            </div>
            <div className="card__middle-row">
              Voit kuitenkin halutessasi määrittää eri cup-sarjat muokkaamalla cup-kilpailun asetuksia.
              Cup-sarja voi koostua yhdestä tai useammasta osakilpailuiden sarjasta. Esimerkiksi:
              <ul>
                <li>
                  Cup-sarja ”M”, jonka tulokset lasketaan suoraan osakilpailuissa olevan sarjan ”M” perusteella.
                  (Cup-kilpailuiden oletussarjat toimivat tällä periaatteella.)
                </li>
                <li>
                  Cup-sarja ”Miehet”, jonka tulokset lasketaan osakilpailuissa olevien sarjojen ”M”, ”M60” ja ”M70”
                  perusteella.
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Kuinka cup-kilpailuiden tuloslaskenta toimii?</div>
            <div className="card__middle-row">
              Cup-kilpailussa lasketaan tulokset niille sarjoille, jotka olet määrittänyt kuuluvan cup-kilpailun
              sarjoihin
              (ks. edellä). Eri osakilpailuiden kilpailijat yhdistetään yhdeksi henkilöksi kilpailijan nimen
              perusteella.
              Jos siis osakilpailuissa esiintyy kilpailija ”Timo Testinen”, palvelu tunnistaa hänet yhdeksi henkilöksi
              ja osaa laskea hänelle cup-yhteispisteet.
            </div>
            <div className="card__middle-row">
              Cup-yhteispisteet ovat summa osakilpailuiden tuloksista. Voit kuitenkin halutessasi määrittää
              cup-kilpailun asetuksiin esimerkiksi, että kolmesta osakilpailusta yhteispisteisiin lasketaan
              vain kaksi parasta tulosta.
            </div>
          </div>
        </div>
      </div>
      <h2>Tulosten julkaisu</h2>
      <div className="cards">
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Miten tulokset saadaan julkaistua kilpailijoiden nähtäville?</div>
            <div className="card__middle-row">
              Sinun ei tarvitse tehdä mitään erillistoimenpiteitä. Tulospalvelu on täysin reaaliaikainen,
              joten kaikki tulokset ovat näkyvissä koko ajan.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Saako tulokset, lähtöluettelon tai eräluettelon paperille?</div>
            <div className="card__middle-row">
              Tulostaminen onnistuu parhaiten siten, että lataat tuloksen, lähtöluettelon tai eräluettelon
              PDF-tiedostona,
              jonka voit sitten tulostaa paperille.
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card__middle">
            <div className="card__name">Voiko palvelusta tulostaa tuloslistat lehdistölle sopivassa muodossa?</div>
            <div className="card__middle-row">
              Kyllä voi. Kilpailun sivuilta löytyy Lehdistö-sivu, josta saat yksinkertaisten tulosluettelon haluamallesi
              määrälle kilpailijoita / sarja.
            </div>
          </div>
        </div>
      </div>
      <div className="buttons buttons--nav">
        <a className="button button--back" href="/">Takaisin etusivulle</a>
      </div>
    </div>
  )
}
