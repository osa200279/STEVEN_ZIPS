function showToast({
                       title = "알림",
                       message = "",
                       type = "success",
                       duration = 4000,
                       onClick = null
                   }) {

    const container = document.getElementById("toastContainer");

    if (!container) {
        console.warn("toastContainer 없음");
        return;
    }

    const toast = document.createElement("div");

    toast.className = `toast ${type}`;

    toast.innerHTML = `
        <div class="toast-title">${title}</div>
        <div class="toast-message">${message}</div>
    `;

    if (onClick) {
        toast.addEventListener("click", onClick);
    }

    container.appendChild(toast);

    setTimeout(() => {

        toast.classList.add("hide");

        setTimeout(() => {
            toast.remove();
        }, 200);

    }, duration);
}