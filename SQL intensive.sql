-- ============================================== SECTION 1 ==============================================

-- # 1

-- SELECT
-- 	mhs.id,
-- 	mhs.first_name,
-- 	mhs.last_name,
-- 	mhs.email,
-- 	mhs.phone,
-- 	j.jurusan
-- FROM mahasiswa as mhs
-- JOIN jurusan as j
-- 	ON mhs.id_jurusan = j.id
-- WHERE j.jurusan = 'Business Management'

-- ==============================================

-- # 2 

-- SELECT
-- 	mhs.id,
-- 	mhs.first_name,
-- 	mhs.last_name,
-- 	mhs.email,
-- 	mhs.phone,
-- 	j.jurusan
-- FROM mahasiswa as mhs
-- JOIN jurusan as j
-- 	ON mhs.id_jurusan = j.id
-- WHERE j.jurusan = 'Business Management' AND mhs.email LIKE '%@pd%'


-- ==============================================

-- # 3

-- SELECT
-- 	COUNT(id) as total_mahasiswa
-- FROM mahasiswa

-- ==============================================

-- # 4

-- SELECT
-- 	COUNT(id) as total_dosen
-- FROM dosen


-- ==============================================

-- # 5

-- SELECT
-- 	id_jurusan,
-- 	COUNT(id) as total_dosen
-- FROM dosen
-- GROUP BY id_jurusan
-- ORDER BY id_jurusan


-- ==============================================

-- # 6
-- WITH mhs_jurusan AS (
-- 	SELECT
-- 		id_jurusan,
-- 		COUNT(id) as total_mahasiswa_per_jurusan
-- 	FROM mahasiswa
-- 	GROUP BY id_jurusan
-- )

-- -- SELECT * FROM mhs_jurusan

-- SELECT 
-- 	id_jurusan,
-- 	total_mahasiswa_per_jurusan,
-- 	SUM(total_mahasiswa_per_jurusan) OVER() as total_mahasiswa
-- FROM mhs_jurusan

-- ==============================================

--  # 7

-- SELECT 
-- 	semester,
-- 	SUM(sks) as total_sks
-- FROM mata_kuliah
-- WHERE id_jurusan = 2
-- GROUP BY semester

-- ==============================================

-- # 8

-- SELECT
-- 	nama
-- FROM mata_kuliah
-- WHERE id_jurusan = 2 AND (semester % 2) != 0 

-- ==============================================

--  # 9

-- SELECT
-- 	COUNT(DISTINCT ruangan) as total_ruangan
-- FROM mata_kuliah
-- WHERE semester IN (1,2)

-- ==============================================

--  # 10
-- WITH rank_room AS (
-- 	SELECT
-- 		ruangan,
-- 		COUNT(ruangan) as ruangan_count
-- 	FROM mata_kuliah
-- 	WHERE semester IN (1, 2)
-- 	GROUP BY ruangan
-- 	ORDER BY ruangan_count DESC
-- )

-- SELECT
-- 	ruangan
-- FROM rank_room
-- LIMIT 2

-- ==============================================

--  # 11
-- WITH total_hadir AS(
-- 	SELECT
-- 		id_mata_kuliah,
-- 		id_mahasiswa,
-- 		COUNT(CASE WHEN is_hadir = TRUE THEN is_hadir END) as total_kehadiran,
-- 		CAST(COUNT(CASE WHEN is_hadir = TRUE THEN is_hadir END) as float) / CAST(COUNT(week_kuliah) as float) as attendance_level
-- 	FROM attendance
-- 	GROUP BY id_mata_kuliah, id_mahasiswa
-- 	ORDER BY attendance_level DESC, id_mata_kuliah
-- )

-- SELECT * FROM  total_hadir

-- ==============================================

--  # 12 
-- SELECT
-- 	id_mata_kuliah,
-- 	COUNT(CASE WHEN is_hadir = FALSE THEN is_hadir END) as total_absence,
-- 	CAST(COUNT(CASE WHEN is_hadir = FALSE THEN is_hadir END) as float) / CAST(COUNT(is_hadir) as float) as absence_level
-- FROM attendance
-- GROUP BY id_mata_kuliah
-- ORDER BY absence_level DESC

-- ==============================================

--  # 13 
-- WITH per_matkul AS (
-- 	SELECT 
-- 		id_mata_kuliah,
-- 		COUNT(CASE WHEN is_hadir = TRUE THEN is_hadir END) as total_attendance,
-- 		CAST(COUNT(CASE WHEN is_hadir = FALSE THEN is_hadir END) as float) / CAST(COUNT(is_hadir) as float) as absence_level
-- 	FROM attendance
-- 	GROUP BY week_kuliah, id_mata_kuliah
-- 	ORDER BY absence_level DESC
-- 	LIMIT 1
-- )

-- SELECT 
-- 	week_kuliah,
-- 	COUNT(CASE WHEN is_hadir = TRUE THEN is_hadir END) as total_attendance,
-- 	CAST(COUNT(CASE WHEN is_hadir = TRUE THEN is_hadir END) as float) / CAST(COUNT(is_hadir) as float) as absence_level
-- FROM attendance
-- WHERE id_mata_kuliah = (SELECT id_mata_kuliah FROM per_matkul)
-- GROUP BY week_kuliah
-- ORDER BY week_kuliah

-- ==============================================

--  # 14
-- SELECT
-- 	nama,
-- 	sks
-- FROM mata_kuliah
-- WHERE sks > 3
-- ORDER BY sks

-- ==============================================

--  # 15
-- SELECT
-- 	MIN(nilai) nilai_minimum,
-- 	MAX(nilai) nilai_maximum,
-- 	AVG(nilai) nilai_ratarata
-- FROM nilai_v2 


-- ============================================== SECTION 2 ==============================================

-- # 1
-- SELECT 
-- 	mhs.id,
-- 	CONCAT(mhs.first_name, ' ', mhs.last_name) as full_name,
-- 	mhs.email,
-- 	mhs.phone,
-- 	jr.jurusan
-- FROM mahasiswa as mhs
-- JOIN jurusan as jr
-- 	ON mhs.id_jurusan = jr.id
-- WHERE jr.jurusan = 'Teknik Informatika'

-- ==============================================

--  # 2 (HASIL MASIH BEDA)

-- SELECT 
-- 	jr.jurusan,
-- 	mk.nama,
-- 	COUNT(DISTINCT en.id_mahasiswa) AS total_mahasiswa
-- FROM enrollment AS en
-- JOIN mata_kuliah AS mk
-- 	ON en.id_mata_kuliah = mk.id
-- JOIN jurusan AS jr
-- 	ON en.id_jurusan = jr.id
-- GROUP BY jurusan, mk.nama
-- ORDER BY jurusan, total_mahasiswa DESC

-- ==============================================

--  # 3

-- SELECT
-- 	jr.jurusan,
-- 	mk.nama as mata_kuliah,
-- 	AVG(ni.nilai)
-- FROM nilai_v2 as ni
-- JOIN enrollment as en
-- 	ON ni.id_enrollment = en.id
-- JOIN mata_kuliah as mk
-- 	ON en.id_mata_kuliah = mk.id
-- JOIN jurusan as jr
-- 	ON en.id_jurusan = jr.id
-- GROUP BY jurusan, mata_kuliah
-- ORDER BY jurusan

-- ==============================================

--  # 4
-- SELECT 
-- 	jr.jurusan,
-- 	mk.nama as mata_kuliah,
-- 	SUM(mk.semester) as semester,
-- 	SUM(sks) as sks
-- FROM mata_kuliah as mk
-- JOIN jurusan as jr
-- 	ON mk.id_jurusan = jr.id
-- WHERE jurusan = 'Teknik Informatika'
-- GROUP BY jurusan, mata_kuliah
-- ORDER BY sks DESC

-- ==============================================

--  # 5

-- SELECT DISTINCT
-- 	en.id_mahasiswa,
-- 	CONCAT(mhs.first_name, ' ', mhs.last_name) as full_name,
-- 	mhs.email,
-- 	jr.jurusan,
-- 	mk.nama as mata_kuliah
-- FROM enrollment as en
-- JOIN mahasiswa as mhs
-- 	ON en.id_mahasiswa = mhs.id
-- JOIN mata_kuliah as mk
-- 	ON en.id_mata_kuliah = mk.id
-- JOIN jurusan as jr
-- 	ON en.id_jurusan = jr.id
-- WHERE jurusan = 'Teknik Informatika' AND mk.nama = 'Kecerdasan Buatan'

-- ==============================================

-- # 6

-- SELECT DISTINCT
-- 	jr.jurusan,
-- 	mk.nama as mata_kuliah,
-- 	ds.nama
-- FROM mata_kuliah as mk
-- JOIN enrollment as en
-- 	ON mk.id = en.id_mata_kuliah
-- JOIN jurusan as jr
-- 	ON en.id_jurusan = jr.id
-- JOIN dosen as ds
-- 	ON en.id_dosen = ds.id
-- WHERE jurusan = 'Teknik Informatika' AND mk.nama = 'Kecerdasan Buatan'

-- ==============================================

--  # 7

-- SELECT 
-- 	en.id_mahasiswa,
-- 	CONCAT(first_name, ' ', last_name) as full_name,
-- 	jr.jurusan,
-- 	mk.nama as mata_kuliah,
-- 	MAX(ni.nilai) as nilai
-- FROM nilai_v2 as ni
-- JOIN enrollment as en
-- 	ON ni.id_enrollment = en.id
-- JOIN mahasiswa as mhs
-- 	ON en.id_mahasiswa = mhs.id
-- JOIN mata_kuliah as mk
-- 	ON en.id_mata_kuliah = mk.id
-- JOIN jurusan as jr
-- 	ON en.id_jurusan = jr.id
-- WHERE jurusan = 'Teknik Informatika' AND mk.nama = 'Kecerdasan Buatan'
-- GROUP BY id_mahasiswa, full_name, jurusan, mk.nama
-- ORDER BY nilai DESC
-- LIMIT 10

-- ==============================================

-- # 8
-- WITH nilai_max AS (
-- 	SELECT
-- 		en.id_mahasiswa,
-- 		en.id_mata_kuliah,
-- 		en.id_jurusan,
-- 		ni.nilai,
-- 		RANK() OVER(PARTITION BY en.id_mata_kuliah ORDER BY ni.nilai DESC) as ranked
-- 	FROM nilai_v2 as ni
-- 	JOIN enrollment as en
-- 		ON ni.id_enrollment = en.id
-- )


-- SELECT 
-- 	nm.id_mahasiswa,
-- 	CONCAT(mhs.first_name, ' ', mhs.last_name) as full_name,
-- 	mk.nama as mata_kuliah,
-- 	nm.nilai
-- FROM nilai_max as nm
-- JOIN mahasiswa as mhs
-- 	ON nm.id_mahasiswa = mhs.id
-- JOIN mata_kuliah as mk
-- 	ON nm.id_mata_kuliah = mk.id
-- JOIN jurusan as jr
-- 	ON nm.id_jurusan = jr.id
-- WHERE jr.jurusan = 'Teknik Informatika' and ranked = 1
-- ORDER BY mata_kuliah

-- ==============================================

-- # 9

-- SELECT
-- 	mk.nama as mata_kuliah,
-- 	CONCAT(mhs.first_name, ' ', mhs.last_name) as full_name,
-- 	COUNT(CASE WHEN att.is_hadir = TRUE THEN att.is_hadir END) as total_attendance,
-- 	CAST(COUNT(CASE WHEN att.is_hadir = TRUE THEN att.is_hadir END) as float) / CAST(COUNT(att.is_hadir) as float) as attendance_level
-- FROM enrollment as en
-- JOIN mahasiswa as mhs
-- 	ON en.id_mahasiswa = mhs.id
-- JOIN attendance as att
-- 	ON mhs.id = att.id_mahasiswa
-- JOIN jurusan as jr
-- 	ON en.id_jurusan = jr.id
-- JOIN mata_kuliah as mk
-- 	ON en.id_mata_kuliah = mk.id
-- WHERE mk.nama = 'Kecerdasan Buatan' AND jr.jurusan = 'Teknik Informatika'
-- GROUP BY full_name, mata_kuliah
-- ORDER BY attendance_level DESC


-- ==============================================

-- # 10 

-- WITH week_attendance AS (
-- 	SELECT
-- 		att.week_kuliah,
-- 		COUNT(CASE WHEN att.is_hadir = TRUE THEN att.is_hadir END) as total_attendance
-- 	FROM attendance as att
-- 	JOIN mata_kuliah as mk
-- 		ON att.id_mata_kuliah = mk.id
-- 	WHERE mk.nama = 'Kecerdasan Buatan'  
-- 	GROUP BY week_kuliah
-- )

-- SELECT 
-- 	week_kuliah,
-- 	total_attendance,
-- 	LEAD(total_attendance, 1) OVER() as total_attendance_next_week
-- FROM week_attendance


-- ==============================================

-- # 11

-- SELECT
-- 	ds.nama as nama_dosen,
-- 	MIN(ni.nilai) as minimum,
-- 	MAX(ni.nilai) as maximum,
-- 	AVG(ni.nilai) as ratarata,
-- 	STDDEV(ni.nilai) as starndardeviasi,
-- 	COUNT(ni.nilai) as total
-- FROM nilai_v2 as ni
-- JOIN enrollment as en
-- 	ON ni.id_enrollment = en.id
-- JOIN dosen as ds
-- 	ON en.id_dosen = ds.id
-- JOIN mata_kuliah as mk
-- 	ON en.id_mata_kuliah = mk.id
-- WHERE mk.nama = 'Kecerdasan Buatan'
-- GROUP BY nama_dosen


-- ==============================================

-- # 12

-- SELECT
-- 	ds.nama as nama_dosen,
-- 	COUNT(CASE WHEN ni.nilai = 0 THEN ni.nilai END) as zero_given
-- FROM nilai_v2 as ni
-- JOIN enrollment as en
-- 	ON ni.id_enrollment = en.id
-- JOIN dosen as ds
-- 	ON en.id_dosen = ds.id
-- JOIN mata_kuliah as mk
-- 	ON en.id_mata_kuliah = mk.id
-- WHERE mk.nama = 'Kecerdasan Buatan'
-- GROUP BY nama_dosen

-- ==============================================

-- # 13
-- SELECT
-- 	jr.jurusan,
-- 	mk.nama as mata_kuliah,
-- 	COUNT(mhs.id) as total_mahasiswa
-- FROM mahasiswa as mhs
-- JOIN jurusan as jr
-- 	ON mhs.id_jurusan = jr.id
-- JOIN mata_kuliah as mk
-- 	ON mhs.id_jurusan = mk.id_jurusan
-- WHERE mk.jadwal = 'Jum''at'
-- GROUP BY jr.jurusan, mata_kuliah 


-- ==============================================
	
--  # 14

-- SELECT 
-- 	mhs.id,
-- 	CONCAT(mhs.first_name, ' ', mhs.last_name) as full_name,
-- 	mhs.email,
-- 	mk.nama,
-- 	mk.jadwal,
-- 	mk.ruangan
-- FROM mahasiswa as mhs
-- JOIN mata_kuliah as mk
-- 	ON mhs.id_jurusan = mk.id_jurusan
-- WHERE mk.jadwal = 'Senin' AND mk.ruangan = 'Lantai 3' 
-- ORDER BY mk.nama, mhs.id

-- ==============================================

--  # 15 

-- SELECT
-- 	ds.nama,
-- 	mk.nama as mata_kuliah,
-- 	mk.jadwal,
-- 	mk.ruangan
-- FROM mata_kuliah as mk
-- JOIN dosen as ds
-- 	ON mk.id_jurusan = ds.id_jurusan
-- WHERE mk.ruangan = 'Lantai 1' AND mk.jadwal IN ('Senin', 'Kamis')
-- ORDER BY jadwal DESC, ds.nama


-- ============================================== SECTION 2 ==============================================

--  # 1

-- SELECT
-- 	en.id_mahasiswa,
-- 	CONCAT(mhs.first_name, ' ', mhs.last_name) as full_name,
-- 	mk.nama as mata_kuliah,
-- 	ROUND(AVG(ni.nilai) OVER(PARTITION BY mk.nama, en.id_mahasiswa), 1) as avg
-- FROM nilai_v2 as ni
-- JOIN enrollment as en
-- 	ON ni.id_enrollment = en.id
-- JOIN mahasiswa as mhs
-- 	ON en.id_mahasiswa = mhs.id
-- JOIN mata_kuliah as mk
-- 	ON en.id_mata_kuliah = mk.id
-- ORDER BY id_mahasiswa, avg DESC


-- ==============================================

-- # 2

WITH ranked_mhs AS (
	SELECT 
		en.id_mahasiswa,
		CONCAT(mhs.first_name , ' ', mhs.last_name) as full_name,
		en.id_jurusan,
		jr.jurusan,
		CAST(AVG(ni.nilai) as int),
		ROW_NUMBER() OVER(PARTITION BY jr.jurusan ORDER BY AVG(ni.nilai)DESC, STDDEV(ni.nilai) DESC, MOD(ni.nilai) DESC) as rank_nilai
	FROM nilai_v2 as ni
	JOIN enrollment as en
		ON ni.id_enrollment = en.id
	JOIN jurusan as jr
		ON en.id_jurusan = jr.id
	JOIN mata_kuliah as mk
		ON en.id_mata_kuliah = mk.id
	JOIN mahasiswa as mhs
		ON en.id_mahasiswa = mhs.id
	GROUP BY id_mahasiswa, full_name, en.id_jurusan, jr.jurusan, ni.nilai
	ORDER BY jurusan, rank_nilai, id_mahasiswa
)

SELECT * FROM ranked_mhs
WHERE rank_nilai = 3











