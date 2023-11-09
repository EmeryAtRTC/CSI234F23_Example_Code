-- Create a login on master
create login hrAPI with password = '@piPassword123';

create user hrAPI for login hrAPI;

GRANT SELECT ON SCHEMA::HR TO hrAPI;