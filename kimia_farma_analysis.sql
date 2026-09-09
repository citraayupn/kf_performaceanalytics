-- =========================================================
-- 1. CEK DATASET 
-- =========================================================

SELECT *
FROM `kimiafarma-507302.kimia_farma.kf_final_transaction`
LIMIT 10;

SELECT *
FROM `kimiafarma-507302.kimia_farma.kf_product`
LIMIT 10;

SELECT *
FROM `kimiafarma-507302.kimia_farma.kf_inventory`
LIMIT 10;

SELECT *
FROM `kimiafarma-507302.kimia_farma.kf_kantor_cabang`
LIMIT 10;

-- =========================================================
-- MEMBUAT / MEMPERBARUI TABEL ANALISIS
-- =========================================================

CREATE OR REPLACE TABLE
`kimiafarma-507302.kimia_farma.kf_analisis` AS

SELECT
    -- 1. INFORMASI TRANSAKSI
    ft.transaction_id,
    ft.date,
    ft.branch_id,

    -- 2. INFORMASI CABANG
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating_cabang,

    -- 3. INFORMASI CUSTOMER
    ft.customer_name,

    -- 4. INFORMASI PRODUK
    ft.product_id,
    p.product_name,

    -- 5. HARGA & DISKON
    ft.price AS actual_price,
    ft.discount_percentage,

    -- 6. PERSENTASE GROSS LABA
    CASE
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price <= 100000 THEN 0.15
        WHEN ft.price <= 300000 THEN 0.20
        WHEN ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,

    -- 7. NETT SALES
    -- Harga setelah diskon
    ROUND(
        ft.price * (1 - ft.discount_percentage),
        0
    ) AS nett_sales,

    -- 8. NETT PROFIT
    -- Keuntungan Kimia Farma
    ROUND(
        (
            ft.price * (1 - ft.discount_percentage)
        )
        *
        (
            CASE
                WHEN ft.price <= 50000 THEN 0.10
                WHEN ft.price <= 100000 THEN 0.15
                WHEN ft.price <= 300000 THEN 0.20
                WHEN ft.price <= 500000 THEN 0.25
                ELSE 0.30
            END
        ),
        0
    ) AS nett_profit,

    -- 9. RATING TRANSAKSI
    ft.rating_transaction

FROM
`kimiafarma-507302.kimia_farma.kf_final_transaction` AS ft

LEFT JOIN
`kimiafarma-507302.kimia_farma.kf_kantor_cabang` AS kc
ON ft.branch_id = kc.branch_id

LEFT JOIN
`kimiafarma-507302.kimia_farma.kf_product` AS p
ON ft.product_id = p.product_id;


-- =========================================================
-- CEK TABEL ANALISIS
-- =========================================================

SELECT *
FROM `kimiafarma-507302.kimia_farma.kf_analisis`
LIMIT 10;
