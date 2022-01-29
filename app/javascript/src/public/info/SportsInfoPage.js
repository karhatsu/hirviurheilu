import React, { useCallback, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'
import { buildRootPath } from '../../util/routeUtil'

export default function SportsInfoPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  useEffect(() => {
    setSelectedPage(pages.info.sportsInfo)
  }, [setSelectedPage])

  const buildButton = useCallback((path, text) => {
    const href = `https://metsastajaliitto.fi/metsastajalle/kilpailutoiminta/${path}`
    return <Button href={href} blank={true}>{text}</Button>
  }, [])
  return (
    <div>
      <h2>Lisätietoa Hirviurheilun lajeista Suomen Metsästäjäliiton sivuilta</h2>
      <div className="buttons">
        {buildButton('lajiesittelyt', 'Lajiesittelyt')}
        {buildButton('metsastysampumasaannot', 'Lajien säännöt')}
        {buildButton('metsastysammuntojen-sm-kilpailut-2022-2024', 'Tulevat SM-kilpailut')}
      </div>
      <div className="buttons buttons--nav">
        <Button to={buildRootPath()} type="back">{t('backToHomePage')}</Button>
      </div>
    </div>
  )
}
