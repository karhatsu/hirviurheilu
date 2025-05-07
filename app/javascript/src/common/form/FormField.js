import useTranslation from '../../util/useTranslation'
import { useCallback } from 'react'

const FormField = ({ children, size, id, label, labelId, helpDialogId }) => {
  const { t } = useTranslation()

  const openHelpDialog = useCallback(() => {
    document.getElementById(helpDialogId).showModal()
  }, [helpDialogId])

  const fieldCn = ['row', 'form__field']
  if (size) fieldCn.push(`form__field--${size}`)
  const renderLabel = () => <label htmlFor={id}>{label || t(labelId || id)}</label>

  return (
    <div className={fieldCn.join(' ')}>
      <div className="col-xs-12 col-sm-3">
        {helpDialogId ? (
          <div className="form__help-label">
            {renderLabel()}
            <span className="help" onClick={openHelpDialog}>
              ?
            </span>
          </div>
        ) : (
          renderLabel()
        )}
      </div>
      <div className="col-xs-12 col-sm-9">{children}</div>
    </div>
  )
}

export default FormField
