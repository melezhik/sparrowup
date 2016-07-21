sub insert_check_into_db {

    my $check_id = shift or confess 'usage: insert_check_into_db(*check_id)';

    my $sql = Mojo::SQLite->new('sqlite:db/main.db');

    my $db = $sql->db;

    $db->query( 'insert into checks ( check_id ) values (?)', $check_id );


    return;
}

sub update_check_in_db {

    my $check_id = shift or confess 'usage: update_check_in_db(*check_id,state)';

    my $state = shift or confess 'usage: update_check_in_db(check_id,*state)';

    my $sql = Mojo::SQLite->new('sqlite:db/main.db');

    my $db = $sql->db;

    $db->query('update users set state = ? where  check_id = ?', $state, $check_id );

    return;
}

1;

