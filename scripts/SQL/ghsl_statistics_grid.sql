drop table if exists pop1990;
select sn_grid_1km_25833.id, count(*) as point_count, sum(ghs_pop_sn_25833_points_1990.pop1990sn) as sum_pop_1990
into pop1990
from sn_grid_1km_25833 
join ghs_pop_sn_25833_points_1990 
on st_intersects(sn_grid_1km_25833.geom, ghs_pop_sn_25833_points_1990.geom)
group by sn_grid_1km_25833.id;


drop table if exists pop2015;
select sn_grid_1km_25833.id, count(*) as point_count, sum(ghs_pop_sn_25833_points_2015.pop2015sn) as sum_pop_2015
into pop2015
from sn_grid_1km_25833 
join ghs_pop_sn_25833_points_2015 
on st_intersects(sn_grid_1km_25833.geom, ghs_pop_sn_25833_points_2015.geom)
group by sn_grid_1km_25833.id;


drop table if exists builtup1990;
select sn_grid_1km_25833.id, count(*) as point_count, avg(ghs_built_sn_25833_points_1990.abgeschnitt) as avg_built_up_1990
into builtup1990
from sn_grid_1km_25833 
join ghs_built_sn_25833_points_1990 
on st_intersects(sn_grid_1km_25833.geom, ghs_built_sn_25833_points_1990.geom)
group by sn_grid_1km_25833.id;


drop table if exists builtup2014;
select sn_grid_1km_25833.id, count(*) as point_count, avg(ghs_built_sn_25833_points_2014.abgeschnitt) as avg_built_up_2014
into builtup2014
from sn_grid_1km_25833 
join ghs_built_sn_25833_points_2014 
on st_intersects(sn_grid_1km_25833.geom, ghs_built_sn_25833_points_2014.geom)
group by sn_grid_1km_25833.id;


drop table if exists ghsl_statistics_grid;
select geom, id, ST_Area(geom)/1000000 as area_grid
into ghsl_statistics_grid
from sn_grid_1km_25833;

alter table ghsl_statistics_grid
add column pop1990 double precision,
add column pop2015 double precision,
add column delta_pop1990_2015 double precision,

add column builtup1990 double precision,
add column builtup2014 double precision,
add column delta_builtup_1990_2014 double precision;

update ghsl_statistics_grid
set pop1990 = pop1990.sum_pop_1990
from pop1990																		
where ghsl_statistics_grid.id = pop1990.id;

update ghsl_statistics_grid
set pop2015 = pop2015.sum_pop_2015
from pop2015																		
where ghsl_statistics_grid.id = pop2015.id;

update ghsl_statistics_grid
set builtup1990 = builtup1990.avg_built_up_1990
from builtup1990																		
where ghsl_statistics_grid.id = builtup1990.id;

update ghsl_statistics_grid
set builtup2014 = builtup2014.avg_built_up_2014
from builtup2014																		
where ghsl_statistics_grid.id = builtup2014.id;



--getrennt weil Berechnung nur mit in einem vorherigen Schritt berechneten Spalten klappt
update ghsl_statistics_grid
set delta_pop1990_2015 = pop2015-pop1990,
delta_builtup_1990_2014 = builtup2014-builtup1990;
	
