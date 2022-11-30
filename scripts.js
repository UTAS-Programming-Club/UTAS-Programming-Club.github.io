// get the nav div
var nav = document.getElementById('nav');


nav.innerHTML = `

<header>
    <div id = "logoEtc" style="margin: 0; display: flex; justify-content: left;">
        <!-- Round logo with a link back home-->
        <a href="../"><img style="border-radius: 50%;" src="../logo.png" alt="programming club logo" height="100rem"></a>

        <!-- Title -->
        <h1 style="margin-left: 1rem; ">PROGRAMMING CLUB</h1>
    </div>
    
    
    <!-- Page Banner and NavBar (same on every page) -->
    <div id="header">
        <div id="banner">

        </div>
        <div id="navbar">
            <div class="navlink"><a href="../">Home</a></div>
            <div class="navlink"><a href="about.html">About Us</a></div>
            <!-- <div class="navlink"><a href="projects.html">Current Projects</a></div>  Work in progress-->

            <!-- <div class="navlink"><a href="calendar.html">Calendar</a></div>  Work in progress-->
            
            <div class="navlink"><a href="membership.html">Membership</a></div>
            <div class="navlink"><a href="contact.html">Contact Us</a></div>  
            
        </div>
    </div>
</header>

<div id="animated-background"></div>


<div id="xray-cursor">
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink= "http://www.w3.org/1999/xlink">
  <defs>
      <clipPath id="mask">
          <circle id="mask-circle" cx="50%" cy="50%" r="8%"/>
        </clipPath>
  </defs>
  <g clip-path>
  <circle id="circle-shadow" cx="50%" cy="50%" r="8%" style="stroke: rgb(0, 234, 255); fill: rgb(255, 255, 255); stroke-width: 5;" />
</svg>
</div>
`

//xray cpde above and below

/*
 * BASED ON CODE FROM Noel Delgado | @pixelia_me
 *
*/

var svgElement = document.querySelector('svg');
var maskedElement = document.querySelector('#mask-circle');
var circleFeedback = document.querySelector('#circle-shadow');
var svgPoint = svgElement.createSVGPoint();

function cursorPoint(e, svg) {
    svgPoint.x = e.clientX;
    svgPoint.y = e.clientY;
    return svgPoint.matrixTransform(svg.getScreenCTM().inverse());
}

function update(svgCoords) {
    maskedElement.setAttribute('cx', svgCoords.x);
    maskedElement.setAttribute('cy', svgCoords.y);
    circleFeedback.setAttribute('cx', svgCoords.x);
    circleFeedback.setAttribute('cy', svgCoords.y);
}

window.addEventListener('mousemove', function(e) {
  update(cursorPoint(e, svgElement));
}, false);

document.addEventListener('touchmove', function(e) {
    e.preventDefault();
    var touch = e.targetTouches[0];
    if (touch) {
        update(cursorPoint(touch, svgElement));
    }
}, false);