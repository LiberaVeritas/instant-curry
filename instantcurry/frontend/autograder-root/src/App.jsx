import React, { useRef, useState, useEffect } from 'react';
import { logo, write, clear, login, download, upload, mail } from "../media/media";

import WebEditor, { 
  initializeEditor,
  handleClearEditor,
  newProof,
  saveProof,
  handleGrade,
  handleSelectProof,
  handleDownload,
  handleFileUpload
 } from "./components/WebEditor";

import {
  handleLogin,
  handleLogout,
  loadSavedProof,
  listen,
  initSession,
  deleteProof
} from "./components/supabase";

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
  
  // For code decorations, error highlighting
  const [errorLine, setErrorLine] = useState(null);
  const [errorToken, setErrorToken] = useState("");
  const [decorations, setDecorations] = useState([]);

  // For editing the proof title 
  const [proofTitle, setProofTitle] = useState(() => {
    const timestamp = new Date().toISOString().replace(/[:.]/g, "-"); 
    const defaultFilename = `proof_${timestamp}.ic`
    return localStorage.getItem("proofTitle") || {defaultFilename};
  });
  const [isEditingTitle, setIsEditingTitle] = useState(false);
  
  // Sample proofs 
  const proofFiles = [ 
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

  // ------------------------------------------------
  // HELPER FUNS 
  // ------------------------------------------------


  // save helper function
  const handleSave = async () => {
    await saveProof(editorRef, setSaveStatus, setProofs, proofTitle);
  };

  // title editing 
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

  // login, logout and load helper functions 
  const handleLogIn = async (provider, email) => {
    await handleLogin(provider, setSession, email);
    setShowLoginMenu(false); // Close menu after clicking
  }

  const handleLogOut = async () => { 
    await handleLogout(setSession, setProofs); 
  }

  const handleLoad = async (editorRef, ID, setProofTitle) => {
    loadSavedProof(editorRef, ID, setProofTitle); 
  }

  // ------------------------------------------------
  // useEffects()  
  // ------------------------------------------------
  
  // init session, listener & editor
  useEffect(() => {
    // init editor
    initializeEditor(editorRef);
    initSession(setSession, setProofs);
    listen(setSession); 
  }, []);

  // set up Editor with decorations
  useEffect(() => {
      if (!editorRef.current || !errorLine) return;

      const editor = editorRef.current;
      const model = editor.getModel();
      if (!model) return;

      // clear prev decorations
      setDecorations((prevDecorations) => {
        return editor.deltaDecorations(prevDecorations, []);
      });
        
      editor.revealLineInCenter(errorLine, monaco.editor.ScrollType.Smooth);    // isn't smooth anymore? 
    
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
      
      // error token is not displayed currently? 
      const lineContent = model.getLineContent(errorLine);
      const startIndex = lineContent.indexOf(errorToken);

      if (errorToken && startIndex !== -1) {
        decorations.push({
          range: new monaco.Range(errorLine, startIndex + 1, errorLine, startIndex + errorToken.length + 1),
          options: { inlineClassName: "error-token" },
        });
      }
      setDecorations(editor.deltaDecorations([], decorations));

  }, [errorLine, errorToken]);

  // ------------------------------------------------
  // RETURN 
  // ------------------------------------------------

  return (
    <div>
      {/* Header with login */}
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

            { showLoginMenu && (
              <LoginMenu handleLogIn={handleLogIn} /> 
            ) }  
          
          </div> )}
      
      </div>
      </header>

      <div className='general-container'> 
        <div className='left-container'>
          <div className='editor-container'>
          
            {/* Web Editor */}
            <div style={{ height: "20vw", }}>

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

            {/* Orange component under code editor with title & buttons */}
            <div className='orange-fill'>
              <div className="buttons"> 
                <button 
                  className="run-button" 
                  onClick={() => {
                    handleGrade(editorRef, setFeedback, setErrorLine, setErrorToken, setDecorations, setAdvice);
                  }} >
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
                      onKeyDown={(event) => {
                        if (event.key === "Enter") {
                          handleTitleBlur(event);
                        }
                      }}
                      autoFocus
                      className="name-input"
                    />
                  ) : (
                    <span className="name-text">{proofTitle}</span>
                  )}
                </div>
              </div>

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
                    onClick={() => handleClearEditor(editorRef, setProofTitle)}  
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
          
          {/* Download & Upload buttons */}
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
          

          {/* Sample Proofs Section */}
          <h3 className="section-title"> 
              Browse Sample Proofs
          </h3>
          
          <div className="section" style={{marginBottom: "15px"}} >
            <div className='proofs-box'>
              {proofFiles.map((file, index) => (
                <div
                  key={index}
                  onClick={() => handleSelectProof(editorRef, file.content, file.name, setProofTitle)}
                  className='proof'>
                    {file.name}
                </div>
              ))}
            </div>
          </div>

          {/* Saved Proofs section */}
          {session && 
          (
            
              <div className="section" >
                <h3 className="section-title" style={{color: "white"}}> 
                  Saved Proofs
                </h3>
              <div className='proofs-box'>

              {proofs.map((proof) => (
                  <div
                    key={proof.id}
                    onClick={() => handleLoad(editorRef, proof.id, setProofTitle)}
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
            </div> )}
          </div>
      </div>
      
      {/* Modal popup for error/feedback messages */}
      <FeedbackPopup 
        feedback={feedback} 
        onClose={() => setFeedback({ message: "", type: "" })} 
      />
    
    </div>
  );
}

const FeedbackPopup = ({ feedback, onClose }) => {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    if (feedback.message) {
      setVisible(true);

      const timer = setTimeout(() => { // Closes after 3 sec 
        setVisible(false);
        onClose(); // Clears feedback state in parent
      }, 3000);

      return () => clearTimeout(timer);
    }
  }, [feedback, onClose]);

  return (
    <div
      style={{
        position: "fixed",
        bottom: visible ? "20px" : "-100px", // Slide-in animation
        left: "50%",
        transform: "translateX(-50%)",
        padding: "12px 20px",
        borderRadius: "8px",
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
        border: `1px solid ${
          feedback.type === "success" ? "green" : feedback.type === "error" ? "red" : "grey"
        }`,
        textAlign: "center",
        minWidth: "250px",
        maxWidth: "80%",
        transition: "bottom 0.3s ease-in-out", 
        boxShadow: "0px 4px 6px rgba(0,0,0,0.1)",
      }}
    >
      {feedback.message}
    </div>
  );
};

const LoginMenu = ({ handleLogIn }) => {
  const [showEmailModal, setShowEmailModal] = useState(false);
  const [email, setEmail] = useState("");

  const handleEmailLogin = () => {
    if (!email) {
      alert("Please enter a valid email");
      return;
    }
    handleLogIn("email", email); 
    setShowEmailModal(false); 
  };

  return (
    <>
      <div className="login-menu">
        <button onClick={() => handleLogIn("github", "")} className="login-button">
          <img src="https://cdn-icons-png.flaticon.com/512/25/25231.png" alt="GitHub" className="login-icon" />
        </button>

        <button onClick={() => handleLogIn("gitlab", "")} className="login-button">
          <img src="https://cdn-icons-png.flaticon.com/512/5968/5968853.png" alt="GitLab" className="login-icon" />
        </button>

        <button onClick={() => setShowEmailModal(true)} className="login-button">
          <img src={mail} alt="Email Login" style={{width: "40px"}}/>
        </button>
      </div>

      {showEmailModal && (
        <>
          <div className="modal-overlay" onClick={() => setShowEmailModal(false)}></div>
          <div className="modal">
            <div className="modal-content">
              <span className="close" onClick={() => setShowEmailModal(false)}>&times;</span>
              <h3>Login with Email</h3>
              <input 
                type="email" 
                placeholder="Enter your email" 
                value={email} 
                onChange={(e) => setEmail(e.target.value)} 
                className="email-input"
              />
              <button onClick={handleEmailLogin} className="modal-button">
                Submit
              </button>
            </div>
          </div>
        </>)}
    </>);
};


export default App;
