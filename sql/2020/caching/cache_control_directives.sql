#standardSQL
# Use of Cache-Control directives
SELECT
  client,
  COUNT(0) AS total_requests,
  COUNTIF(uses_cache_control) AS total_using_cache_control,
  COUNTIF(uses_max_age) AS total_using_max_age,
  COUNTIF(uses_no_cache) AS total_using_no_cache,
  COUNTIF(uses_public) AS total_using_public,
  COUNTIF(uses_must_revalidate) AS total_using_must_revalidate,
  COUNTIF(uses_no_store) AS total_using_no_store,
  COUNTIF(uses_private) AS total_using_private,
  COUNTIF(uses_proxy_revalidate) AS total_using_proxy_revalidate,
  COUNTIF(uses_s_maxage) AS total_using_s_maxage,
  COUNTIF(uses_no_transform) AS total_using_no_transform,
  COUNTIF(uses_immutable) AS total_using_immutable,
  COUNTIF(uses_stale_while_revalidate) AS total_using_stale_while_revalidate,
  COUNTIF(uses_stale_if_error) AS total_using_stale_if_error,
  COUNTIF(uses_no_store AND uses_no_cache AND uses_max_age_zero) AS total_using_no_store_and_no_cache_and_max_age_zero,
  COUNTIF(uses_no_store AND uses_no_cache AND NOT uses_max_age_zero) AS total_using_no_store_and_no_cache_only,
  COUNTIF(uses_no_store AND NOT uses_no_cache AND NOT uses_max_age_zero) AS total_using_no_store_only,
  COUNTIF(uses_max_age_zero AND NOT uses_no_store) AS total_using_max_age_zero_without_no_store,
  COUNTIF(uses_pre_check_zero AND uses_post_check_zero) AS total_using_pre_check_zero_and_post_check_zero,
  COUNTIF(uses_pre_check_zero) AS total_using_pre_check_zero,
  COUNTIF(uses_post_check_zero) AS total_using_post_check_zero,
  COUNTIF(uses_cache_control AND NOT uses_max_age AND NOT uses_no_cache AND NOT uses_public AND NOT uses_must_revalidate AND NOT uses_no_store AND NOT uses_private AND NOT uses_proxy_revalidate AND NOT uses_s_maxage AND NOT uses_no_transform AND NOT uses_immutable AND NOT uses_stale_while_revalidate AND NOT uses_stale_if_error AND NOT uses_pre_check_zero AND NOT uses_post_check_zero) AS total_erroneous_directives,
  COUNTIF(uses_cache_control) / COUNT(0) AS pct_using_cache_control,
  COUNTIF(uses_max_age) / COUNT(0) AS pct_using_max_age,
  COUNTIF(uses_no_cache) / COUNT(0) AS pct_using_no_cache,
  COUNTIF(uses_public) / COUNT(0) AS pct_using_public,
  COUNTIF(uses_must_revalidate) / COUNT(0) AS pct_using_must_revalidate,
  COUNTIF(uses_no_store) / COUNT(0) AS pct_using_no_store,
  COUNTIF(uses_private) / COUNT(0) AS pct_using_private,
  COUNTIF(uses_proxy_revalidate) / COUNT(0) AS pct_using_proxy_revalidate,
  COUNTIF(uses_s_maxage) / COUNT(0) AS pct_using_s_maxage,
  COUNTIF(uses_no_transform) / COUNT(0) AS pct_using_no_transform,
  COUNTIF(uses_immutable) / COUNT(0) AS pct_using_immutable,
  COUNTIF(uses_stale_while_revalidate) / COUNT(0) AS pct_using_stale_while_revalidate,
  COUNTIF(uses_stale_if_error) / COUNT(0) AS pct_using_stale_if_error,
  COUNTIF(uses_no_store AND uses_no_cache AND uses_max_age_zero) / COUNT(0) AS pct_using_no_store_and_no_cache_and_max_age_zero,
  COUNTIF(uses_no_store AND uses_no_cache AND NOT uses_max_age_zero) / COUNT(0) AS pct_using_no_store_and_no_cache_only,
  COUNTIF(uses_no_store AND NOT uses_no_cache AND NOT uses_max_age_zero) / COUNT(0) AS pct_using_no_store_only,
  COUNTIF(uses_max_age_zero AND NOT uses_no_store) / COUNT(0) AS pct_using_max_age_zero_without_no_store,
  COUNTIF(uses_pre_check_zero AND uses_post_check_zero) / COUNT(0) AS pct_using_pre_check_zero_and_post_check_zero,
  COUNTIF(uses_pre_check_zero) / COUNT(0) AS pct_using_pre_check_zero,
  COUNTIF(uses_post_check_zero) / COUNT(0) AS pct_using_post_check_zero,
  COUNTIF(uses_cache_control AND NOT uses_max_age AND NOT uses_no_cache AND NOT uses_public AND NOT uses_must_revalidate AND NOT uses_no_store AND NOT uses_private AND NOT uses_proxy_revalidate AND NOT uses_s_maxage AND NOT uses_no_transform AND NOT uses_immutable AND NOT uses_stale_while_revalidate AND NOT uses_stale_if_error AND NOT uses_pre_check_zero AND NOT uses_post_check_zero) / COUNT(0) AS pct_erroneous_directives
FROM (
  SELECT
    _TABLE_SUFFIX AS client,
    TRIM(resp_cache_control) != "" AS uses_cache_control,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)max-age\s*=\s*[0-9]+') AS uses_max_age,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)max-age\s*=\s*0') AS uses_max_age_zero,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)public') AS uses_public,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)no-cache') AS uses_no_cache,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)must-revalidate') AS uses_must_revalidate,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)no-store') AS uses_no_store,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)private') AS uses_private,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)proxy-revalidate') AS uses_proxy_revalidate,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)s-maxage\s*=\s*[0-9]+') AS uses_s_maxage,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)no-transform') AS uses_no_transform,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)immutable') AS uses_immutable,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)stale-while-revalidate\s*=\s*[0-9]+') AS uses_stale_while_revalidate,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)stale-if-error\s*=\s*[0-9]+') AS uses_stale_if_error,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)pre-check\s*=\s*0') AS uses_pre_check_zero,
    REGEXP_CONTAINS(resp_cache_control, r'(?i)post-check\s*=\s*0') AS uses_post_check_zero
  FROM
    `httparchive.summary_requests.2020_08_01_*`
)
GROUP BY
  client

