export default function MobileResultCards({ children, competitors }) {
  return (
    <div className="results--mobile result-cards">
      {competitors.map((competitor, i) => {
        const { id, position } = competitor
        const prevCompetitorPosition = competitors[i - 1]?.position || 0
        const orderNo = position === prevCompetitorPosition ? '' : `${position}.`
        return (
          <div className={`card ${i % 2 === 0 ? 'card--odd' : ''}`} key={id}>
            <div className="card__number">{orderNo}</div>
            {children(competitor)}
          </div>
        )
      })}
    </div>
  )
}
