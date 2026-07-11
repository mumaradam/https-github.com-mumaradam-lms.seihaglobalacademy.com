// Username -> Password
function showPasswordStep() {

    const username = document.getElementById("input28").value.trim();

    if (username === "") {
        alert("Please enter your username.");
        return;
    }

    document.getElementById("stepUsername").style.display = "none";
    document.getElementById("stepPassword").style.display = "block";

    document.getElementById("input55").focus();
}

// Password -> Username
function showUsernameStep() {

    document.getElementById("stepPassword").style.display = "none";
    document.getElementById("stepUsername").style.display = "block";

    document.getElementById("input28").focus();
}

// Show / Hide Password
function initializePasswordToggle() {

    const passwordInput = document.getElementById("input55");
    const showIcon = document.querySelector(".button-show");
    const hideIcon = document.querySelector(".button-hide");
    const toggle = document.querySelector(".password-toggle");

    if (!toggle) return;

    toggle.addEventListener("click", function () {

        if (passwordInput.type === "password") {

            passwordInput.type = "text";

            showIcon.style.display = "none";
            hideIcon.style.display = "inline-block";

        } else {

            passwordInput.type = "password";

            showIcon.style.display = "inline-block";
            hideIcon.style.display = "none";
        }
    });
}

// Enter key on Username
function initializeUsernameEnter() {

    const usernameInput = document.getElementById("input28");

    if (!usernameInput) return;

    usernameInput.addEventListener("keydown", function (e) {

        if (e.key === "Enter") {
            e.preventDefault();
            showPasswordStep();
        }

    });
}

// Enter key on Password
function initializePasswordEnter() {

    const passwordInput = document.getElementById("input55");

    if (!passwordInput) return;

    passwordInput.addEventListener("keydown", function (e) {

        if (e.key === "Enter") {
            e.preventDefault();

            document
                .querySelector("#stepPassword button[type='submit']")
                .click();
        }

    });
}

// Initialize Page
document.addEventListener("DOMContentLoaded", function () {

    initializePasswordToggle();
    initializeUsernameEnter();
    initializePasswordEnter();

});