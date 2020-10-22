drop table if exists osm_roads_regional_sn_25833;
select * 
into osm_roads_regional_sn_25833
from osm_roads_classified_sn_25833
where fclass 
in ('motorway', 'motorway_link', 'Trunk', 'primary', 'primary_link', 'secondary', 'secondary_link');



drop table if exists kreise_sn_stats;
select geom, ags, gen, bez, ewz, kfl, ST_Area(geom) as area_m2
into kreise_sn_stats
from vg250_krs_sn_25833;

drop table if exists roads_intersect_krs;
select kreise_sn_stats.ags as ags_krs, 
		sum(ST_Length(ST_Intersection(kreise_sn_stats.geom, osm_roads_regional_sn_25833.geom)))/1000 as roads_length_km
into roads_intersect_krs
from osm_roads_regional_sn_25833 
join kreise_sn_stats 
on ST_Intersects(osm_roads_regional_sn_25833.geom, kreise_sn_stats.geom)
group by kreise_sn_stats.ags;	

alter table kreise_sn_stats
add column roads_length double precision,
add column roads_dichte double precision;

update kreise_sn_stats
set roads_length = roads_intersect_krs.roads_length_km
from roads_intersect_krs																		
where kreise_sn_stats.ags = roads_intersect_krs.ags_krs;

update kreise_sn_stats
set roads_dichte = roads_length/kfl;
																		
select * from kreise_sn_stats;