import { useEffect } from 'react'
import consumer from '../../channels/consumer'

let timeout

const useDataReloading = (websocketChannel, webSocketParamName, webSocketParamValue, reloadDataRef) => {
  useEffect(() => {
    const channelName = { channel: websocketChannel, [webSocketParamName]: webSocketParamValue }
    const channel = consumer.subscriptions.create(channelName, {
      received: () => {
        clearTimeout(timeout)
        timeout = setTimeout(() => reloadDataRef.current(), 5000 * Math.random())
      },
    })
    return () => {
      clearTimeout(timeout)
      consumer.subscriptions.remove(channel)
    }
  }, [websocketChannel, webSocketParamName, webSocketParamValue, reloadDataRef])
}

export default useDataReloading
