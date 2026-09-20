//alert('Hello World!!! js script over here')

var name = "Elaine";
var height = 160;
var concat = name + " " + height;

//document.write(concat);
/*var datos = document.getElementById("datos");
//datos.innerHTML = concat;
datos.innerHTML = `
    <h1>Hello I'm the text box</h1>
    <h2>My name is ${name}</h2>
    <h3>My height is ${height} cm</h3>
`;

if (height < 190) {
    datos.innerHTML += '<h1>You are a short person</h1>'
} else {
    datos.innerHTML += '<h1>You are a tall person</h1>'
}

for (var i = 2000; i <= 2020; i++) {
    datos.innerHTML += `<h1>We are in the year: ${i}</h1> ` 
}*/

function ShowMyName(name, height) {
var datos = document.getElementById("datos");
//datos.innerHTML = concat;
myData=`
    <h1>Hello I'm the text box</h1>
    <h2>My name is ${name}</h2>
    <h3>My height is ${height} cm</h3>
`;
return myData;
}

function Print() {
    var datos = document.getElementById("datos");
    datos.innerHTML = ShowMyName("Elaine", 160);
}

Print();

document.write('<h2>Name Lists</h2>')
var names = ['Joe', 'Silk', 'Thomas', 'Test'];
//alert(names[3]);
/* for (var i = 0; i < names.length; i++) {
    document.write(i + '\t' + names[i] + '<br/>');
} */

/* names.forEach(function(names) {
    document.write(names + '<br/>');
}); */

names.forEach((names) => {
    document.write(names + '<br/>');
});