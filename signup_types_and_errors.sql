USE signup_flow;

/* Prefered Signup Types and Errors */

SELECT DISTINCT error_text,
       error_id,
       COUNT(*) AS different_errors_occurance
FROM error_messages
GROUP BY error_text, error_id;

SELECT a.action_name,
       COUNT(v.visitor_id) AS total_users,
       COUNT(em.error_id) AS total_error_occurance,
       em.error_id,
       em.error_text
FROM visitors AS v
LEFT JOIN actions AS a
ON v.visitor_id = a.visitor_id
LEFT JOIN error_messages AS em
ON a.error_id = em.error_id;