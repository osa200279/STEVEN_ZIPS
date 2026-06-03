import Anls from "./analytics/Anls";
import RecruitContainer from "./analytics/recruitment/RecruitContainer";
import ResidentContainer from "./analytics/resident/ResidentContainer";
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
          <div style={{display: 'flex', gap:'20px'}}>
            <div style={{ flex: 1, marginTop: '20px', height: '300px' }}>
              <h1 className="section-title board">진행중인 공고별 지원률</h1>
              <RecruitContainer />
            </div>
            <div style={{ flex: 1, marginTop: '20px', height: '300px' }}>
              <h1 className="section-title board">최근 6개월 입주자 수 추이</h1>
              <ResidentContainer />
            </div>
          </div>
        </section>
      </div>
    </>
  );
};

export default Home;