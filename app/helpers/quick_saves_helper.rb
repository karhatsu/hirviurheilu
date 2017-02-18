module QuickSavesHelper
  def build_estimates_instructions(race)
    instructions = t('official.quick_saves.index.instructions_estimates')
    if race.estimates_at_most == 4
      instructions << ' '
      instructions << t('official.quick_saves.index.instructions_estimates_4')
    end
    instructions << ' '
    instructions << t('official.quick_saves.index.instructions_estimates_hash')
    instructions
  end
end
