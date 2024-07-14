export const competitorsCountLabel = (t, competitorsCount) => {
  if (competitorsCount === 1) return t('competitorsCountOne')
  return t('competitorsCountMany', { count: competitorsCount })
}

export const officialsCountLabel = (t, officialsCount) => {
  if (officialsCount === 1) return t('officialsCountOne')
  return t('officialsCountMany', { count: officialsCount })
}
