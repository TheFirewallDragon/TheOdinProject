console.log("Hello World");

const figures = { 0: "paper", 1: "scissors", 2: "rock" };
const figuresByNames = { "paper": 0, "scissors": 1, "rock": 2 };
const results = { "[0,1]": 0, "[0,2]": 1, "[1,0]": 1, "[1,2]": 0, "[2,0]": 0, "[2,1]": 1, "[0,0]": 2, "[1,1]": 2, "[2,2]": 2 };
const scoreNames = { 1: "Win", 0: "Lose", 2: "Tie" }
let userResult = 0;
let computerResult = 0;
let gameStarted = false;
let round = 0;
let playerSelection = '';


function getComputerChoice() {
    let choice = Math.floor(Math.random() * 3);
    //console.log(choice);
    switch (choice) {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
    }
}


function playRound() {

    // your code here!
    console.log('new round ')
    let computerSelection = getComputerChoice();

    playerSelection = figuresByNames[playerSelection];
    let result = `[${playerSelection},${computerSelection}]`

    let getResult = results[result]

    if (getResult == 1) {
        userResult += 1;
    } else if (getResult == 0) {
        computerResult += 1
    }

    if (getResult == 1) {
        return `You ${scoreNames[getResult]}! ${figures[playerSelection]} beats ${figures[computerSelection]}`
    } else if (getResult == 0) {
        return `You ${scoreNames[getResult]}!  ${figures[computerSelection]} beats ${figures[playerSelection]} `
    } else { return `It' s a tie! ${figures[computerSelection]} ties with ${figures[playerSelection]} ` }
}

function game() {
    btnStart.textContent = 'Start game';
    winner.textContent = 'WISH YOU LUCK !!!';
    userResult = 0;
    computerResult = 0;
    round = 1;
    divRound.textContent = `Round: ${round}`;
    divResult.firstElementChild.textContent = `User: ${userResult}`;
    divResult.lastElementChild.textContent = `Computer: ${computerResult}`;

    //adding event 
    div1.addEventListener('click', activateListener);
}

function gameOver() {
    btnStart.textContent = 'Start new game';
    div1.removeEventListener('click', activateListener)

    if (userResult == 5) {
        winner.textContent = 'The winner is YOU!!!'
    } else { winner.textContent = 'The winner is the COMPUTER!!!' }

}

function activateListener(e) {
    console.log(e.target.textContent)
    playerSelection = e.target.textContent.toLowerCase();
    temp = false;
    let prompt = playRound();
    round++;
    divRound.textContent = `Round: ${round}`;
    divResult.firstElementChild.textContent = `User: ${userResult}`;
    divResult.lastElementChild.textContent = `Computer: ${computerResult}`;
    divPrompt.textContent = prompt;
    if (userResult == 5 || computerResult == 5) {
        gameOver();
    }
}

//Adding 3 buttons of choice
const btn1 = document.createElement('button');
btn1.textContent = figures[0];
btn1.className = 'b1'
const btn2 = document.createElement('button');
btn2.textContent = figures[1];
btn2.className = 'b2'
const btn3 = document.createElement('button');
btn3.textContent = figures[2];
btn3.className = 'b3'



//Appending newly created buttons to the div element
const div1 = document.querySelector('#chooseBtn');

div1.style.display = 'flex'
div1.appendChild(btn1);
div1.appendChild(btn2);
div1.appendChild(btn3);


//Some css styling
let main = document.querySelector('.main');


//main.style.width='450px';
main.style.backgroundColor = 'grey';
main.style.display = 'flex';
main.style.flexDirection = 'column'
main.style.alignItems = 'center'
main.className = 'hidden';

//Starting new game by clicking the start button
const btnStart = document.getElementById('start')
btnStart.addEventListener('click', game);

let divRound = document.querySelector('#round');
let divResult = document.querySelector('#result');
let divPrompt = document.querySelector('#prompt')
let winner = document.querySelector('.winner');









