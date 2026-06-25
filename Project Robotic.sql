CREATE OR REPLACE TABLE `latihan-dalis.neww.data_warehouse_final`
AS
SELECT
  s.`Tanggal Transaksi`,
  s.Produk,
  p.`Nama Produk`,
  s.Kuantitas,
  CAST(REPLACE(REPLACE(s.`Harga per Unit`, 'Rp', ''), '.', '') AS FLOAT64)
    AS harga_satuan,
  c.id_pelanggan,
  c.usia,
  c.jenis_kelamin,
  CASE
    WHEN c.Kota = 'BDG' THEN 'Bandung'
    WHEN c.Kota IN ('Jakarta', 'DKI Jakarta', 'JKT') THEN 'Jakarta'
    ELSE c.Kota
    END
    AS Kota,
  -- Kalkulasi Total Pendapatan
  (
    s.Kuantitas * CAST(
      REPLACE(REPLACE(s.`Harga per Unit`, 'Rp', ''), '.', '') AS FLOAT64))
    AS total_revenue
FROM `latihan-dalis.neww.sales` AS s
INNER JOIN `latihan-dalis.neww.products` AS p
  ON s.Produk = CAST(p.`ID Produk` AS STRING)
INNER JOIN `latihan-dalis.neww.customers` AS c
  ON s.`ID Pelanggan` = c.id_pelanggan
WHERE
  s.`Tanggal Transaksi` IS NOT NULL
  AND s.Produk IS NOT NULL
  AND s.Kuantitas IS NOT NULL
  AND s.`Harga per Unit` IS NOT NULL
  AND c.id_pelanggan IS NOT NULL
  AND c.usia IS NOT NULL
  AND c.jenis_kelamin IS NOT NULL
  AND c.Kota IS NOT NULL;

