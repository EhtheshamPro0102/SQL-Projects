### Test Task Overview

In this test task, I worked on three main tasks using **Dataform** to process and transform data from Google Analytics 4 (GA4) and Shopify. The tasks involved creating session-level and page-level tables, and enriching Shopify order line data with product collection names. The Each task is saved in SQL files above
Below is a breakdown of each task:

#### 1. **Session Level Table - `ga4_stg01_sessions.sqlx`**
   - **Objective**: Created a session-level table that aggregates data from the raw GA4 events.
   - **Source**: The data was sourced from `source_tables_USER_INDEX.source_ga4_events`.
   - **Fields**: The resulting table included the following fields:
     - `session_id`, `user_pseudo_id`, `device`, `date`, `session_start_timestamp`, `source`, `medium`, `campaign`, `landing_page`, `exit_page`, `session_duration_in_sec`, and `is_session_engaged`.
   - **Logic**: The `is_session_engaged` field is calculated based on specific conditions:
     - A purchase occurred.
     - The session had 2 or more "view_item" events.
     - The session lasted 10 seconds or more.
   - **Result**: A session-level table is produced with one row per `session_id`, containing the summarized session data.

#### 2. **Page Level Table - `ga4_stg02_pages.sqlx`**
   - **Objective**: Built a page-level table summarizing user interaction with pages.
   - **Source**: The data is also sourced from `source_tables_USER_INDEX.source_ga4_events`.
   - **Fields**: The resulting table included the following fields:
     - `date`, `page_url`, `total_time_on_page`, `avg_time_on_page`, `entrances`, and `exits`.
   - **Result**: A page-level table that provides insights into user behavior on specific pages, including metrics like total time on the page and the number of entrances and exits.

#### 3. **Enrich Shopify Order Line Data - `shopify_orderlines_stg02_with_collection.sqlx`**
   - **Objective**: To Enhance the Shopify order line data by adding product collection names.
   - **Source**: This task used multiple tables for mapping collections:
     - `source_tables_USER_INDEX.source_shopify_orderlines_stg01`
     - `source_tables_USER_INDEX.source_shopify_collects`
     - `source_tables_USER_INDEX.source_shopify_smart_collections`
     - `source_tables_USER_INDEX.source_shopify_custom_collections`
   - **Logic**: If a product is part of multiple collections, all collection names are added in alphabetical order, separated by commas.
   - **Result**: A new table (`shopify_orderlines_stg02_with_collection`) is generated at the order line level, ensuring one row per order line with the associated collection names.

---

### These tasks elped me understand and skillup my SQL skills and also the use of **Dataform** for building ETL processes, transforming raw event data and Google analytics insights.
