import React, { useCallback, useState } from 'react'
import useTranslation from '../../util/useTranslation'
import Button from '../../common/Button'

export const ShowShotsContext = React.createContext(false)

export default function ResultsWithShots({ children, competitors }) {
  const [showShots, setShowShots] = useState()
  const { t } = useTranslation()
  const toggleShots = useCallback(() => setShowShots(show => !show), [])
  const showShotsButton = !!competitors.find(c => c.hasShots)
  return (
    <ShowShotsContext.Provider value={showShots}>
      {showShotsButton && (
        <div className="buttons">
          <Button id="shots_button" onClick={toggleShots}>{t(showShots ? 'hideShots' : 'showShots')}</Button>
        </div>
      )}
      {children}
    </ShowShotsContext.Provider>
  )
}
