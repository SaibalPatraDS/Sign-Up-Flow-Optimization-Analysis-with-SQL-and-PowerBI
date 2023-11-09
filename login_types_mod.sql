USE signup_flow;

SELECT 
    ac.visitor_id,
    v.first_visit_date,
    s.user_id,
    CAST(s.date_registered AS DATE) AS registration_date,
    CAST(ac.action_date AS DATE) AS login_date,
    CASE
        WHEN ac.action_name LIKE '%facebook%' THEN 'facebook'
        WHEN ac.action_name LIKE '%google%' THEN 'google'
        WHEN ac.action_name LIKE '%linkedin%' THEN 'linkedin'
        ELSE 'email'
    END AS login_type,
    CASE
        WHEN ac.action_name LIKE '%success%' THEN 'success'
        WHEN ac.action_name LIKE '%fail%' THEN 'fail'
    END AS login_attempt,
    IFNULL(e.error_text, ' ') AS error_message,
    se.session_os,
    CASE
        WHEN
            se.session_os LIKE '%Android%'
                OR se.session_os LIKE 'iOS%'
        THEN
            'mobile'
        WHEN
            se.session_os LIKE '%windows%'
                OR se.session_os LIKE 'OS%'
                OR se.session_os LIKE '%Linux%'
                OR se.session_os LIKE '%Ubuntu%'
                OR se.session_os LIKE '%Chrome%'
        THEN
            'desktop'
        ELSE 'other'
    END AS device
FROM
    actions AS ac
        LEFT JOIN
    visitors AS v ON v.visitor_id = ac.visitor_id
        LEFT JOIN
    students AS s ON s.user_id = v.user_id
        LEFT JOIN
    error_messages e ON e.error_id = ac.error_id
        LEFT JOIN
    sessions se ON se.visitor_id = ac.visitor_id
WHERE
    v.first_visit_date >= '2022-07-01'
        AND ac.action_name LIKE '%log%'
        AND ac.action_name LIKE '%click%'
        AND (ac.action_name LIKE '%success%'
        OR ac.action_name LIKE '%fail%')
GROUP BY se.session_id
HAVING login_attempt IS NOT NULL
    AND registration_date <= login_date
ORDER BY login_date