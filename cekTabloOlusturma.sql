CREATE TABLE cek(
   cektar datetime,
   tutar numeric(18,0),     
   cekErtelendi bit, 
   cekErtelemeTarihi datetime
);

INSERT INTO cek (cektar, tutar, cekErtelendi, cekErtelemeTarihi) VALUES ('2021-12-20',7000000,null, null);
INSERT INTO cek (cektar, tutar, cekErtelendi, cekErtelemeTarihi) VALUES ('2021-12-19',6000000,null, null);
INSERT INTO cek (cektar, tutar, cekErtelendi, cekErtelemeTarihi) VALUES ('2021-12-18',5000000,null, null);
INSERT INTO cek (cektar, tutar, cekErtelendi, cekErtelemeTarihi) VALUES ('2021-12-18',40000,1, '2021-12-20');
INSERT INTO cek (cektar, tutar, cekErtelendi, cekErtelemeTarihi) VALUES ('2021-12-19',12346542,1, '2021-12-20');
INSERT INTO cek (cektar, tutar, cekErtelendi, cekErtelemeTarihi) VALUES ('2021-12-18',45645644,1, '2021-12-19');