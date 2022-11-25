// get the nav div
var nav = document.getElementById('nav');


nav.innerHTML = `

<header>
    <div style="margin: 1rem; display: flex; justify-content: left;">
        <!-- Round logo with a link back home-->
        <a href="../"><img style="border-radius: 50%;" src="../logo.png" alt="programming club logo" height="100rem"></a>

        <!-- Title -->
        <h1 style="margin-left: 1rem;">PROGRAMMING CLUB</h1>
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

`