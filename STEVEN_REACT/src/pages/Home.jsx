
const Home = () => {
  return (
    <div style={{ 
      display: 'flex', 
      flexDirection: 'column', 
      alignItems: 'center', 
      justifyContent: 'center', 
      height: '100%',
      backgroundColor: 'var(--bg)' 
    }}>
      <h1 style={{ 
        fontSize: '110px', 
        fontWeight: '900', 
        color: 'var(--text-primary)', 
        letterSpacing: '-5px',
        margin: 0,
        opacity: 0.9
      }}>WELCOME</h1>
      <div style={{
        marginTop: '10px',
        padding: '6px 16px',
        backgroundColor: 'rgba(59, 130, 246, 0.1)',
        borderRadius: '20px',
        color: 'var(--text-secondary)',
        fontSize: '15px',
        fontWeight: '600'
      }}>
        우리집맵핑 중앙관리 시스템
      </div>
    </div>
  );
};

export default Home;