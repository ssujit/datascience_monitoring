drop table if exists count_hu_krs;
select kreise_sn_stats.ags as ags_krs, count(*) as count_hu
into count_hu_krs
from hu_sn_umring_repaired 
join kreise_sn_stats 
on ST_Intersects(ST_Centroid(hu_sn_umring_repaired.geom), kreise_sn_stats.geom)
group by kreise_sn_stats.ags;

alter table kreise_sn_stats
add column count_hu integer,
add column dichte_hu double precision;

update kreise_sn_stats
set count_hu = count_hu_krs.count_hu
from count_hu_krs																		
where kreise_sn_stats.ags = count_hu_krs.ags_krs;

update kreise_sn_stats
set dichte_hu = count_hu/kfl;