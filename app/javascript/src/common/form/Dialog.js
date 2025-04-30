import { useCallback, useRef } from "react"

const Dialog = ({ id, title, children }) => {
  const dialogRef = useRef()

  const closeModal = useCallback(() => dialogRef.current.close(), [])

  return (
    <dialog id={id} className="dialog" ref={dialogRef}>
      <div className="dialog__top">
        <div className="dialog__title">{title}</div>
        <div className="dialog__close" onClick={closeModal}>&times;</div>
      </div>
      <div className="dialog__body">{children}</div>
    </dialog>
  )
}

export default Dialog
