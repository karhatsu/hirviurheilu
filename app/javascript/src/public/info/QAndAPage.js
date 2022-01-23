import React, { Suspense, useEffect } from 'react'
import useMenu, { pages } from '../../util/useMenu'
import Spinner from '../../common/Spinner'
import useTitle from '../../util/useTitle'
import useTranslation from '../../util/useTranslation'
const Content = React.lazy(() => import('./QAndAContent'))

export default function QAndAPage() {
  const { t } = useTranslation()
  const { setSelectedPage } = useMenu()
  useEffect(() => setSelectedPage(pages.info.answers), [setSelectedPage])
  useTitle(t('qAndA'))
  return (
    <Suspense fallback={<div className="incomplete-page"><Spinner /></div>}>
      <Content />
    </Suspense>
  )
}
