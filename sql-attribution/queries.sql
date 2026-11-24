-- Query 1: revenue by first traffic source
SELECT
  traffic_source.source AS source,
  traffic_source.medium AS medium,
  COUNT(*) AS purchases,
  ROUND(SUM(ecommerce.purchase_revenue_in_usd), 2) AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
  AND _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
GROUP BY source, medium
ORDER BY revenue DESC
LIMIT 20;

-- Query 2: first source vs source recorded at purchase
SELECT
  CASE
    WHEN traffic_source.source =
      (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source')
    THEN 'Same as first source'
    ELSE 'Different from first source'
  END AS comparison,
  COUNT(*) AS purchases,
  ROUND(SUM(ecommerce.purchase_revenue_in_usd), 2) AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
  AND _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
  AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source') IS NOT NULL
GROUP BY comparison;
