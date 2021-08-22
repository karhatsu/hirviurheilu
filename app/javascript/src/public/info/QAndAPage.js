import React, { Suspense, useEffect } from 'react'
import { pages } from '../menu/DesktopSecondLevelMenu'
import Spinner from '../../common/Spinner'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
const Content = React.lazy(() => import('./QAndAContent'))

export default function QAndAPage({ setSelectedPage }) {
  const { t } = useTranslation()
  useEffect(() => setSelectedPage(pages.info.answers), [setSelectedPage])
  useTitle(t('qAndA'))
  return (
    <Suspense fallback={<div className="incomplete-page"><Spinner /></div>}>
      <Content />
    </Suspense>
  )
}
