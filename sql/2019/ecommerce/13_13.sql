#standardSQL
# 13_13: Lighthouse PWA scores
SELECT
  JSON_EXTRACT_SCALAR(report, "$.categories.pwa.score") AS pwa_score,
  COUNT(0) AS freq,
  SUM(COUNT(0)) OVER (PARTITION BY 0) AS total,
  ROUND(COUNT(0) * 100 / SUM(COUNT(0)) OVER (PARTITION BY 0), 2) AS pct
FROM
  `httparchive.lighthouse.2019_07_01_mobile`
LEFT JOIN
  `httparchive.technologies.2019_07_01_mobile`
USING (url)
WHERE
  category = 'Ecommerce'
GROUP BY
  pwa_score
ORDER BY
  freq / total DESC
