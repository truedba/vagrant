drop procedure if exists test.get_result;
DELIMITER ;;
CREATE definer='root'@'localhost' PROCEDURE get_result()  
BEGIN


SET @row_number:=0;
SET @country:='';
create table result as
Select res.ISBN, res.country,res.rating from (

select @row_number:=CASE WHEN @country=t.country
                         THEN @row_number+1                                
                           ELSE 1                          
                        END AS row_number,
                         @country:=t.country AS country,
                         t.rating,
                         t.ISBN
                         from
 (select  br.ISBN,  bu.country, avg(br.`Book-Rating`) rating
from  test.`BX-Book-Ratings` br, 
     (select `User-ID`,location, substring(location, -1*(locate(' ,', REVERSE(location))-1)) as country from test.`BX-Users`

###### just to filter bad spelling from cursor########
        where location REGEXP '[:alpha:]$'
     ) bu
where br.`User-ID`=bu.`User-ID`
##### to filter mistakes in country names in data#####
and length(bu.country)>2
group by bu.country, br.ISBN
##### to filter books that was rated by 1 person comment this line to get full rating#####
having count(*)=2
order by bu.country desc, avg(br.`Book-Rating`) desc) t) res
where res.row_number<11;
select 'table has been created. run select * from test.result;';
END ;;
DELIMITER ;
