import { useNavigate } from 'react-router-dom';

function Ann() {
    const navigate = useNavigate();
    const move = () =>{
        navigate("/amd/ann/register");
    }

    return (
        <>
            <div>Ann</div>
            <button onClick={move}>이동</button>
        </>
    )
}

export default Ann