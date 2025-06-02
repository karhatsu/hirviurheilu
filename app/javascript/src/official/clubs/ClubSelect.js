import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import { findClubById, resolveClubTitle } from '../../util/clubUtil'
import useTranslation from '../../util/useTranslation'

const ClubSelect = ({ competitorId, clubs, clubName, clubLevel, onSelect }) => {
  const id = useRef(Math.random().toString(36))
  const { t } = useTranslation()
  const [clubsVisible, setClubsVisible] = useState(false)

  const onChangeText = useCallback(
    (event) => {
      onSelect(undefined, event.target.value)
      setClubsVisible(true)
    },
    [onSelect],
  )

  const onSelectClub = useCallback(
    (clubId) => () => {
      const club = findClubById(clubs, clubId)
      onSelect(clubId, club.name)
      setClubsVisible(false)
    },
    [clubs, onSelect],
  )

  const placeholder = useMemo(() => resolveClubTitle(t, clubLevel), [t, clubLevel])

  const matchingClubs = useMemo(() => clubs.filter((c) => c.name.match(new RegExp(clubName, 'i'))), [clubs, clubName])

  useEffect(() => {
    const clickListener = (event) => {
      if (!document.getElementById(id.current).contains(event.target)) {
        setClubsVisible(false)
      }
    }
    window.addEventListener('click', clickListener)
    return () => window.removeEventListener('click', clickListener)
  }, [])

  return (
    <div className="club-select" id={id.current}>
      <input
        value={clubName}
        onFocus={() => setClubsVisible(true)}
        onChange={onChangeText}
        className="club-select__input"
        placeholder={placeholder}
        id={`competitor_${competitorId || 'new'}_clubName`}
      />
      {clubsVisible && matchingClubs.length > 0 && (
        <div className="club-select__dropdown">
          {matchingClubs.map((club) => (
            <div key={club.id} className="club-select__dropdown__club" onClick={onSelectClub(club.id)}>
              {club.name}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export default ClubSelect
