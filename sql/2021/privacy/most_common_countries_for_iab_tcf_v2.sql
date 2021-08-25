#standardSQL
# Counts of countries for publishers using IAB Transparency & Consent Framework
# cf. https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md#tcdata
# "Country code of the country that determines the legislation of
#  reference.  Normally corresponds to the country code of the country
#  in which the publisher's business entity is established."

WITH pages_privacy AS (
  SELECT
    _TABLE_SUFFIX AS client,
    JSON_VALUE(payload, "$._privacy") AS metrics
  FROM
    `httparchive.pages.2021_07_01_*`
),

total_nb_pages AS (
  SELECT
    _TABLE_SUFFIX AS client,
    COUNT(0) AS total_nb_pages
  FROM
    `httparchive.pages.2021_07_01_*`
  GROUP BY
    1
),

pages_iab_tcf_v2 AS (
  SELECT
    client,
    JSON_QUERY(metrics, "$.iab_tcf_v2.data") AS metrics
  FROM
    pages_privacy
  WHERE
    JSON_QUERY(metrics, "$.iab_tcf_v2.data") IS NOT NULL
)

SELECT
  client,
  JSON_VALUE(metrics, '$.publisherCC') AS publisherCC,
  COUNT(0) AS nb_websites,
  ROUND(COUNT(0) / MIN(total_nb_pages.total_nb_pages), 2) AS pct_websites
FROM
  pages_iab_tcf_v2 JOIN total_nb_pages USING (client)
WHERE
  JSON_VALUE(metrics, '$.publisherCC') IS NOT NULL
GROUP BY
  1, 2
ORDER BY
  3 DESC
