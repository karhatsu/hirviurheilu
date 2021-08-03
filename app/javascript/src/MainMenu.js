import React from 'react'
import { useLocation, useParams } from 'react-router-dom'
import classnames from 'classnames-minimal'
import DesktopMenuItem from './public/menu/DesktopMenuItem'
import useTranslation from './util/useTranslation'
import { useRace } from './util/useRace'
import useAppData from './util/useAppData'

export default function MainMenu({ closeMenu, mainMenuOpen }) {
  const { t } = useTranslation()
  const { pathname } = useLocation()
  const { raceId } = useParams()
  const { race } = useRace()
  const { admin, locale, userId } = useAppData()
  const className = classnames({ menu: true, 'menu--main': true, 'menu--visible': mainMenuOpen })
  const officialDropDown = raceId && race && userId && (race.userIds.includes(userId) || admin)
    ? [{ text: race.name, path: `/official/races/${race.id}` }]
    : undefined
  return (
    <div className={className}>
      <DesktopMenuItem
        path="/"
        text={t('homePage')}
        selected={pathname === '/'}
        reactLink={true}
        onClick={closeMenu}
      />
      <DesktopMenuItem
        path="/races"
        text={t('races')}
        selected={pathname.indexOf('/races') === 0 || pathname.indexOf('/cups') === 0}
      />
      <DesktopMenuItem
        path="/official"
        text={t('officialHomePage')}
        dropdownItems={officialDropDown}
        dropdownMinCount={1}
      />
      <DesktopMenuItem
        path="/announcements"
        text={t('announcements')}
        selected={pathname.indexOf('/announcements') === 0}
        reactLink={true}
        onClick={closeMenu}
      />
      <DesktopMenuItem path="/info" text="Info" />
      {!userId && <DesktopMenuItem path="/register" text={t('startUsage')} />}
      {!!userId && <DesktopMenuItem path="/account" text={t('account')} />}
      {admin && <DesktopMenuItem path="/admin" text="Admin" />}
      {locale === 'fi' && <DesktopMenuItem path="?new_locale=sv" text="På svenska" />}
      {locale === 'sv' && <DesktopMenuItem path="?new_locale=fi" text="Suomeksi" />}
    </div>
  )
}
