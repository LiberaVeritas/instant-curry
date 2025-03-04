import React, { useRef, useState, useEffect } from 'react';
import Header from "./components/Header"; // redo header
import logo from "../media/name.png";
import write from "../media/write.png";
import clear from "../media/clear.png";
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
  const [proofTitle, setProofTitle] = useState(() => {
    return localStorage.getItem("proofTitle") || "Proof";
  });
  const [isEditingTitle, setIsEditingTitle] = useState(false);
  
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
  const [saveStatus, setSaveStatus] = useState(null); 
  const [showLoginMenu, setShowLoginMenu] = useState(false);
  const [advice, setAdvice] = 
  useState("Start writing your proof and use Instant Curry to get some advice on it!")

  // init editor
  initializeEditor(editorRef);
  
  // init sessions & listener 
  useEffect(() => {
    initSession(setSession, setProofs);
    listen(setSession); 
  }, []);

  // save helper function
  const handleSave = async () => {
    await saveProof(editorRef, setSaveStatus, setProofs, proofTitle);
  };

  const handleTitleClick = () => {
    setIsEditingTitle(true); 
  };

  
  const handleTitleChange = (event) => { 
    setProofTitle(event.target.value);
    localStorage.setItem("proofTitle", event.target.value);
  }; 

  const handleTitleBlur = (event) => { 
    setIsEditingTitle(false);
  }
  
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
    
      // to do -> fix error token. 
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

  // login, logout and load helper functions 
  const handleLogIn = async (provider) => {
    await handleLogin(provider, setSession);
    setShowLoginMenu(false); // Close menu after clicking
  }

  const handleLogOut = async () => { 
    await handleLogout(setSession, setProofs); 
  }

  const handleLoad = async (editorRef, ID) => {
    loadSavedProof(editorRef, ID); 
  }

  // ------------------------------------------------
  // RETURN 
  // ------------------------------------------------

  return (
    <div>

    <header className="header">
      
      <img 
        src={logo} 
        alt="logo" 
        className="small-image"
      /> 
      
      <div className="padding-10"> 
        {session ? (
          <button 
            className="white-orange-button" 
            onClick={handleLogOut}>
              Logout
          </button>
          ) : (
          <div style={{ position: "relative" }}>
            <img 
              src={login} 
              alt="Login" 
              className='icon-65'
              onClick={() => setShowLoginMenu(!showLoginMenu)}
            />

            {showLoginMenu && (
              <div 
                className='login-menu'
              >
          
          <button 
            onClick={() => handleLogIn("github")} 
            className='login-button'>
            
            <img src="https://cdn-icons-png.flaticon.com/512/25/25231.png" 
              alt="GitHub" 
              className="login-icon" />
          
          </button>
          
          <button // replace with email 
            onClick={() => handleLogIn("gitlab")} 
            className='login-button'>
            
            <img src="https://cdn-icons-png.flaticon.com/512/5968/5968853.png" 
              alt="GitLab" 
              className="login-icon" />
          
          </button>
          
        </div> )} </div> )}
      </div>
    </header>

    <div className='general-container'> 
      <div className='left-container'>
        <div className='editor-container'>
              
          <div style={{
            height: "20vw", 
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
            <div className="buttons"> 
              <button className="run-button" 
                onClick={() => handleGrade(editorRef, setFeedback, 
                setErrorLine, setErrorToken, setDecorations, setAdvice)} >
                  RUN
              </button>

              {session && (
                <button className="white-orange-button" 
                 onClick={handleSave} >
                  SAVE 
                </button>
              )}

              <div className="name-button" onClick={handleTitleClick}>
                {isEditingTitle ? (
                  <input
                    type="text"
                    defaultValue={proofTitle}
                    onChange={(event) => handleTitleChange(event)}
                    onBlur={(event) => handleTitleBlur(event)}
                    autoFocus
                    className="name-input"
                  />
                ) : (
                  <span className="name-text">{proofTitle}</span>
                )}
              </div>
                </div>
              
              
              
             {/* <div class="input-group">
                <label class="input-group__label" for="myInput">{proofTitle}</label>
                <input type="text" id="myInput" class="input-group__input" value="This is my input" />
              </div> */}
              

              <div className="column-flex"> 
                  
                <div className='small-button'>
                
                  <button id="new-proof" 
                      onClick={() => newProof(session, editorRef, setErrorLine, setErrorToken, setFeedback, setDecorations, setProofs, setSaveStatus, proofTitle)}  
                      style={{ display: "none"}}>
                      New proof 
                  </button>

                  <label htmlFor="new-proof" >
                    <img 
                      src={write} 
                      alt="new-proof" 
                      className="small-icon"/>
                  </label>
                  
                </div>

                <div className='small-button'>
                
                  <button id="clear-proof" 
                    onClick={() => handleClearEditor(editorRef, setErrorLine, setErrorToken, setFeedback, setDecorations)}  
                    style={{ display: "none"}}>
                      Clear proof 
                  </button>

                  <label htmlFor="clear-proof" >
                    <img 
                      src={clear} 
                      alt="clear-proof" 
                      className="small-icon"/>
                  </label>
                  
                </div>
              </div>
            </div>
          </div> 

          <div className="advice-container">
              <h2 className="advice-title">Steps from here</h2>
              <p className="advice-text">{advice}</p>
          </div>
        </div>

        <div className='right-container'> 

          <div> 
            <button 
              id="download-button" 
              onClick={() => handleDownload(editorRef)}
              style={{ display: "none"}}>
                Download .ic
            </button>

            <label htmlFor="download-button">
              <img 
                src={download} 
                alt="Download" 
                className="wide-icon"/> 
            </label>
            
          </div>
          
          <div>
            
            <input
              type="file"
              id="upload-file"
              accept=".ic"
              style={{ display: "none" }}
              onChange={(event) => handleFileUpload(editorRef, event)}
            />
            
            <label htmlFor="upload-file">
              <img 
                src={upload} 
                alt="Upload" 
                className="wide-icon"/> 
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
            <div style={{ marginTop: "20px"}}>
              <h3 className="section-title"> 
                  Saved Proofs
              </h3>

              <div className="section" >
            
              <div className='proofs-box'>

              {proofs.map((proof) => (
                  <div
                    key={proof.id}
                    onClick={() => handleLoad(editorRef, proof.id)}
                    className='proof'>
                      {proof.filename}

                      <button className='X-button' 
                      onClick={(e) => {
                        e.stopPropagation();
                        deleteProof(proof.id, setProofs, setFeedback);
                      }}>
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
