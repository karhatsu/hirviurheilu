import React from 'react'
import { useLocation } from 'react-router'
import classnames from 'classnames-minimal'
import DesktopMenuItem from '../public/menu/DesktopMenuItem'
import useTranslation from '../util/useTranslation'
import { useRace } from '../util/useRace'
import useAppData from '../util/useAppData'
import {
  buildAccountPath,
  buildAnnouncementsPath,
  buildInfoPath,
  buildOfficialPath,
  buildOfficialRacePath,
  buildRacePath,
  buildRacesPath,
  buildRegisterPath,
  buildRootPath,
  matchPath,
} from '../util/routeUtil'
import { usePathParams } from '../public/PathParamsProvider'

export default function MainMenu({ closeMenu, mainMenuOpen, official }) {
  const { t } = useTranslation()
  const { pathname } = useLocation()
  const { raceId } = usePathParams()
  const { race } = useRace()
  const { admin, locale, userId } = useAppData()

  const className = classnames({ menu: true, 'menu--main': true, 'menu--visible': mainMenuOpen })
  const raceDropDown = official && raceId && race
    ? [{ text: race.name, path: buildRacePath(raceId) }]
    : undefined
  const officialDropDown = !official && raceId && race && userId && (race.userIds.includes(userId) || admin)
    ? [{ text: race.name, path: buildOfficialRacePath(race.id) }]
    : undefined
  return (
    <div className={className}>
      <DesktopMenuItem
        icon="home"
        path={buildRootPath()}
        text={t('homePage')}
        selected={pathname === '/' || pathname === '/sv'}
        reactLink={!official}
        onClick={closeMenu}
      />
      <DesktopMenuItem
        icon="search"
        path={buildRacesPath()}
        text={t('searchRace')}
        reactLink={!official}
        selected={pathname === '/races' || pathname === '/sv/races'}
        onClick={closeMenu}
        dropdownItems={raceDropDown}
        dropdownMinCount={1}
      />
      <DesktopMenuItem
        icon="build"
        path={buildOfficialPath()}
        text={t('officialHomePage')}
        selected={official}
        dropdownItems={officialDropDown}
        dropdownMinCount={1}
      />
      <DesktopMenuItem
        icon="article"
        path={buildAnnouncementsPath()}
        text={t('announcements')}
        selected={matchPath(pathname, '/announcements')}
        reactLink={!official}
        onClick={closeMenu}
      />
      <DesktopMenuItem
        icon="info"
        path={buildInfoPath()}
        text="Info"
        selected={['/info', '/prices', '/answers', '/feedbacks', '/sports_info'].find(path => {
          return matchPath(pathname, path)
        })}
        reactLink={!official}
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
