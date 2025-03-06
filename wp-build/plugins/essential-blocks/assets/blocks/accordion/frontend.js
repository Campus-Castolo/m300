(()=>{var e=window.eb_frontend,t=e.EBGetIconClass,r=e.EBGetIconType;document.addEventListener("DOMContentLoaded",(function(e){var n=document.querySelectorAll(".eb-accordion-container > .eb-accordion-inner");if(n){var l=document.documentElement,s=getComputedStyle(l).getPropertyValue("--eb-tablet-breakpoint").trim();s=s?parseInt(s,10):"1024";for(var c=window.innerWidth,d=function(){var e=n[u].parentElement,l=Number(e.getAttribute("data-transition-duration")),d=e.children[0].children,p=[];Array.from(d).forEach((function(e){p.push(e.querySelector(".eb-accordion-title-wrapper"))}));var y=e.getAttribute("data-accordion-type");"horizontal"===y&&c<=s&&(e.classList.remove("eb-accordion-type-horizontal"),y="accordion"),"toggle"===y?function(e){for(var t=0;t<e.length;t++){var r=e[t];b&&!m&&r.parentElement.getAttribute("id")===b&&(m=!0,T.call(r)),function(e){e.addEventListener("click",T),e.addEventListener("keydown",(function(t){" "!==t.key&&"Enter"!==t.key||(t.preventDefault(),T.call(e))}))}(r)}}(p):function(e){for(var t=0;t<e.length;t++){var r=e[t];b&&!m&&r.parentElement.getAttribute("id")===b&&(m=!0,z.call(r)),function(e){e.addEventListener("click",z),e.addEventListener("keydown",(function(t){" "!==t.key&&"Enter"!==t.key||(t.preventDefault(),z.call(e))}))}(r)}}(p);var b=window.location.hash.substr(1),m=!1;window.addEventListener("hashchange",(function(){var e=window.location.hash.substr(1);p.forEach((function(t){t.parentElement.getAttribute("id")===e&&(m=!0,"toggle"===y?T.call(t):z.call(t))}))})),p.forEach((function(e,t){var r=Math.random().toString(36).substr(2,7);e.setAttribute("id","eb-accordion-header-"+r),e.setAttribute("aria-controls","eb-accordion-panel-"+r),e.setAttribute("aria-expanded",!1),e.setAttribute("role","button");var o=e.nextElementSibling;o.setAttribute("id","eb-accordion-panel-"+r),o.setAttribute("aria-labelledby","eb-accordion-header-"+r),o.setAttribute("role","region"),e.addEventListener("keydown",(function(e){var r=e.which.toString(),o=e.ctrlKey&&r.match(/33|34/);if(r.match(/38|40/)||o){var i=r.match(/34|40/)?1:-1,a=p.length;p[(t+a+i)%a].focus(),e.preventDefault()}else if(r.match(/35|36/)){switch(r){case"36":p[0].focus();break;case"35":p[p.length-1].focus()}e.preventDefault()}}))}));var f=[];Array.from(d).forEach((function(e){f.push(e.querySelector(".eb-accordion-content-wrapper"))}));var v="eb-accordion-hidden";if(e.classList.add("eb_accdn_loaded"),"horizontal"!==y)for(var g=0;g<f.length;g++)f[g].style.height="0px";var h=document.createElement("span"),A=e.getAttribute("data-tab-icon")||"_ _",w=e.getAttribute("data-expanded-icon")||"_ _";A=t(A),w=t(w);var E=A.split(" ")[0],L="fontawesome"===r(A)?A.split(" ")[1]:A.split(" ")[2],S=w.split(" ")[0],P="fontawesome"===r(w)?w.split(" ")[1]:w.split(" ")[2];function q(e){var t=e.querySelector(".eb-accordion-icon")||h;t.classList.contains(P)?("dashicon"===r(P)&&t.classList.remove("dashicons"),t.classList.remove(S,P),"dashicon"===r(L)&&t.classList.add("dashicons"),t.classList.add(E,L)):("dashicon"===r(L)&&t.classList.remove("dashicons"),t.classList.remove(E,L),"dashicon"===r(P)&&t.classList.add("dashicons"),t.classList.add(S,P))}for(var x=function(e){if("true"==d[e].getAttribute("data-clickable")){if(f[e].setAttribute("data-collapsed","false"),"horizontal"!==y&&i(f[e],l),q(f[e].parentElement.querySelector(".eb-accordion-title-wrapper")),"image"===y){var t,r=d[e].closest(".eb-accordion-container"),a=null==r?void 0:r.querySelector(".eb-accordion-image-container img"),n=null===(t=d[e])||void 0===t?void 0:t.querySelector(".eb-accordion-title-wrapper");if(a){var u=n.getAttribute("data-image-url")||"",p=n.getAttribute("data-image-alt")||"";a.classList.add("eb-image-fade-out"),setTimeout((function(){a.setAttribute("src",u),a.setAttribute("alt",p),a.classList.remove("eb-image-fade-out")}),500)}}if("horizontal"===y&&s<=c){var b,m=null===(b=d[e])||void 0===b?void 0:b.querySelector(".eb-accordion-title-wrapper"),g=m.querySelector(".eb-accordion-title-content-wrap"),h=f[e].querySelector(".eb-accordion-content");if(setTimeout((function(){f[e].style.display="block",f[e].style.opacity=1,f[e].style.visibility="visible",f[e].style.transform="translateY(0)"}),l),g&&h){var A=h.querySelector(".eb-accordion-title-content-wrap");A&&A.remove();var w=g.cloneNode(!0);h.prepend(w)}m.style.display="none",D(m,f[e])}}else f[e].setAttribute("data-collapsed","true"),"horizontal"!==y&&o(f[e],l),f[e].parentElement.classList.add(v)},k=0;k<d.length;k++)x(k);function T(){var e=this,t=this.nextElementSibling;"true"===t.getAttribute("data-collapsed")?(i(t,l),t.setAttribute("data-collapsed","false"),e.setAttribute("aria-expanded","true"),e.parentElement.classList.remove(v)):(o(t,l),t.setAttribute("data-collapsed","true"),e.setAttribute("aria-expanded","false"),e.parentElement.classList.add(v)),q(e)}function z(){var t=this,r=t.nextElementSibling;if(function(e){for(var t=e.querySelectorAll(".eb-accordion-icon"),r=0;r<t.length;r++)t[r].classList.contains(P)&&(t[r].classList.remove(S,P),t[r].classList.add(E,L))}(e),"horizontal"!==y){var i=function(e){for(var t=[],r=e.parentElement.previousElementSibling;r;)r.querySelector(".eb-accordion-title-wrapper")&&"false"===r.querySelector(".eb-accordion-content-wrapper").getAttribute("data-collapsed")&&t.push(r),r=r.previousElementSibling;return t.length?t[0]:null}(t);if(i){var a=i.querySelector(".eb-accordion-content-wrapper");a.offsetHeight>window.innerHeight?(o(a,0),a.setAttribute("data-collapsed","true"),function(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:10,r=window.pageYOffset,o=-r,i=null;requestAnimationFrame((function a(n){null===i&&(i=n);var l,s,c,d=n-i,u=(l=d,s=r,c=o,(l/=t/2)<1?c/2*l*l+s:-c/2*(--l*(l-2)-1)+s);window.scrollTo(0,u),d<t?requestAnimationFrame(a):"function"==typeof e&&e()}))}((function(){B(t,0),H(t,r,!0)}))):(B(t,l),H(t,r))}else B(t),H(t,r,!1,!0)}if("image"===y){var n=t.closest(".eb-accordion-container"),d=null==n?void 0:n.querySelector(".eb-accordion-image-container img");if(d){var u=t.getAttribute("data-image-url")||"",p=t.getAttribute("data-image-alt")||"";d.classList.add("eb-image-fade-out"),setTimeout((function(){d.setAttribute("src",u),d.setAttribute("alt",p),d.classList.remove("eb-image-fade-out")}),500)}}if("horizontal"===y&&c>s){t.classList.add("eb-transition-add"),setTimeout((function(){t.style.display="none",t.classList.remove("eb-transition-add")}),l),B(t,l),setTimeout((function(){r.style.display="block",r.style.opacity=1,r.style.visibility="visible",r.style.transform="translateY(0)"}),l);var b=t.querySelector(".eb-accordion-title-content-wrap"),m=r.querySelector(".eb-accordion-content");if(b&&m){var f=m.querySelector(".eb-accordion-title-content-wrap");f&&f.remove();var v=b.cloneNode(!0);m.prepend(v)}D(t,r)}}function H(e,t){var r=arguments.length>2&&void 0!==arguments[2]&&arguments[2],n=arguments.length>3&&void 0!==arguments[3]&&arguments[3];"true"===t.getAttribute("data-collapsed")?(r?i(t,l,(function(){a(e)})):n?i(t,l,(function(){t.offsetHeight>window.innerHeight&&a(e)})):i(t,l),t.setAttribute("data-collapsed","false"),e.setAttribute("aria-expanded","true"),e.parentElement.classList.remove("eb-accordion-hidden")):(o(t,l),t.setAttribute("data-collapsed","true"),e.setAttribute("aria-expanded","false"),q(e),e.parentElement.classList.add("eb-accordion-hidden")),q(e)}function B(e,t){var r=e.closest(".eb-accordion-container").querySelectorAll(".eb-accordion-content-wrapper");if("horizontal"===y&&s<=c){var i=e.closest(".eb-accordion-inner").querySelectorAll(".eb-accordion-title-wrapper"),a=e.closest(".eb-accordion-inner").querySelectorAll(".eb-accordion-content-wrapper");i.forEach((function(t){t!==e&&(t.style.display="flex")})),a.forEach((function(e){e.style.display="none",e.style.opacity=0,e.style.visibility="hidden",e.style.transform="translateY(-100%)"}))}r.forEach((function(r){r!==e.nextElementSibling&&"false"===r.getAttribute("data-collapsed")&&("horizontal"!==y&&o(r,t),r.setAttribute("data-collapsed","true"),r.previousElementSibling.setAttribute("aria-expanded","false"),r.parentElement.classList.add("eb-accordion-hidden"))}))}function D(e,t){var r="true"===t.getAttribute("data-collapsed"),o=e.closest(".eb-accordion-inner").querySelectorAll(".eb-accordion-wrapper"),i=e.closest(".eb-accordion-wrapper");r?(t.setAttribute("data-collapsed","false"),e.setAttribute("aria-expanded","true"),e.parentElement.classList.remove("eb-accordion-hidden")):(t.setAttribute("data-collapsed","true"),e.setAttribute("aria-expanded","false"),q(e),e.parentElement.classList.add("eb-accordion-hidden"));var a="true"===i.getAttribute("aria-expanded");o.forEach((function(e){e.setAttribute("aria-expanded","false")})),i.setAttribute("aria-expanded",a?"false":"true"),q(e)}},u=0;u<n.length;u++)d()}}));var o=function(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:500;e.style.transitionProperty="height, margin, padding",e.style.transitionDuration=t+"ms",e.style.boxSizing="border-box",e.style.height=e.offsetHeight+"px",e.offsetHeight,e.style.overflow="hidden",e.style.height=0,e.style.paddingTop=0,e.style.paddingBottom=0,e.style.marginTop=0,e.style.marginBottom=0,t<=0?(e.style.display="none",e.style.removeProperty("height"),e.style.removeProperty("padding-top"),e.style.removeProperty("padding-bottom"),e.style.removeProperty("margin-top"),e.style.removeProperty("margin-bottom"),e.style.removeProperty("overflow"),e.style.removeProperty("transition-duration"),e.style.removeProperty("transition-property")):window.setTimeout((function(){e.style.display="none",e.style.removeProperty("height"),e.style.removeProperty("padding-top"),e.style.removeProperty("padding-bottom"),e.style.removeProperty("margin-top"),e.style.removeProperty("margin-bottom"),e.style.removeProperty("overflow"),e.style.removeProperty("transition-duration"),e.style.removeProperty("transition-property")}),t)},i=function(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:500,r=arguments.length>2&&void 0!==arguments[2]?arguments[2]:null;e.style.removeProperty("display");var o=window.getComputedStyle(e).display;"none"===o&&(o="block"),setTimeout((function(){e.style.display=o}),t+1);var i=e.offsetHeight;e.style.overflow="hidden",e.style.height=0,e.style.paddingTop=0,e.style.paddingBottom=0,e.style.marginTop=0,e.style.marginBottom=0,e.offsetHeight,e.style.boxSizing="border-box",e.style.transitionProperty="height, margin, padding",e.style.transitionDuration=t+"ms",e.style.height=i+"px",e.style.removeProperty("padding-top"),e.style.removeProperty("padding-bottom"),e.style.removeProperty("margin-top"),e.style.removeProperty("margin-bottom"),window.setTimeout((function(){e.style.removeProperty("height"),e.style.removeProperty("overflow"),e.style.removeProperty("transition-duration"),e.style.removeProperty("transition-property"),"function"==typeof r&&r()}),t)};function a(e){var t=arguments.length>1&&void 0!==arguments[1]?arguments[1]:500,r=window.pageYOffset,o=e.getBoundingClientRect().top+window.pageYOffset-r-10,i=null;requestAnimationFrame((function e(a){null===i&&(i=a);var n,l,s,c=a-i,d=(n=c,l=r,s=o,(n/=t/2)<1?s/2*n*n+l:-s/2*(--n*(n-2)-1)+l);window.scrollTo(0,d),c<t&&requestAnimationFrame(e)}))}})();