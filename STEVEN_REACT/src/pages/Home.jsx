import CtrtBoard from "./ctrt/CtrtBoard";

const Home = () => {

  return (
    <>
      <div style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'var(--bg)'
      }}>
        <h1 style={{
          fontSize: '40px',
          fontWeight: '900',
          color: 'var(--text-primary)',
          letterSpacing: '-1px',
          margin: 0,
          opacity: 0.9
        }}>
          DASH BOARD
        </h1>
        <div style={{
          marginTop: '10px',
          marginBottom: '20px',
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
      <div className="content-wrapper" style={{ alignSelf: 'flex-start', padding: '6px 16px' }}>
        <section>
          <h1 className="section-title board">계약 현황</h1>
          <CtrtBoard />
        </section> 
      </div>
    </>
  );
};

export default Home;