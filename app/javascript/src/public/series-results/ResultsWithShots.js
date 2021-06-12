import React, { useCallback, useState } from 'react'
import useTranslation from '../../util/useTranslation'

export const ShowShotsContext = React.createContext(false)

export default function ResultsWithShots({ children, series }) {
  const [showShots, setShowShots] = useState()
  const { t } = useTranslation()
  const toggleShots = useCallback(() => setShowShots(show => !show), [])
  const showShotsButton = !!series.competitors.find(c => c.hasShots)
  return (
    <ShowShotsContext.Provider value={showShots}>
      {showShotsButton && (
        <div className="buttons">
          <div id="shots_button" className="button" onClick={toggleShots}>
            {t(showShots ? 'hideShots' : 'showShots')}
          </div>
        </div>
      )}
      {children}
    </ShowShotsContext.Provider>
  )
}
