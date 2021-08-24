import React from 'react'
import { useLocation, useParams } from 'react-router-dom'
import classnames from 'classnames-minimal'
import DesktopMenuItem from './public/menu/DesktopMenuItem'
import useTranslation from './util/useTranslation'
import { useRace } from './util/useRace'
import useAppData from './util/useAppData'
import {
  buildAccountPath,
  buildAnnouncementsPath,
  buildInfoPath,
  buildOfficialPath,
  buildRacesPath,
  buildRegisterPath,
  buildRootPath,
  matchPath,
} from './util/routeUtil'

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
        icon="home"
        path={buildRootPath()}
        text={t('homePage')}
        selected={pathname === '/' || pathname === '/sv'}
        reactLink={true}
        onClick={closeMenu}
      />
      <DesktopMenuItem
        icon="search"
        path={buildRacesPath()}
        text={t('searchRace')}
        reactLink={true}
        selected={pathname === '/races' || pathname === '/sv/races'}
        onClick={closeMenu}
      />
      <DesktopMenuItem
        icon="build"
        path={buildOfficialPath()}
        text={t('officialHomePage')}
        dropdownItems={officialDropDown}
        dropdownMinCount={1}
      />
      <DesktopMenuItem
        icon="article"
        path={buildAnnouncementsPath()}
        text={t('announcements')}
        selected={matchPath(pathname, '/announcements')}
        reactLink={true}
        onClick={closeMenu}
      />
      <DesktopMenuItem
        icon="info"
        path={buildInfoPath()}
        text="Info"
        selected={['/info', '/prices', '/answers', '/feedbacks'].find(path => matchPath(pathname, path))}
        reactLink={true}
        onClick={closeMenu}
      />
      {!userId && <DesktopMenuItem icon="login" path={buildRegisterPath()} text={t('startUsage')} />}
      {!!userId && <DesktopMenuItem icon="person" path={buildAccountPath()} text={t('account')} />}
      {admin && <DesktopMenuItem icon="architecture" path="/admin" text="Admin" />}
      {locale === 'fi' && <DesktopMenuItem icon="language" path="?new_locale=sv" text="På svenska" />}
      {locale === 'sv' && <DesktopMenuItem icon="language" path="?new_locale=fi" text="Suomeksi" />}
    </div>
  )
}
