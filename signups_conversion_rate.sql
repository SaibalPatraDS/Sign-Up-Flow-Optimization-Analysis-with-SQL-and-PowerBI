USE signup_flow;

/* Signup Measure rate Monthly from July'22 to Jan'23 */

/*
Hint - 1. Total Visitors
       2. Total Registered Users
       3. Total Free Subscription users
*/

WITH total_visitors AS (
     SELECT v.visitor_id,
            v.first_visit_date,
            s.date_registered AS registration_date,
            sp.purchase_date
     FROM visitors AS v
     LEFT JOIN students AS s
     ON v.user_id = s.user_id
     LEFT JOIN student_purchases AS sp
     ON s.user_id = sp.user_id
),

count_total_visitors AS (
     SELECT first_visit_date AS date_session,
            COUNT(visitor_id) AS count_total_visitors
     FROM total_visitors
     GROUP BY first_visit_date
),

count_registered_users AS (
     SELECT first_visit_date AS date_session,
            COUNT(visitor_id) AS count_registered_users
     FROM total_visitors
     WHERE registration_date IS NOT NULL
     GROUP BY first_visit_date
),

count_registered_free_users AS (
     SELECT first_visit_date AS date_session,
            COUNT(visitor_id) AS count_registered_free_users
     FROM total_visitors
     WHERE registration_date IS NOT NULL
	 AND (purchase_date IS NULL OR TIMESTAMPDIFF(minute, registration_date, purchase_date) > 30)
     GROUP BY first_visit_date
)

SELECT ctv.date_session AS date_dession,
       ctv.count_total_visitors,
	   cru.count_registered_users,
       crfu.count_registered_free_users
FROM count_total_visitors AS ctv
LEFT JOIN count_registered_users AS cru
ON ctv.date_session = cru.date_session
LEFT JOIN count_registered_free_users AS crfu
ON ctv.date_session = crfu.date_session
WHERE ctv.date_session BETWEEN '2022-07-01' AND '2023-01-31'
ORDER BY ctv.date_session;