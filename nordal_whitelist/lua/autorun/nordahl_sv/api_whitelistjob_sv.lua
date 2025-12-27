/* 
- Product of osgmod.com -
Script create by Nordahl you can find here : https://osgmod.com/gmod-scripts/1402/job-whitelist-system
Profile page of the Creator : https://osgmod.com/profiles/76561198033784269

Gmod Script Market Place : https://osgmod.com/gmod-scripts/page-1

- Do not duplicate or reproduce.
- By buying my scripts you contribute to the creations and the updates
- Dont leak, Lack of recognition fuelled by thanks does not bring food to the table
- Respect my work please

Code Minified with Originahl-Scripts Software : https://osgmod.com/en/help/code-minification-optimisation

The satisfied members who offered the coffee and supported me : https://osgmod.com/coffee
*/

local cfg=nordahl_cfg_1402

-- API
-- API_Whitelistjob_nordahl(ply,job_name,category_name) job_name OR category_name can be nil
-- test of : API_Whitelistjob_nordahl 

function echo_api_test_job( ply , b , c ) 	-- this is just for test
local ply = ply 							--The guy will test with the command
local job = c[1] 							--Test with the job Medic	

print ( "API_Whitelistjob_nordahl" , ply , job )

	if API_Whitelistjob_nordahl( ply , job , nil ) == true then
		print ("API_Whitelistjob_nordahl : Accepted job")
		ply:changeTeam(job)
	end

end
concommand.Add( "echo_api_test_job" , echo_api_test_job )

function echo_api_test_cat( ply , b , c )	-- this is just for test
local ply = ply 							--The guy will test with the command
local job = nil 							--Job
local job_categori = c[1] 					
	
print ( "API_Whitelistjob_nordahl" , ply , job_categori )

	if API_Whitelistjob_nordahl( ply , nil , job_categori ) == true then
		print ( "API_Whitelistjob_nordahl : Accepted cat" )
	end

end
concommand.Add( "echo_api_test_cat" , echo_api_test_cat )
