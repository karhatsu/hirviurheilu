export const competitorsCountLabel = (t, competitorsCount) => {
  if (competitorsCount === 1) return t('competitorsCountOne')
  return t('competitorsCountMany', { count: competitorsCount })
}
