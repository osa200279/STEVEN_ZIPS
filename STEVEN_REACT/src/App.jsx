import SecurityTestPage from "./SecurityTestPage"

function App() {

  return (
    <div style={{ maxWidth: '800px', margin: '50px auto' }}>
      <h1>Steven zip.s Dashboard System test</h1>
      <p>리액트 프로젝트가 정상 작동 중입니다.</p>
      <hr />
      
      {/* 분리한 테스트 페이지 삽입 */}
      <SecurityTestPage />
      
      <footer style={{ marginTop: '30px', fontSize: '0.8em', color: '#999' }}>
        Development Mode | SVN Linked
      </footer>
    </div>
  )
}

export default App
