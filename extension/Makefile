MODULES = my_extension
EXTENSION = my_extension
DATA = $(EXTENSION)--1.0.sql

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)

# Include the PGXS build system
include $(PGXS)
