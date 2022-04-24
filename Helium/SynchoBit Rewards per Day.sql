SELECT account, CAST(to_timestamp("public"."rewards"."time") AS date) AS "time", sum("public"."rewards"."amount") AS "sum"
FROM "public"."rewards"
WHERE rewards.account in (
        SELECT DISTINCT wallet FROM
        (SELECT
        public.gateway_inventory.first_timestamp AS first_timestamp,
        Makers.id AS Makers_id,
        Makers.name AS Makersname,
        Locations.short_country,
        public.gateway_inventory.address AS spotaddress,
        public.gateway_inventory.owner AS wallet,
        Locations.long_city AS Locationslong_city,
        challenge_receipts_parsed.witness_name,
        challenge_receipts_parsed.witness_address,
        challenge_receipts_parsed.witness_location
        
        FROM
        public.gateway_inventory 
        LEFT JOIN
        public.makers Makers 
        ON public.gateway_inventory.payer = Makers.address 
        LEFT JOIN
        public.locations Locations 
        ON public.gateway_inventory.location = Locations.location
        left join  challenge_receipts_parsed on challenge_receipts_parsed.transmitter_address= public.gateway_inventory.address
        
        where 
        first_timestamp >=  '2022/01/09' and 
        Locations.short_country='NL' and
        Makers.id=5)syncros)

   AND rewards.block > (SELECT MIN(height)
                                FROM blocks
                                WHERE CAST(TO_TIMESTAMP(time) AS date) = '2022/01/09')
GROUP BY CAST(to_timestamp("public"."rewards"."time") AS date), account
ORDER BY CAST(to_timestamp("public"."rewards"."time") AS date) ASC
