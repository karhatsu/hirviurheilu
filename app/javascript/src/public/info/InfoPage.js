import React, { useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import Button from '../../common/Button'
import {
  buildAnswersPath,
  buildFeedbackPath,
  buildRegisterPath,
  buildRootPath,
  buildSportsInfoPath,
} from '../../util/routeUtil'
import useTranslation from '../../util/useTranslation'
import useAppData from '../../util/useAppData'
import useTitle from '../../util/useTitle'

export default function InfoPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  const { userId } = useAppData()

  useTitle(t('info'))
  useEffect(() => setSelectedPage(pages.info.main), [setSelectedPage])

  return (
    <div>
      <div className="row">
        <div className="col-xs-12 col-sm-6">
          <a href={buildAnswersPath()} className="card">
            <div className="card__middle">
              <div className="card__name">{t('answersTitle')}</div>
              <div className="card__middle-row">
                Mikä on Hirviurheilu? Mitä palvelun käyttö vaatii? Miksi se on erinomainen vaihtoehto kilpailusi
                tulospalveluksi? Miten palvelua käytetään?
              </div>
            </div>
          </a>
        </div>
        <div className="col-xs-12 col-sm-6">
          <a href="https://testi.hirviurheilu.com" className="card">
            <div className="card__middle">
              <div className="card__name">Testaa palvelua</div>
              <div className="card__middle-row">
                Hirviurheilun testiympäristössä voit kokeilla palvelun käyttöä ja harjoitella toimitsijana olemista.
              </div>
            </div>
          </a>
        </div>
        {!userId && (
          <div className="col-xs-12 col-sm-6">
            <a href={buildRegisterPath()} className="card">
              <div className="card__middle">
                <div className="card__name">Aloita palvelun käyttö</div>
                <div className="card__middle-row">
                  Aloita palvelun käyttö rekisteröitymällä.
                </div>
              </div>
            </a>
          </div>
        )}
        <div className="col-xs-12 col-sm-6">
          <a href={buildFeedbackPath()} className="card">
            <div className="card__middle">
              <div className="card__name">{t('sendFeedback')}</div>
              <div className="card__middle-row">
                Jäikö jokin asia epäselväksi? Haluatko ehdottaa jotain uutta ominaisuutta? Ota yhteyttä!
              </div>
            </div>
          </a>
        </div>
        <div className="col-xs-12 col-sm-6">
          <a href={buildSportsInfoPath()} className="card">
            <div className="card__middle">
              <div className="card__name">Tietoa lajeista</div>
              <div className="card__middle-row">
                Tietoa lajeista ja niiden säännöistä
              </div>
            </div>
          </a>
        </div>
      </div>
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToHomePage')}</Button>
      </div>
    </div>
  )
}
