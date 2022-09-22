--Q1 the total earns for each country

SELECT BillingCountry,
       count(InvoiceId) AS Invoices
FROM Invoice
GROUP BY 1
ORDER BY 2 DESC;

--Q2 top 5 cities make earns

SELECT BillingCity,
       SUM(Total) AS Invoice_Totals
FROM Invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Q3 top 5 customers make earns

SELECT C.CustomerId,
       C.FirstName,
       C.LastName,
       SUM(I.Total) AS Purchases
FROM Invoice I
JOIN Customer C ON C.CustomerId = I.CustomerId
GROUP BY C.CustomerId,
         C.FirstName,
         C.LastName
ORDER BY Purchases DESC
LIMIT 5;

--Q4 all Rock Music listeners 

SELECT DISTINCT C.Email,
                C.FirstName,
                C.LastName,
                G.Name
FROM InvoiceLine IL
JOIN Invoice I ON I.InvoiceId = IL.InvoiceId
JOIN Customer C ON C.CustomerId = I.CustomerId
JOIN Track T ON T.TrackId = IL.TrackId
JOIN Genre G ON G.GenreId = T.GenreId
WHERE G.Name = 'Rock'
ORDER BY 1

-- Q5 the band who makes the most rock music

SELECT AR.ArtistId,
       AR.Name,
       COUNT(T.TrackId) AS Songs
FROM Track T
JOIN Album AL ON T.AlbumId = AL.AlbumId
JOIN Artist AR ON AR.ArtistId = AL.ArtistId
JOIN Genre G ON G.GenreId = T.GenreId
WHERE G.Name = 'Rock'
GROUP BY AR.ArtistId,
         AR.Name
ORDER BY Songs DESC
LIMIT 1;

--Q6 artists who have earned the most
-- INNER QUERY

SELECT AR.Name,
       sum(I.UnitPrice * I.Quantity AS AmountSpent
FROM Album AL
JOIN Track T ON AL.AlbumId = T.AlbumId
JOIN InvoiceLine I ON I.TrackId = T.TrackId
JOIN Artist AR ON AR.ArtistId =AL.ArtistId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q6 customer who has spent the most in the artist who has earned the most
--THE WHOLE QUERY

SELECT C.CustomerId,
       C.FirstName,
       C.LastName,
       sum(I.UnitPrice * I.Quantity AS AmountSpent
FROM Album AL
JOIN Track T ON AL.AlbumId = T.AlbumId
JOIN InvoiceLine IL ON IL.TrackId = T.TrackId
JOIN Artist AR ON AR.ArtistId =AL.ArtistId
JOIN Invoice I ON I.InvoiceId = IL.InvoiceId
JOIN Customer C ON C.CustomerId = I.CustomerId
WHERE AR.Name IN
    (SELECT Name
     FROM
       (SELECT AR.Name,
               COUNT(T.TrackId) * T.UnitPrice AS Amount
        FROM Album AL
        JOIN Track T ON AL.AlbumId = T.AlbumId
        JOIN InvoiceLine IL ON IL.TrackId = T.TrackId
        JOIN Artist AR ON AR.ArtistId =AL.ArtistId
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1))
GROUP BY 1,
         2,
         3
ORDER BY 4 DESC;

--Q7 most popular music Genre for each country(has highest purchases)

WITH T1 AS
  (SELECT round(COUNT(T.TrackId) * T.UnitPrice, 0) AS Purchase,
          C.Country AS COUNTRY,
          G.Name AS NAME,
          G.GenreId AS ID
   FROM Invoice I
   JOIN InvoiceLine IL ON I.InvoiceId = IL.InvoiceId
   JOIN Customer C ON C.CustomerId = I.CustomerId
   JOIN Track T ON IL.TrackId = T.TrackId
   JOIN Genre G ON G.GenreId = T.GenreId
   GROUP BY 2,
            3,
            4)
SELECT T2.Purchases,
       T2.COUNTRY,
       T1.NAME,
       T1.ID
FROM
  (SELECT max(Purchase) AS Purchases,
          COUNTRY,
          NAME,
          ID
   FROM T1
   GROUP BY 2
   ORDER BY 2) AS T2
JOIN T1 ON T1.Purchase = T2.Purchases
AND T1.COUNTRY=T2.COUNTRY;

--Q8 all the track names that have a song length longer than the average

SELECT Name,
       Milliseconds
FROM Track
WHERE Milliseconds >
    (SELECT avg(Milliseconds)
     FROM Track)
ORDER BY Milliseconds DESC

--Q9 the customer that has spent the most on music for each country

WITH T1 AS
  (SELECT C.Country Country,
          sum(I.Total) AS Total,
          C.FirstName FirstName,
          C.LastName LastName,
          C.CustomerId CustomerId
   FROM Invoice I
   JOIN Customer C ON I.CustomerId = C.CustomerId
   GROUP BY 3,
            4
   ORDER BY 1)
SELECT T1.Country,
       T2.TotalSpent,
       T1.FirstName,
       T1.LastName,
       T1.CustomerId
FROM
  (SELECT Country,
          max(Total) AS TotalSpent,
          FirstName,
          LastName,
          CustomerId
   FROM T1
   GROUP BY 1) AS T2
JOIN T1 ON T1.Country = T2.Country
AND T1.Total=T2.TotalSpent
ORDER BY T2.Country;

--additional queries

--Q10-band who makes the most songs

SELECT AR.Name,
       count(T.TrackId) AS Total_Songs
FROM Album AL
JOIN Artist AR ON AR.ArtistId = AL.ArtistId
JOIN Track T ON AL.AlbumId = T.AlbumId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


--Q11 the song genre that exists the most

SELECT G.Name,
       count(T.TrackId) AS Total_Songs
FROM Track T
JOIN Genre G ON G.GenreId = T.GenreId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


--Q12 the number of songs per media type

SELECT M.Name,
       count(T.TrackId) AS Total_Songs
FROM Track T
JOIN MediaType M ON M.MediaTypeId = T.MediaTypeId
GROUP BY 1
ORDER BY 2 DESC ;

--Q13 total tracks

SELECT count(*) AS Total_Tracks
FROM Track

--Q14 TOTAL earns
 
SELECT sum(total) AS TOTAL
FROM Invoice

--Q15 the track which earns the most

SELECT T.Name,
       sum(I.UnitPrice * I.Quantity) AS TOTAL
FROM Track T
JOIN InvoiceLine I ON T.TrackId = I.TrackId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

--Q16 the genre which earns the most

SELECT G.Name,
       round(sum(I.UnitPrice * I.Quantity), 0) AS TOTAL
FROM Track T
JOIN InvoiceLine I ON T.TrackId = I.TrackId
JOIN Genre G ON G.GenreId = T.GenreId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


