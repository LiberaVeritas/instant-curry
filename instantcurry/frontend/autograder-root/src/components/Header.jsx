import logo from "../../media/name.png";

const Header = () => {

  return (
    <header className="header">
      <img src={logo} alt="Logo" className="h-12" style={{height: "80px"}}/>
    </header>
  );
};

export default Header;
