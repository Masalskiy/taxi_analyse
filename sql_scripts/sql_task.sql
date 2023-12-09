CREATE OR REPLACE VIEW statistic_taxi AS 
-- Таблица с о всеми поездаками за каждый день
WITH all_trip as (
	select DATE(tpep_pickup_datetime), count(*) as at_count 
	from taxi_analis
	-- в данных достаточно много null значений в пассажирах. Решено их игнорировать
	where passenger_count is not null
	group by DATE(tpep_pickup_datetime)
--order by date
), zero_table as (
	select min(total_amount) as min_zero, max(total_amount) as max_zero, DATE(tpep_pickup_datetime), count(*), 
			(1.0*count(*)/a_t.at_count)*100 as percentage_zero
	from taxi_analis ta 
	left join all_trip a_t on DATE(ta.tpep_pickup_datetime) = a_t.date
	where passenger_count = 0
	group by DATE(tpep_pickup_datetime), a_t.at_count
--order by date, passenger_count
), one_table as (
	select min(total_amount) as min_1, max(total_amount) as max_1, DATE(tpep_pickup_datetime), count(*), 
			(1.0*count(*)/a_t.at_count)*100 as percentage_1p
	from taxi_analis ta 
	left join all_trip a_t on DATE(ta.tpep_pickup_datetime) = a_t.date
	where passenger_count = 1
	group by DATE(tpep_pickup_datetime), a_t.at_count
), two_table as(
	select min(total_amount) as min_2, max(total_amount) as max_2, DATE(tpep_pickup_datetime), count(*), 
			(1.0*count(*)/a_t.at_count)*100 as percentage_2p
	from taxi_analis ta 
	left join all_trip a_t on DATE(ta.tpep_pickup_datetime) = a_t.date
	where passenger_count = 2
	group by DATE(tpep_pickup_datetime), a_t.at_count
), three_table as (
	select min(total_amount) as min_3, max(total_amount) as max_3, DATE(tpep_pickup_datetime), count(*), 
			(1.0*count(*)/a_t.at_count)*100 as percentage_3p
	from taxi_analis ta 
	left join all_trip a_t on DATE(ta.tpep_pickup_datetime) = a_t.date
	where passenger_count = 3
	group by DATE(tpep_pickup_datetime), a_t.at_count
), four_plus as (
	select min(total_amount) as min_4, max(total_amount) as max_4, DATE(tpep_pickup_datetime), count(*), 
			(1.0*count(*)/a_t.at_count)*100 as percentage_4p_plus
	from taxi_analis ta 
	left join all_trip a_t on DATE(ta.tpep_pickup_datetime) = a_t.date
	where passenger_count > 3
	group by DATE(tpep_pickup_datetime), a_t.at_count
)
select at.date, 
				zt.percentage_zero, zt.min_zero, zt.max_zero,
				ot.percentage_1p, ot.min_1, ot.max_1,
				tt.percentage_2p, tt.min_2, tt.max_2,
				tht.percentage_3p, tht.min_3, tht.max_3,
				ft.percentage_4p_plus, ft.min_4, ft.max_4
from all_trip at
left join zero_table zt on at.date=zt.date
left join one_table ot on at.date=ot.date
left join two_table tt on at.date=tt.date
left join three_table tht on at.date=tht.date
left join four_plus ft on at.date=ft.date
where at.date between '2020-01-01' and '2020-01-31'
