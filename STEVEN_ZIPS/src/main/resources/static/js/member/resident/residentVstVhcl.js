
const modal = document.getElementById("visitModal");

const openModalBtn = document.getElementById("openModalBtn");

const closeModalBtn =
    document.getElementById("closeModalBtn");

const closeModalBtn2 =
    document.getElementById("closeModalBtn2");


openModalBtn.addEventListener("click", () => {
    modal.classList.add("active");
});


closeModalBtn.addEventListener("click", closeModal);
closeModalBtn2.addEventListener("click", closeModal);

function closeModal(){
    modal.classList.remove("active");
}


window.addEventListener("click", e => {
    if(e.target === modal){
        closeModal();
    }
});

const visitDate =
    document.getElementById("visitDate");

const visitHour =
    document.getElementById("visitHour");


const now = new Date();

const offset = now.getTimezoneOffset();

const localToday =
    new Date(now.getTime() - offset * 60000)
        .toISOString()
        .split("T")[0];

visitDate.min = localToday;

function validateStayHour(){

    const input =
        document.getElementById("stayHr");

    const value =
        Number(input.value);

    if(!value || value < 1 || value > 72){

        alert("체류시간은 최대 72시간까지 가능합니다.");

        highlightError(input);

        return false;
    }

    return true;
}

const stayHrInput =
    document.getElementById("stayHr");

stayHrInput.addEventListener("input", () => {

    let value =
        Number(stayHrInput.value);

    if(value > 72){
        stayHrInput.value = 72;
    }

    if(value < 1 && stayHrInput.value !== ""){
        stayHrInput.value = 1;
    }
});

stayHrInput.addEventListener("wheel", e => {
    e.target.blur();
});

document.getElementById("registerVisitBtn").addEventListener("click", registerVisit);

/*입력 function*/
function registerVisit(){

    const data = {
        vstVhclTyCd : document.getElementById("vstVhclTyCd").value,
        vstVhclNo   : document.getElementById("vstVhclNo").value.trim(),
        vstrNm      : document.getElementById("vstRm").value.trim(),
        visitDate   : document.getElementById("visitDate").value,
        visitHour   : document.getElementById("visitHour").value,
        stayHr      : document.getElementById("stayHr").value,
        vstPrpsCn   : document.getElementById("vstPrpsCn").value.trim()
    };

    fetch("/resident/vstVhcl/register/"+aptCmplexNo,{
        method : "POST",
        headers : {
            "Content-Type" : "application/json",
            [csrfHeader] : csrfToken
        },
        body : JSON.stringify(data)
    })
        .then(res => {

            if(!res.ok){
                throw new Error("등록 실패");
            }

            return res.text();
        })
        .then(() => {

            alert("방문 예약 등록 완료");

            closeModal();

            loadVisitList();
        })
        .catch(err => {
            alert(err.message);
        });
}


function validateVhclNo(backNo){

    const regex = /^[0-9]{4}$/;

    const input =
        document.getElementById("vstVhclNo");

    if(!regex.test(backNo)){

        alert("차량번호 뒤 4자리를 입력해주세요.");

        highlightError(input);

        return false;
    }

    return true;
}