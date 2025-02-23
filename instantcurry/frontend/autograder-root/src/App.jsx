import React, { useRef, useState, useEffect } from 'react';
import Header from "./components/Header";
import logo from "../media/name.png";
import login from "../media/login.png";


import WebEditor, { 
  initializeEditor,
  handleClearEditor,
  newProof,
  handleGrade,
  handleSelectProof,
  handleDownload,
  handleFileUpload
 } from "./components/WebEditor";

import { saveProof } from "./components/WebEditor";

import supabase from './components/supabase';

import {
  //getSession,
  handleLogin,
  handleLogout,
  loadSavedProof,
  //fetchProofs,
  listen,
  initSession,
  deleteProof
} from "./components/supabase";

// Buttons 
import download from "../media/DOWNLOAD.png";
import upload from "../media/UPLOAD.png";

// Sample proofs
import factProof from "../proofs/fact.ic?raw"; 
import mapProof from "../proofs/map.ic?raw";
import testProof from "../proofs/test.ic?raw";


function App() {

  // ------------------------------------------------
  // VARS 
  // ------------------------------------------------
  
  // State management
  const editorRef = useRef(null);
  const [feedback, setFeedback] = useState({ message: "", type: "" });
  const [errorLine, setErrorLine] = useState(null);
  const [errorToken, setErrorToken] = useState("");
  const [decorations, setDecorations] = useState([]);
  
  const proofFiles = [ 
    // to do -> change, put them in 'proofs' under all users if that's possible? 
      // or another table, so can change the examples easier
    { name: "Fact Proof", content: factProof },
    { name: "Map Proof", content: mapProof },
    { name: "Test Proof", content: testProof },
  ];

  // Supabase
  const [session, setSession] = useState(null);
  const [proofs, setProofs] = useState([]);
  const [saveStatus, setSaveStatus] = useState(null); // rem this! don't actually need it now, only display/debug  
    // same goes for feedback? re-structure & clean all the feedback / error msgs

  const [showLoginMenu, setShowLoginMenu] = useState(false);

  // init editor
  initializeEditor(editorRef);
  
  // init sessions & listener 
  useEffect(() => {
    initSession(setSession, setProofs);
    listen(setSession); 
  }, []);

  // save helper function
  const handleSave = async () => {
    await saveProof(editorRef, setSaveStatus, setProofs);
  };
  
  // line deco 
  useEffect(() => {
      // set up Editor 
      if (!editorRef.current) return;
      const editor = editorRef.current;
      const model = editor.getModel();
      if (!model) return;

      // clear prev decorations
      setDecorations((prevDecorations) => {
        return editor.deltaDecorations(prevDecorations, []);
      });
    
      if (!errorLine) return;  // If no error, return early
      
      editor.revealLineInCenter(errorLine, monaco.editor.ScrollType.Smooth);    // scrolls to the error line smoothly
    
      let decorations = [
        {
          range: new monaco.Range(errorLine, 1, errorLine, 1),
          options: {
            isWholeLine: true,
            className: "error-highlight fade-in",
            glyphMarginClassName: "error-glyph", 
          }
        }
      ];
    
      // to do -> fix error token. rn it's not actually doing anything (decorations is never used?)
      if (errorToken) {
        const lines = model.getLinesContent();
        const lineContent = lines[errorLine - 1];
    
        if (lineContent) {
          const startIndex = lineContent.indexOf(errorToken);
          if (startIndex !== -1) {
            decorations.push({
              range: new monaco.Range(errorLine, startIndex + 1, errorLine, startIndex + errorToken.length + 1),
              options: {
                inlineClassName: "error-token"
              }
            });
          }}}

      setDecorations(editor.deltaDecorations([], decorations));
  }, [errorLine, errorToken]); 
    

  // ------------------------------------------------
  // Proof Writing, grading, retrieving 
  // ------------------------------------------------
  

  // debug function, see if needed for loading 
  //useEffect(() => {
  //  console.log("Current session state:", session);
  //}, [session]);

  // login, logout and load helper functions 
  const handleLogIn = async (provider) => {
    await handleLogin(provider, setSession);
    setShowLoginMenu(false); // Close menu after clicking
  }

  const handleLogOut = async () => { 
    await handleLogout(setSession, setProofs); 
  }

  const handleLoad = async (editorRef, ID) => {
    console.log(ID);
    loadSavedProof(editorRef, ID); 
    //await handleSelectProof(editorRef, proof.content, proof.filename);
  }

  // ------------------------------------------------
  // RETURN 
  // ------------------------------------------------

  return (
    <div>

    <header className="header" style={{ alignItems: "center", justifyContent: "space-between", padding: "10px" }}>

      <div style={{ padding: "20px", textAlign: "center" }}>
        <img src={logo} alt="Logo" className="h-12" style={{ height: "80px" }} />
      </div>

      <div style={{ position: "relative", justifyContent: "flex-end", alignItems: "center", padding: "20px" }}>
        {session ? (
          <button className="white-orange-button" onClick={handleLogOut}>Logout</button>
          ) : (
          <div style={{ position: "relative" }}>

          <img 
            src={login} 
            alt="Login" 
            style={{ width: "65px", height: "auto", cursor: "pointer" }} 
            onClick={() => setShowLoginMenu(!showLoginMenu)}
          />

          {showLoginMenu && (
            <div style={{
              position: "absolute",
              top: "60%",
              left: "-120px",  
              transform: "translateY(-50%)",
              padding: "5px",
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
              zIndex: "1000",
              justifyContent: "center"
            }}>
          
          <button onClick={() => handleLogIn("github")} style={{ background: "none", border: "none", cursor: "pointer", marginTop: "-10px" }}>
            <img src="https://cdn-icons-png.flaticon.com/512/25/25231.png" alt="GitHub" style={{ width: "40px", filter: "invert(100%)" }} />
          </button>
          
          <button onClick={() => handleLogIn("gitlab")} style={{ background: "none", border: "none", cursor: "pointer", marginTop: "-10px"}}>
            <img src="https://cdn-icons-png.flaticon.com/512/5968/5968853.png" alt="GitLab" style={{ width: "40px", filter: "invert(100%)" }} />
          </button>
          
        </div>
        )}
        </div>
        )}
        </div>
      </header>

      <div style={{ 
        width: "100vw",
        display: "flex", 
        flexDirection: "row",
        alignItems: "center"}}>

        
        <div style={{ width: "70vw", display: "flex", flexDirection: "column", alignItems: "center" }}>

          <div className='editor-container'>
              
              <div style={{
                  width: "100%", 
                  height: "300px", 
                  overflow: "auto"
              }}>

                <WebEditor 
                  editorRef={editorRef}
                  feedback={feedback} 
                  setFeedback={setFeedback} 
                  setErrorLine={setErrorLine} 
                  setErrorToken={setErrorToken} 
                  setDecorations={setDecorations} 
                  errorLine={errorLine} 
                  errorToken={errorToken} 
                />
              </div>

              <div className='orange-fill'>

              <button className="white-orange-button" 
                onClick={() => handleGrade(editorRef, setFeedback, setErrorLine, setErrorToken, setDecorations)}  
                style={{ marginBottom: "10px" , fontSize: "30px" }}>
                  Get Result
              </button>

              {session && (
                <button className="white-orange-button" 
                 onClick={handleSave} >
                  Save Proof
                </button>
              )}

              <button className="white-orange-button" 
                onClick={() => newProof(session, editorRef, setErrorLine, setErrorToken, setFeedback, setDecorations, setProofs, setSaveStatus)}  
                style={{marginRight: "5%"}}>
                  New proof
              </button>
                 

                  <button className="white-orange-button" 
                    onClick={() => handleClearEditor(editorRef, setErrorLine, setErrorToken, setFeedback, setDecorations)}  
                    style={{marginRight: "5%"}}>
                      Clear Code
                  </button>
              </div>
          </div> 
        </div>

        <div style={{padding: "15px", display: "flex", flexDirection: "column"}}> 

          <div style={{ 
            padding: "10px"}}>
           
            <button id="download-button" 
              onClick={() => handleDownload(editorRef)}
              style={{ display: "none"}}>
                Download .ic
            </button>

            <label htmlFor="download-button" style={{ cursor: "pointer" }}>
              <img src={download} alt="Download" style={{ width: "175px", height: "auto" }} />
            </label>
            
          </div>
          
          <div style={{ 
            padding: "10px"}}>
            
            <input
              type="file"
              id="upload-file"
              accept=".ic"
              style={{ display: "none" }}
              onChange={(event) => handleFileUpload(editorRef, event)}
            />
            
            <label htmlFor="upload-file" style={{ cursor: "pointer" }}>
              <img src={upload} alt="Upload" style={{ width: "175px", height: "auto" }} />
            </label>

          </div>
          
          <h3 className="section-title"> 
            
              Browse Sample Proofs
          
          </h3>
          
          <div className="section" >
            
            <div className='proofs-box'>

              {proofFiles.map((file, index) => (
                <div
                  key={index}
                  onClick={() => handleSelectProof(editorRef, file.content, file.name)}
                  className='proof'>
                    {file.name}
                </div>
              ))}
            </div>

          </div>

          {session && 
          (
            <div style={{ marginTop: "20px", textAlign: "center" }}>
              <h3 className="section-title"> 
                Saved proofs
              </h3>

              <div className="section" >
            
              <div className='proofs-box'>

              {proofs.map((proof) => (
                  <div
                    key={proof.id}
                    onClick={() => handleLoad(editorRef, proof.id)}
                    className='proof'>
                      {proof.filename}

                      <button onClick={() => deleteProof(proof.id, setProofs, setFeedback)}>
                        X
                      </button>
                  </div>
                  
                ))}
              </div>
            </div>
            </div> )}
          </div>
      </div>
      
        
      {feedback.message && ( // probably a better way to do this? 
        <div
          style={{
            marginTop: "20px",
            padding: "10px",
            border: `1px solid ${
              feedback.type === "success"
                ? "green"
                : feedback.type === "error"
                ? "red"
                : "grey"
            }`,
            backgroundColor:
            feedback.type === "success"
              ? "#d4edda"
              : feedback.type === "error"
              ? "#f8d7da"
              : "#e9ecef", 
            color:
              feedback.type === "success"
                ? "green"
                : feedback.type === "error"
                ? "red"
                : "grey", 
            borderRadius: "5px",
            width: "80%",
            margin: "20px auto",
            textAlign: "center",
          }}
        >
          {feedback.message}
        </div>
      )}
    </div>
  );
}

export default App;
