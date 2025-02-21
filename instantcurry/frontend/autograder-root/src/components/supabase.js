import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY
const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: { persistSession: true }
  });
  
// need to figure out the session var, inconsistent across here & App.jsx i think
export const getSession = async () => {
  const { data: { session } } = await supabase.auth.getSession();
  return session;
};

// login logic - currently just github. 
export const handleLogin = async (setSession) => {
  await supabase.auth.signInWithOAuth({ provider: "github" });
  
  const { data } = await supabase.auth.getSession();
  setSession(data.session);
};

// getter function for ID (eventually remove, figure out this with session)
export const getUserID = async () => {
  const { data: { user }, error } = await supabase.auth.getUser();
  return user?.id
}

// load a saved proof
export const loadSavedProof = async (editorRef, ID) => { 

  try {
    const { data, error } = await supabase
      .schema('api')
      .from('proofs')
      .select('content').eq('id', ID) 
      .single();

    if (error) throw error;
    
    editorRef.current.setValue(data.content);

  } catch (error) {
    console.error("Error fetching proofs:", error.message);
  }
} 

// Listen for auth state changes
export const listen = async (setSession) => {
  const { data: authListener } = supabase.auth.onAuthStateChange(
     (_event, session) => {
       setSession(session);
    }
  );

  return () => { 
    authListener.subscription.unsubscribe();
  };
}

// initialize the session
export const initSession = async (setSession, setProofs) => {
      const session = await getSession();
      // console.log("Session initialized:", session);

      const ID = await getUserID();
      if (ID) { // session?.user?.id) {
        setSession(session);
        await fetchProofs(supabase, setProofs); // ID,  // session.user.id
      } else {
        console.log("No user session found.");
      }
};

// logout logic 
export const handleLogout = async (setSession, setProofs) => {
  await supabase.auth.signOut();
  setSession(null);
  setProofs([]);
};

// fetch function
export const fetchProofs = async (supabase, setProofs) => {

  const ID = await getUserID();
  if (!ID) return; 

  try {
    const { data, error } = await supabase
      .schema('api')
      .from('proofs')
      .select('user_id, id, filename').eq('user_id', ID) //"id , filename, content, created_at")
      //.eq('user_id(*)', ID)
      .order("created_at", { ascending: false });

    console.log("fetchwing");
    if (error) throw error;

    // if user has no proofs, creates a placeholder proof
    // eventually remove this, but the database wasn't working if the user didn't have at least one. 
    //    actually that should be fixed now with the policy fix

    if (!data || data.length === 0) {
      
      // move this logic to the placeholder in the naming function 
      const timestamp = new Date().toISOString().replace(/[:.]/g, "-"); 
      const defaultFilename = `proof_${timestamp}.ic`;

      const { data: newProof, error: insertError } = await supabase
        .schema("api")
        .from("proofs")
        .insert(
          {
            user_id: ID, // user_id,
            content: "(* Demo. *)",
            filename: defaultFilename
          }
        )
        .select();

      if (insertError) throw insertError;

      setProofs(newProof); // Update state w new proof
    } else {
      setProofs(data); // User already has proofs, set them
    }
  } catch (error) {
    console.error("Error fetching proofs:", error.message);
  }
};

// saves a proof to database 
export const saveToProofs = async (editorRef, proofContent, setProofs) => { // re-do args here
  try {

    const { data: { user }, error: authError } = await supabase.auth.getUser();
    
    if (authError || !user) {
      // console.error("User not authenticated:", authError?.message);
      return { error: "User not authenticated" };
    }

    // saves proof
    const { data, error } = await supabase
      .schema("api")  
      .from("proofs") 
      .insert([
        { 
          user_id: user.id, 
          content: editorRef.current.getValue(), // "proof-content",  
          filename: "test"      
        }
      ])

    if (error) { throw error; } 
  
    fetchProofs(supabase, setProofs);
    return { data };

  } catch (error) {  return { error: error.message };
  }
};

// delete a proof from saved 
export const deleteProof = async (proofId, setProofs, setFeedback) => {
  try {
    const { error } = await supabase
      .schema("api").from("proofs")
      .delete()
      .eq("id", proofId);

    if (error) throw error;

    setProofs((prevProofs) => prevProofs.filter(p => p.id !== proofId));
    setFeedback({ type: "success", message: "Proof deleted successfully." });

  } catch (error) {
    setFeedback({ type: "error", message: error.message });
  }
};

export default supabase;

