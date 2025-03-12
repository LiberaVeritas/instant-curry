import Editor, { loader } from '@monaco-editor/react';
import React from 'react'; 
import { saveToProofs } from './supabase';

export const WebEditor = ({ editorRef, setErrorLine, setErrorToken, setFeedback, setDecorations }) => {
    
    // main code editor box 
    return React.createElement(Editor, {
        height: "100%",
        defaultLanguage: "instant-curry",
        theme: "curry-theme",
        defaultValue: "(* Write your proof here *)",
        onMount: (editor) => {
          editorRef.current = editor;
          const savedCode = localStorage.getItem("userCode");   // persistence w/ local storage
          if (savedCode) editor.setValue(savedCode); 
        },
        onChange: () => handleEditorChange(editorRef, setErrorLine, setErrorToken, setFeedback),
      });
  };

  // load a proof, for sample section and saved proofs 
  export const handleSelectProof = (editorRef, proofContent, fileName, setProofTitle) => {
    // to do -> add fileName in layout (bottom section)
    if (editorRef.current) {
      editorRef.current.setValue(proofContent);
      setProofTitle(fileName);
      localStorage.setItem("proofTitle", proofName);
    }
  };

  export const newProof = async (session, editorRef, setErrorLine, 
    setErrorToken, setFeedback, setDecorations, setProofs, setSaveStatus, proofName, setProofTitle) => {
    { session ? (
      await saveProof(editorRef, setSaveStatus, setProofs, proofName),
      handleClearEditor(editorRef, setProofTitle)
      
    ) : (
      handleClearEditor(editorRef, setProofTitle)
    )}
  };


  // saves current editor content in user database
  export const saveProof = async (editorRef, setSaveStatus, setProofs, proofName) => { 
  
    const code = editorRef.current.getValue();
    
    if (!code.trim()) { // to do -> replace trim with same trimming is handleGrade
      setSaveStatus({ success: false, message: "Empty proof." });
      return;
    }
  
    try {
      const response = await saveToProofs(editorRef, setProofs, proofName);
        
      if (response.error) {
        setSaveStatus({ success: false, message: response.error });
      } else {
        setSaveStatus({ success: true, message: "Proof saved successfully!" });
      }
    } catch (error) {
      console.error("Error saving proof:", error);
      setSaveStatus({ success: false, message: "Unexpected error." });
    }
  };

  

// Export proof as .ic file
export const handleDownload = (editorRef) => {
    const proof = editorRef.current.getValue();
    const blob = new Blob([proof], { type: "text/plain" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = "proof.ic";
    a.click();
    URL.revokeObjectURL(a.href);
};

// Import .ic file and load into editor
export const handleFileUpload = (editorRef, event) => {
    const file = event.target.files[0];
  
    if (file) {
      const reader = new FileReader();
      reader.onerror = () => {
        alert("An error occurred while reading the file : try again.");
        reader.abort(); 
      };
      
      reader.onload = (e) => {
        editorRef.current.setValue(e.target.result);
      };
      reader.readAsText(file);
    }
};

// init the editor, language, theme etc. 
export const initializeEditor = (editorRef) => { 
  

  loader.init().then((monaco) => {
    // define as monaco language and set tokens 
    monaco.languages.register({ id: "instant-curry" });
    monaco.languages.setMonarchTokensProvider("instant-curry", {
      tokenizer: {
        root: [
            // to do -> clean this up 
          // Proof language 
          [/\b(WTS|SEP|RHS|REC|IH|LHS|INDUCTION|FORALL|PROOF|CASE|AXIOM)\b/, "proof"],
          [/\b(ON|LET|WITH|BY|THEN)\b/, "prooflight"],

          // Stand outs
          [/\b(THEOREM|DEFINITION|PRINT)\b/, "theorem"],
          [/\b(defn)\b/, "theoremlight"],
          [/\b(QED|EOF|END)\b/, "end"],
          
          // Eventually remove 
          [/\b(TYTREE|TYNAT|TYLST|TYARROW)\b/, "type"],

          [/\b(NODE|NIL|EMPTY|CONS)\b/, "structs"],

          // OCAML --------------------
          [/\b(let|in|rec|fun|function|match|with|if|then|else|begin|end|type|module|struct|sig|val|external|open|include|exception|try|of|as|assert|lazy|and|or|not|mutable|to|downto|while|for|do|done|when)\b/, "keyword"],
          [/\b(int|float|bool|string|char|unit|list|array|option|ref)\b/, "type"],
          [/->/, "arrow"],

          [/\(\*/, "comment", "@comment"], // match opening (* and enter comment state


          [/[@^~#&$!%?|]/, "operator"],
          [/[(){}[\]]/, "delimiter"],
          [/[:,;]/, "separator"],
          [/\||::/, "symbols"],
          ],
          comment: [
            // allow nested comments by re-entering comment state
            [/\(\*/, "comment"], //  "@push"],
        
            // match closing *) , exit comment state
            [/\*\)/, "comment", "@pop"],
        
            // match comment body 
            [/[^(*]+/, "comment"],
        
            // handle single * that is not part of *)
            [/\*/, "comment"],
            [/\(/, "comment"],
          ],
      },
    });

    // & define its theme 
    monaco.editor.defineTheme("curry-theme", {
      base: "vs", // ('vs', 'vs-dark', 'hc-black')
      inherit: true, 
      rules: [
        { token: "end", foreground: "#FF7B00", fontStyle: "bold"},
        { token: "theorem", foreground: "#0000FF", fontStyle: "bold"},
        { token: "theoremlight", foreground: "#0000FF"},
        { token: "proof", foreground: "#800080", fontStyle: "bold" },
        { token: "prooflight", foreground: "#800080" },
        { token: "delimiter", foreground: "#00008B" },
        { token: "separator", foreground: "#FF4500", fontStyle: "bold" },
        { token: "symbols", foreground: "#A52A2A", fontStyle: "bold" },
        { token: "structs", foreground: "#8B0000", fontStyle: "bold" },
        { token: "keyword", foreground: "#A52A2A", fontStyle: "bold" },
        { token: "type", foreground: "#3E428B", fontStyle: "bold" },
        { token: "arrow", foreground: "#000080", fontStyle: "bold" },
        { token: "operator", foreground: "#808080", fontStyle: "bold" },
        { token: "comment", foreground: "#AAAAAA", fontStyle: "italic" },
      ],
      colors: {
        "editor.background": "#FFFFFF",
        "editorLineNumber.foreground": "#FFA500",
      },
    });
    
  });
}

// Persistence: 
// Save editor content to localStorage
export const handleEditorChange = (editorRef, setErrorLine, setErrorToken, setFeedback) => {
  localStorage.setItem("userCode", editorRef.current.getValue());
  setErrorLine(null);              // Reset errors 
  setErrorToken("");    
  setFeedback({ message: "", type: "" });
};

// Clear editor content
export const handleClearEditor = (editorRef, setProofTitle) => {
  editorRef.current.setValue(""); 
  localStorage.removeItem("userCode");      // remove saved content from localStorage
  const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
  const defaultFilename = `proof_${timestamp}.ic`;
  setProofTitle(defaultFilename);
  localStorage.setItem("proofTitle", defaultFilename);
};

// This is where the code actually gets sent to ocaml  
export const handleGrade = (editorRef, setFeedback, setErrorLine, setErrorToken, setDecorations, setAdvice) => {
    let userCode = editorRef.current.getValue();
    userCode = userCode.replace(/\(\*[\s\S]*?\*\)/g, "").trim(); // Trim comments out
    
    // Empty input
    if (!userCode) {
      setFeedback({ message: "Empty input", type: "empty" });
      setErrorLine(null);
      setErrorToken("");
      setDecorations([]);
      return;
    }
    
    // Non-empty: send to OCaml
    const result = globalThis.grade(userCode);

    try {
      const parsedResult = JSON.parse(result); 

      // Error feedback 
      if (parsedResult.error) {
        setFeedback({ message: parsedResult.error, type: "error" }); 
        
        // Decorate error 
        if (parsedResult.line) { 
          setErrorLine(parsedResult.line);
          setErrorToken(parsedResult.token || "");
        }

        // Advice 
        if (parsedResult.advice) {
          setAdvice(parsedResult.advice);
        }
      } 

      // Normal feedback 
      else {
        setFeedback({ message: `Result: ${parsedResult.result}`, type: "success" });
        setErrorLine(null);
        setErrorToken("");
        setDecorations([]);
      }
    } catch (e) {
      setFeedback({ message: `${result}`, type: "error" });
    }
  };

  
export default WebEditor;
