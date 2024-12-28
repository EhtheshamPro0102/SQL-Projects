config {
    type: "table",
    name: "shopify_orderlines_stg02_with_collection",
    description: "Orderlines table with Shopify product collection names"
}

WITH
  product_collections AS (
  SELECT
    a.collection_id,
    a.product_id,
    b.title AS collection_name
  FROM
    `source_tables_17696.source_shopify_collects` a
  LEFT JOIN
    `source_tables_17696.source_shopify_custom_collections` b
  ON
    a.collection_id=b.id
  UNION ALL
  SELECT
    a.collection_id,
    a.product_id,
    c.title AS collection_name
  FROM
    `source_tables_17696.source_shopify_collects` a
  LEFT JOIN
    `source_tables_17696.source_shopify_smart_collections` c
  ON
    a.collection_id=c.id ),
  product_collections_agg AS (
  
  SELECT
    CAST(product_id AS STRING) AS product_id,
    STRING_AGG(collection_name, ","
    ORDER BY
      collection_name ASC) AS all_collections
  FROM
    product_collections
  GROUP BY
    product_id ),
  shopify_orderlines_with_collections AS (
  
  SELECT
    e.*,
    d.all_collections AS collections
  FROM
    `source_tables_17696.source_shopify_orderlines_stg01` e
  LEFT JOIN
    product_collections_agg d
  ON
    e.orderline_product_id = d.product_id )
  
SELECT
  *
FROM
  shopify_orderlines_with_collections
