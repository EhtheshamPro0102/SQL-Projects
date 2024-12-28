config { 
    type: "table", 
    name: "ga4_stg01_sessions", 
    description: "session level aggregated data from GA4 events" 
    }

WITH base_query AS (
  SELECT
    MAX(CASE WHEN ep.key = 'ga_session_id' THEN ep.value.int_value END) AS session_id,
    user_pseudo_id,
    event_name,
    device.category AS device,
    event_timestamp,
    PARSE_DATE('%Y%m%d', CAST(event_date AS STRING)) AS date,
    -- Extract values from event_params array
    MAX(CASE WHEN ep.key = 'source' THEN ep.value.string_value END) AS source,
    MAX(CASE WHEN ep.key = 'medium' THEN ep.value.string_value END) AS medium,
    MAX(CASE WHEN ep.key = 'campaign' THEN ep.value.string_value END) AS campaign,
    MAX(CASE WHEN ep.key = 'landing_page' THEN ep.value.string_value END) AS landing_page,
    MAX(CASE WHEN ep.key = 'exit_page' THEN ep.value.string_value END) AS exit_page
  FROM
    `source_tables_17696.source_ga4_events`,
    UNNEST(event_params) AS ep
  WHERE
    user_pseudo_id IS NOT NULL
  GROUP BY
    user_pseudo_id,
    event_name,
    device,
    event_timestamp,
    event_date
),
aggregated_query AS (
  SELECT
    session_id,
    user_pseudo_id,
    device,
    MIN(event_timestamp) AS session_start_timestamp,
    MAX(event_timestamp) AS session_end_timestamp,
    MAX(source) AS source,
    MAX(medium) AS medium,
    MAX(campaign) AS campaign,
    MAX(landing_page) AS landing_page,
    MAX(exit_page) AS exit_page,
    (MAX(event_timestamp) - MIN(event_timestamp)) / 1000000 AS session_duration_in_sec,
    COUNTIF(event_name = 'purchase') AS purchase_count,
    COUNTIF(event_name = 'view_item') AS view_item_count
  FROM
    base_query
  WHERE
    session_id IS NOT NULL
  GROUP BY
    session_id, user_pseudo_id, device
)
SELECT
  session_id,
  user_pseudo_id,
  device,
  TIMESTAMP_SECONDS(CAST(session_start_timestamp / 1000000 AS INT64)) AS session_start_timestamp,
  TIMESTAMP_SECONDS(CAST(session_end_timestamp / 1000000 AS INT64)) AS session_end_timestamp,
  source,
  medium,
  campaign,
  landing_page,
  exit_page,
  session_duration_in_sec,
  CASE
    WHEN purchase_count > 0 THEN TRUE
    WHEN view_item_count >= 2 THEN TRUE
    WHEN session_duration_in_sec >= 10 THEN TRUE
    ELSE FALSE
  END AS is_session_engaged
FROM
  aggregated_query
