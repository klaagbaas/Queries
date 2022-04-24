SELECT SUM(earnings)
FROM
    (SELECT SUM(amount * 1e-8) earnings, COUNT(address), long_city city
    FROM gateway_inventory inv
        LEFT JOIN locations locs ON (inv.location = locs.location)
        LEFT JOIN rewards
            ON (inv.address = rewards.gateway)
    WHERE locs.short_country = 'NL'
        AND rewards.block > (SELECT MIN(height)
                                FROM blocks
                                WHERE CAST(TO_TIMESTAMP(time) AS date) BETWEEN CAST((CAST(NOW() AS timestamp) + (INTERVAL '-1 day')) AS date) AND CAST(NOW() AS date))
                                AND rewards.block < (SELECT MAX(height)
                                FROM blocks
                                WHERE CAST(TO_TIMESTAMP(time) AS date) BETWEEN CAST((CAST(NOW() AS timestamp) + (INTERVAL '-1 day')) AS date) AND CAST(NOW() AS date))
    GROUP BY city
    ORDER BY earnings DESC) cityrewards
