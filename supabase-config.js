/*
========================================================
SAAMS SUPABASE CONFIGURATION
========================================================

Replace the two values below with your Supabase project
URL and Publishable/Anon key.

IMPORTANT:
DO NOT put your service_role key or secret key here.

========================================================
*/


const SUPABASE_URL =
    "https://bldfafyniwxlhwfhiznb.supabase.co/rest/v1/";


const SUPABASE_PUBLISHABLE_KEY =
    "sb_publishable_C8IyHqS7ZzxVUD0scboavg_OFpKKOXa";



/*
========================================================
CREATE SUPABASE CLIENT
========================================================
*/

if(

    SUPABASE_URL.startsWith("http") &&

    !SUPABASE_URL.includes(
        "YOUR_SUPABASE"
    ) &&

    SUPABASE_PUBLISHABLE_KEY &&

    !SUPABASE_PUBLISHABLE_KEY.includes(
        "YOUR_SUPABASE"
    )

){

    window.saamsSupabase =
        supabase.createClient(

            SUPABASE_URL,

            SUPABASE_PUBLISHABLE_KEY

        );

}

else{

    window.saamsSupabase =
        null;

}
