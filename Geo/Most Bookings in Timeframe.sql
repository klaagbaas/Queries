SELECT
    b.*,
    u.city_name_unidecode ufi_name,
    u.cc1 cc1
FROM 
(
    SELECT
        hotel_ufi_current ufi,
        COUNT(hotelreservation_id) bookings
    FROM reservation_data_governance.reservation_flatter
    WHERE status NOT IN ('test', 'fraudulent')
        AND created_date >= '2019-01-01'
        AND created_date < '2020-01-01'
    GROUP BY 1
    ORDER BY bookings DESC
    LIMIT 50
) b

LEFT JOIN dbimports.bp_hotel_location u
ON b.ufi = u.ufi
