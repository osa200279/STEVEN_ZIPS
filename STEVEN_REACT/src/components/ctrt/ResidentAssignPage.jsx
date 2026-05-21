import '../../styles/common.css';
import AptSearchSelect
    from '../../components/ctrt/AptSearchSelect';

const ResidentAssignPage = () => {

    return (

        <div className="content-wrapper">

            <div className="page-header">

                <div>

                    <h2 className="page-title">
                        입주민 배정
                    </h2>

                    <p className="page-subtitle">
                        Resident Assign Management
                    </p>

                </div>

            </div>

            <div className="table-wrapper">

                <div
                    style={{
                        padding: '24px'
                    }}
                >

                    <AptSearchSelect />

                </div>

            </div>

        </div>
    );
};

export default ResidentAssignPage;