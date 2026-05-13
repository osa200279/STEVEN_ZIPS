import React, { useEffect, useState } from 'react'
import { useOutlet, useOutletContext } from 'react-router-dom'
import requestApi from '../util/api/requestApi';

function Ctrt() {
  const { admInfo } = useOutletContext();
  const [rowData, setRowData] = useState([]);

  useEffect(() => {
    const fetchContracts = async () => {
      try{
        const response = await requestApi.get('/api/react/adm/ctrt');

        if(Array.isArray(response.data)){
          setRowData(response.data);
        }else{
          console.error("서버 응답이 배열 형식이 아닙니다 : ", response.data);
          setRowData([]);
        }
      }catch(error){
        console.error("데이터 로드 실패 : ", error);
        setRowData([]);
      }
    };

    fetchContracts();
  }, []);

  const columnDefs = useMemo(() => ({
    
  }),[]);

  return (
    <div>Ctrt page</div>
  )
}

export default Ctrt