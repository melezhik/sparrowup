drop table if exists checks;

create table checks(
    check_id text primary key, 
    status text not null DEFAULT 'scheduled', 
    t timestamp DEFAULT CURRENT_TIMESTAMP
);

