/* 사이드바 */
function toggleSidebar() {
    var s = document.getElementById('sidebar');
    if (s) s.classList.toggle('collapsed');
}
var logoIcon = document.getElementById('logoIcon');
if (logoIcon) {
    logoIcon.addEventListener('click', function(){
        var s = document.getElementById('sidebar');
        if (s && s.classList.contains('collapsed')) toggleSidebar();
    });
}