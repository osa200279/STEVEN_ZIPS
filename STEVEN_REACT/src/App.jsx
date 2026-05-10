import './styles/centralAside.css';
import './styles/centralHeader.css';
import './styles/centralCommon.css';
import MainLayout from "./components/layout/MainLayout";
import Home from "./pages/Home";

function App() {
  return (
    <MainLayout>
      <Home />
    </MainLayout>
  );
}

export default App;