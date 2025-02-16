import Editor, { loader } from '@monaco-editor/react';
import React, { useRef, useState, useEffect } from 'react';
import Header from "./components/Header";

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

  // Editor & feedback vars
  const editorRef = useRef(null);
  const [feedback, setFeedback] = useState({ message: "", type: "" }); 
  const [errorLine, setErrorLine] = useState(null);
  const [errorToken, setErrorToken] = useState("");
  const [decorations, setDecorations] = useState([]);

  // Sample proofs
  const [selectedFile, setSelectedFile] = useState(null);
  const proofFiles = [
    { name: "Fact Proof", content: factProof },
    { name: "Map Proof", content: mapProof },
    { name: "Test Proof", content: testProof },
  ];


  // ------------------------------------------------
  // CONST FUNCTIONS
  // ------------------------------------------------


  // Load Sample Proof
  const handleSelectProof = (proofContent, fileName) => {
    if (editorRef.current) {
      editorRef.current.setValue(proofContent);
      setSelectedFile(fileName);
    }
  };

  // Get result from code  
  const handleGrade = () => {
    let userCode = editorRef.current.getValue();
    userCode = userCode.replace(/\(\*[\s\S]*?\*\)/g, "").trim(); // Trim comments out
    
    // Empty input
    if (!userCode) {
      setFeedback({ message: "Empty input", type: "empty" });
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
      } 

      // Normal feedback 
      else {
        setFeedback({ message: `Result: ${parsedResult.result}`, type: "success" });
        setErrorLine(null);
        setErrorToken("");
      }
    } catch (e) {
      setFeedback({ message: `${result}`, type: "error" });
    }
  };

  // Persistence: 
  // Save editor content to localStorage
  const handleEditorChange = () => {
    const code = editorRef.current.getValue();
    localStorage.setItem("userCode", code);

    // Reset errors 
    setErrorLine(null);
    setErrorToken("");
    setFeedback({ message: "", type: "" });
  };

  // Clear editor content
  const handleClearEditor = () => {
    editorRef.current.setValue(""); 
    localStorage.removeItem("userCode"); // Remove saved content from localStorage
    // Clear error cache (remove? useless?)
    setErrorLine(null);
    setErrorToken("");
    setFeedback({ message: "", type: "" });
    setDecorations([]);
  };

  // Export proof as `.ic` file
  const handleDownload = () => {
    const code = editorRef.current.getValue();
    const blob = new Blob([code], { type: "text/plain" });
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = "code.ic";
    a.click();
    URL.revokeObjectURL(a.href); // Clean up
  };

  // Import `.ic` file and load into editor
  const handleFileUpload = (event) => {
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

  

  // ------------------------------------------------
  // USE EFFECT 
  // ------------------------------------------------

  useEffect(() => {
    // Set up Editor 
    if (!editorRef.current) return;
    const editor = editorRef.current;
    const model = editor.getModel();
    if (!model) return;

    // With decoration
    setDecorations((prevDecorations) => {
      return editor.deltaDecorations(prevDecorations, []);
    });
  
    if (!errorLine) return;  // If no error, return early
    
    editor.revealLineInCenter(errorLine, monaco.editor.ScrollType.Smooth);    // Scrolls to the error line
  
    let decorations = [
      {
        range: new monaco.Range(errorLine, 1, errorLine, 1),
        options: {
          isWholeLine: true,
          className: "error-highlight fade-in",
          glyphMarginClassName: "error-glyph", // Makes visible in minimap
        }
      }
    ];
  
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
        }
      }
    }
  
    setDecorations(editor.deltaDecorations([], decorations));
}, [errorLine, errorToken]);




  // ------------------------------------------------
  // SET UP EDITOR
  // ------------------------------------------------

  loader.init().then((monaco) => {
    // Define custom language 'instant-curry'
    monaco.languages.register({ id: "instant-curry" });

    // Define its tokens 
    monaco.languages.setMonarchTokensProvider("instant-curry", {
      tokenizer: {
        root: [
          // Proof language 
          [/\b(WTS|SEP|RHS|REC|IH|LHS|INDUCTION|FORALL|PROOF|CASE|AXIOM)\b/, "proof"],
          [/\b(ON|LET|WITH|BY|THEN)\b/, "prooflight"],

          // Stand outs
          [/\b(THEOREM|DEFINITION|PRINT)\b/, "theorem"],
          [/\b(defn)\b/, "theoremlight"],
          [/\b(QED|EOF|END)\b/, "end"],
          
          // Eventually remove type annotations
          [/\b(TYTREE|TYNAT|TYLST|TYARROW)\b/, "type"],

          [/\b(NODE|NIL|EMPTY|CONS)\b/, "structs"],

          // OCAML --------------------
          [/\b(let|in|rec|fun|function|match|with|if|then|else|begin|end|type|module|struct|sig|val|external|open|include|exception|try|of|as|assert|lazy|and|or|not|mutable|to|downto|while|for|do|done|when)\b/, "keyword"],
          [/\b(int|float|bool|string|char|unit|list|array|option|ref)\b/, "type"],
          [/->/, "arrow"],

          [/\(\*/, "comment", "@comment"], // Match opening (* and enter comment state


          [/[@^~#&$!%?|]/, "operator"],
          [/[(){}[\]]/, "delimiter"],
          [/[:,;]/, "separator"],
          [/\||::/, "symbols"],
          ],
          comment: [
            // Allow nested comments by re-entering comment state
            [/\(\*/, "comment"], //  "@push"],
        
            // Match closing *) , exit comment state
            [/\*\)/, "comment", "@pop"],
        
            // Match comment body 
            [/[^(*]+/, "comment"],
        
            // Handle single * that is not part of *)
            [/\*/, "comment"],
            [/\(/, "comment"],
          ],
      },
    });

    // And its theme 
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




  // ------------------------------------------------
  // RETURN 
  // ------------------------------------------------

  return (
    <div>

      <Header/>

      <div style={{ 
        display: "flex", 
        maxWidth: "100vw",
        alignItems: "center"}}>

        <div className="editor-container">

          <Editor
            height="100%"
            defaultLanguage="instant-curry"
            theme="curry-theme"
            defaultValue="(* Write your proof here *)"
            onMount={(editor) => {
              editorRef.current = editor;

              // Load editor content from localStorage on mount
              const savedCode = localStorage.getItem("userCode");
              if (savedCode) {
                editor.setValue(savedCode);
              }
            }}
            onChange={handleEditorChange}
          />
        
        </div>

        <div style={{padding: "5px"}}> 

          {/* Download button (hidden)*/}
          <div style={{ position: "relative", 
            display: "inline-block", 
            marginLeft: "3px",
            padding: "5px"}}>
           
            <button id="download-button" 
              onClick={handleDownload} 
              style={{ display: "none"}}>
                Download .ic
            </button>

            <label htmlFor="download-button" style={{ cursor: "pointer" }}>
              <img src={download} alt="Download" style={{ width: "175px", height: "auto" }} />
            </label>
            
          </div>
          
          {/* Upload button (hidden)*/}
          <div style={{ position: "relative", 
            marginBottom: "10px",
            marginLeft: "3px",
            marginRight: "10px",
            display: "inline-block", 
            padding: "5px"}}>
            
            <input
              type="file"
              id="upload-file"
              accept=".ic"
              style={{ display: "none" }}
              onChange={handleFileUpload}
            />
            
            <label htmlFor="upload-file" style={{ cursor: "pointer" }}>
              <img src={upload} alt="Upload" style={{ width: "175px", height: "auto" }} />
            </label>

          </div>
          
          {/* Sample proofs */}
          <h3 style={{
              color: 'brown',
              width: "180px",
              textAlign: "center",
              marginBottom: "10px",
              lineHeight: "20px"
              }}> 

              Browse Sample Proofs
          
          </h3>
          <div style={{ 
            textAlign: "center", 
            width: "180px", 
            padding: "10px",
            background: "rgb(131, 41, 41)", 
            borderRadius: "20px", 
            }}>
            
            <div className='proofs-box'>

              {proofFiles.map((file, index) => (
                <div
                  key={index}
                  onClick={() => handleSelectProof(file.content, file.name)}
                  className='proof'>
                    {file.name}
                </div>
              ))}
            </div>

          </div>

        </div>

      </div>


      <div style={{ display: "flex", 
        alignItems: "center", 
        flexDirection: "column",
        }}>

        <button className="clear-orange-button" onClick={handleGrade} 
          style={{ marginBottom: "10px" , fontSize: "30px"}}>
            Get Result
        </button>
        
        <button className="clear-orange-button" onClick={handleClearEditor} 
          style={{ margin: "10px" }}>
            Clear Code
        </button>
       
      </div>
      
        // Colored output button (grey/green/red)
      {feedback.message && (
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