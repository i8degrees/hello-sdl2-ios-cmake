#!/bin/sh

url="http://testflightapp.com/api/builds.json"
file_path=$1

api_token=6b57f8a27a0c2fdfb7560ee339a381d9_MTU0NDE0MjIwMTQtMDEtMDIgMTQ6NTQ6MDAuOTU2Mzcy
team_name="iOS Developer"
team_token=23b154000d1ec6b903508f711704a589_MzE5NjgxMjAxNC0wMS0wMiAxNDo1NjowMi44MDE2MTI

notes="Testing builds with Upload API"
notify=False
dist_list="Internal"

#-F dsym=@testflightapp.app.dSYM.zip
curl "${url}" -F file=@"${file_path}" -F api_token="${api_token}" \
-F team_token="${team_token}" -F notes="${notes}" -F notify="${notify}" \
-F distribution_lists="${dist_list}"
