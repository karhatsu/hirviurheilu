const Select = ({ id, items, labelKey, onChange, promptLabel, promptValue, value }) => (
  <select id={id} onChange={onChange} value={value}>
    {promptValue !== undefined && <option value={promptValue}>{promptLabel}</option>}
    {items.map((item) => (
      <option key={item.id} value={item.id}>
        {item[labelKey || 'name']}
      </option>
    ))}
  </select>
)

export default Select
