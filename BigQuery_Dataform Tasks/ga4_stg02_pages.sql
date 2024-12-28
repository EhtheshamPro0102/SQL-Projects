config { 
    type: "table", 
    name: "ga4_stg02_pages", 
    description: "Page level aggregated data from GA4 events" }

WITH exits AS (
    SELECT 
    user_pseudo_id,
    event_timestamp,
    event_name,
    LEAD(event_name) OVER (Partition BY user_pseudo_id ORDER BY event_timestamp) as next_event_name
  FROM 
    `source_tables_17696.source_ga4_events`
  WHERE  event_name = 'page_view' )

SELECT 
  PARSE_DATE('%Y%m%d', CAST(event_date AS STRING)) AS date,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'page_location') AS page_url,
  SUM(CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'engagement_time_msec') AS int64)) / 1000 AS total_time_on_page,
  AVG(CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'engagement_time_msec') AS int64)) / 1000 AS  avg_time_on_page,
  COUNTIF((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'entrances') IS NOT NULL) AS entrances,
  COUNTIF(exits.next_event_name IS NULL) AS exits
FROM 
  `source_tables_17696.source_ga4_events` AS e
JOIN 
  exits
ON e.user_pseudo_id = exits.user_pseudo_id 
  and e.event_timestamp = exits.event_timestamp
WHERE e.event_name = 'page_view'
group bY date, page_url
