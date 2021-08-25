#standardSQL
# Pages that use media devices (using Blink features)

SELECT
  client,
  feature,
  num_urls,
  total_urls,
  ROUND(pct_urls, 2) AS pct_urls
FROM
  `httparchive.blink_features.usage`
WHERE
  yyyymmdd = '20210701' AND
  (
    feature LIKE '%MediaDevices%' OR
    feature LIKE '%EnumerateDevices%' OR
    feature LIKE '%GetUserMedia%' OR
    feature LIKE '%GetDisplayMedia%' OR
    feature LIKE '%Camera%' OR
    feature LIKE '%Microphone%'
  )
ORDER BY
  2 ASC, 1 ASC

# relevant Blink features:

# MediaDevicesEnumerateDevices
# GetUserMediaSecureOrigin
# GetUserMediaPromise
# GetUserMediaLegacy
# GetUserMediaPrefixed
# GetUserMediaSecureOriginIframe
# GetUserMediaInsecureOrigin
# GetUserMediaInsecureOriginIframe
# V8MediaSession_SetMicrophoneActive_Method
# V8MediaSession_SetCameraActive_Method
# GetDisplayMedia
