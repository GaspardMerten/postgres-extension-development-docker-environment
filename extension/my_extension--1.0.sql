-- SQL objects (functions, types, etc.)
CREATE FUNCTION hello_world() RETURNS text
AS 'MODULE_PATHNAME', 'hello_world'
LANGUAGE C STRICT;
