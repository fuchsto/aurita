#!/bin/bash

echo $1
perl -pi -e 's/paracelsus/cuba/g' $1
perl -pi -e 's/GRANT ALL ON SEQUENCE/GRANT ALL ON/g' $1
perl -pi -e 's/REVOKE ALL ON SEQUENCE/REVOKE ALL ON/g' $1
perl -pi -e 's/GRANT SELECT,UPDATE ON SEQUENCE/GRANT ALL ON/g' $1
perl -pi -e 's/ON SEQUENCE/ON/g' $1

