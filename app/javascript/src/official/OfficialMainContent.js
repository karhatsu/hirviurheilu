import React from 'react'
import { Route, Routes } from 'react-router'
import PageTitle from '../common/PageTitle'
import ClubsPage from './clubs/ClubsPage'
import MegalinkImportPage from './megalink/MegalinkImportPage'
import OfficialsPage from './officials/OfficialsPage'

const OfficialMainContent = () => {
  return (
    <div className="body__yield">
      <div className="body__under-top-title"><PageTitle /></div>
      <Routes>
        <Route path="clubs" element={<ClubsPage />} />
        <Route path="megalink_imports" element={<MegalinkImportPage />} />
        <Route path="race_rights" element={<OfficialsPage />} />
      </Routes>
    </div>
  )
}

export default OfficialMainContent
