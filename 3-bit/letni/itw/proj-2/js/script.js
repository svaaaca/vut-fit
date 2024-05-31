/* 
 * @file script.js
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Source code for the script of the website (JavaScript).
 * @date 2024-04-26
 */

/* Add smooth scrolling to all links. */
$(document).ready(function() {
    $("a").on('click', function(event) {
        if (this.hash !== "") {
            event.preventDefault();
            var hash = this.hash;
            $('html, body').animate({
                scrollTop: $(hash).offset().top
            }, 2048, function() {
                window.location.hash = hash;
            });
        }
    });
});

/* Toggle between showing and hiding the navigation menu links. */
function toggle() {
    if (window.innerWidth <= 768) {
        var link = document.getElementById("menu-link");
        if (link.style.display === "block") {
            link.style.display = "none";
        }
        else {
            link.style.display = "block";
        }
    }
}

/* Hide the navigation menu links. */
function hide() {
    if (window.innerWidth <= 768) {
        var link = document.getElementById("menu-link");
        link.style.display = "none";
    }
}

/* Reveal the study period (FIT). */
function fit() {
    var fit = document.getElementById("fit-period");
    if (fit.textContent === "REVEAL THE STUDY PERIOD") {
        fit.textContent = "2021 – present";
    }
    else {
        fit.textContent = "REVEAL THE STUDY PERIOD";
    }
}

/* Reveal the study period (GCH). */
function gch() {
    var gch = document.getElementById("gch-period");
    if (gch.textContent === "REVEAL THE STUDY PERIOD") {
        gch.textContent = "2013 – 2021";
    }
    else {
        gch.textContent = "REVEAL THE STUDY PERIOD";
    }
}
