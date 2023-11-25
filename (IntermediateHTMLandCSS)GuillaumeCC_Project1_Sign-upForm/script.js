const url = new URLSearchParams(window.location.search)
const password = url.get('password');
const password2 = url.get('password-2');
const firstName = url.get('first-name')
const lastName = url.get('last-name')
const email = url.get('email')
const submit = document.querySelector('#submit-button');
const div = document.querySelector('.pass-field');
const alertP = document.querySelector('#alert')
const introText = document.querySelector('#intro-text')
const divForm = document.querySelector('#form')
const form = document.querySelector('form')
const logIn = document.querySelector('#log-in')
const formText = document.querySelector('#form-text')
const intro = document.querySelector('#intro')
const pass = document.querySelector('#pass')
const pass2 = document.querySelector('#pass-2')

function checkPassword() {
    password == password2 ? match = true : match = false;
    return match;
}

function match() {
    console.log(checkPassword());
    if (checkPassword() == true) {
        introText.remove();
        form.remove();
        logIn.remove();
        formText.remove();
        welcome = document.createElement('p');
        welcome.id = 'welcome';
        welcome.textContent = `Welcome, ${firstName} ${lastName}`;
        intro.appendChild(welcome);
        emailText = document.createElement('p');
        emailText.id = 'welcome-email';
        emailText.textContent = `A confirmation email was send to ${email}`;
        intro.appendChild(emailText);

    }
    else {
        if(alertP != null) {return};
        pass.classList.add('wrong-pass');
        pass2.classList.add('wrong-pass');
        alert = document.createElement('p');
        alert.textContent = 'The passwords do not match, try again';
        alert.style.color = 'red';
        alert.style.fontSize = '0.7rem';
        alert.id = 'alert'
        div.appendChild(alert);
    }
}
match()

