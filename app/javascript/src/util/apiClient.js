const unexpectedErrorMsg = 'Odottamaton virhe, yritä uudestaan. Jos ongelma ei poistu, ota yhteys palvelun ylläpitoon.'

export function get(path, callback) {
  fetch(path, {
    headers: { 'X-Camel-Case': 'true' },
  }).then(response => {
    handleApiResponse(response, callback)
  }).catch(() => handleApiConnectionError(callback))
}

export function post(path, body, callback) {
  fetch(path, {
    method: 'POST',
    headers: { 'X-Camel-Case': 'true', 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  }).then(response => {
    handleApiResponse(response, callback)
  }).catch(() => handleApiConnectionError(callback))
}

export function handleApiResponse(response, callback) {
  if (response.status === 201 || response.status === 204) {
    callback()
  } else if (response.ok) {
    response.json().then(data => {
      callback(null, data)
    }).catch(() => callback([unexpectedErrorMsg]))
  } else {
    response.json().then(({ errors }) => {
      callback(errors)
    }).catch(() => callback([unexpectedErrorMsg]))
  }
}

export function handleApiConnectionError(callback) {
  callback(['Yhteysvirhe, yritä uudestaan'])
}

export function buildQueryParams(object) {
  return Object.keys(object).map(key => `${key}=${object[key]}`).join('&')
}
