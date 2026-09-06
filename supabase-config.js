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
    "YOUR_SUPABASE_PROJECT_URL";


const SUPABASE_PUBLISHABLE_KEY =
    "YOUR_SUPABASE_PUBLISHABLE_KEY";



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
