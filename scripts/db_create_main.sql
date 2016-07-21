drop table if exists checks;

create table checks(
    check_id text primary key, 
    status text not null DEFAULT 'scheduled', 
    project text not null,
    server text not null,
    t timestamp DEFAULT CURRENT_TIMESTAMP
);

