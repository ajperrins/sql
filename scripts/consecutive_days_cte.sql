;
WITH ConsecutiveDays( Date )
AS
(
	SELECT CAST(getdate() as DATE)
	UNION ALL
	SELECT DATEADD(day, -1, Date) FROM ConsecutiveDays WHERE Date > DATEADD(week, -56, GETDATE())
)
SELECT * FROM ConsecutiveDays
OPTION (maxrecursion 0)
