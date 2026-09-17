<!DOCTYPE html>
<html class="no-js" lang="en">
<head>
	<!--
	    .__________      _____  .____     
	    |__\______ \    /  _  \ |    |    
	    |  ||    |  \  /  /_\  \|    |    
	    |  ||    `   \/    |    \    |___ 
	    |__/_______  /\____|__  /_______ \
	               \/         \/        \/
	 -->
	{if $userid eq 0}
	{* Global Site Tag (gtag.js) - Google Analytics *}
	{literal}
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-118988087-1"></script>
	<script>
	  window.dataLayer = window.dataLayer || [];
	  function gtag(){dataLayer.push(arguments)};
	  gtag('js', new Date());

	  gtag('config', 'UA-118988087-1', { 'anonymize_ip': true });
	</script>
	{/literal}
	{else}
	{* Matomo *}
	{literal}
	<script type="text/javascript">
	  var _paq = window._paq || [];
	  /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
	  _paq.push(['trackPageView']);
	  _paq.push(['enableLinkTracking']);
	  (function() {
	    var u="//analytics.idal.co/";
	    _paq.push(['setTrackerUrl', u+'matomo.php']);
	    _paq.push(['setSiteId', '{/literal}{if $debugout}3{else}1{/if}{literal}']);
	    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
	    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
	  })();
	</script>
	{/literal}
	{* End Matomo Code *}
	{/if}
	
	<meta charset="UTF-8" />
	<meta name="title" content="{if $page_title}{$page_title}{else}iDAL is a digital-driven talent empowerment platforms{/if}" />
	<meta name="author" content="iDAL" />
	<meta name="description" content="More than an agency. We are reimagining the traditional way the modelling world operates. Join as a client or a talent." />
	<meta name="keywords" content="iDAL model, iDAL model booking, iDAL models london, freelance models, freelance models jobs, freelance models uk, Model Booking, Models, London, London Models, Booking London Models, Fashion, Fashion Industry, Catwalk Models, Runway Models, E-Commerce Models, professional model, modelbooking, platform models" />
	<meta name="Copyright" content="Finda Global Ltd trading as iDAL" />

	<meta name="MobileOptimized" content="320">
	<meta name="HandheldFriendly" content="False">
	<meta name="apple-mobile-web-app-capable" content="no">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

	<meta property="og:title" content="{if $page_title}{$page_title}{else}iDAL{/if}" />
	<meta property="og:image" content="https://idal.co/images/IDAL_metacard.png" />
	<meta property="og:description" content="iDAL is an online platform connecting professional models and verified brands in a safe and transparent space. We are reimagining the old ways of booking models, shaping a better, more ethical and efficient solution for the industry.">

	<title>{if $page_title}{$page_title}{/if}</title>
	
	<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
	<link rel="manifest" href="/site.webmanifest">
	<meta name="theme-color" content="#ffffff">

	{* build css output *}
	{* Custom fonts for this template *}
	<link rel="stylesheet" href="{$smarty.const.CDN_ROOT}/css/vendor/fontawesome/css/all.css">
	
	{* new corporate font July 2019 *}
	<link rel="stylesheet" href="{$smarty.const.CDN_ROOT}/css/font-montserrat.css">
	{if $css_minified}
	<link rel="stylesheet" href="{$smarty.const.CDN_ROOT}/assets/css/{$css_minified}/bundle.css" />
	{else}
	{if $css_files}
	{foreach from=$css_files item=css}
	<link rel="stylesheet" href="{$smarty.const.CDN_ROOT}{$css}" />
	{/foreach}
	{/if}
	{/if}

	{* Attach header JS files *}
	<script src="{$smarty.const.CDN_ROOT}/js/vendor/jquery-3.4.1.min.js"></script>
	
	{if $js_minified_header}
	<script src="{$smarty.const.CDN_ROOT}/assets/js/{$js_minified_header}" type="text/javascript"></script>
	{else}
	{if $js_files_header}
	{foreach from=$js_files_header item=js}
	<script src="{$smarty.const.CDN_ROOT}{$js}" type="text/javascript"></script>
	{/foreach}
	{/if}
	{/if}

	{* Facebook Pixel Code *}
	{if $userid eq 0}
	{* literal}
	<script>
	!function(f,b,e,v,n,t,s) {
		if (f.fbq) return;
		n=f.fbq=function() { 
			n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)
		};
		if (!f._fbq) f._fbq=n;
		n.push = n;
		n.loaded = !0;
		n.version = '2.0';
		n.queue = [];
		t = b.createElement(e);
		t.async = !0;
		t.src = v;
		s = b.getElementsByTagName(e)[0];
		s.parentNode.insertBefore(t,s)
	} (window, document, 'script', 'https://connect.facebook.net/en_US/fbevents.js');
	fbq('init', '1863179183721118'); 
	fbq('track', 'PageView');
	</script>
	{/literal *}
	{/if}
	{* End Facebook Pixel Code *}
	
	{* google rich cards *}
	{if $userid eq 0}
	<script type="application/ld+json">
		{
			"@context": "http://schema.org",
			"@type": "Organization",
			"name" : "iDAL",
			"url": "https://idal.co",
			"sameAs" : [
				"https://www.facebook.com/idal.co/",
				"https://www.instagram.com/idal.co/",
				"https://www.linkedin.com/company/findaformodels/"
			] 
		}
	</script>
	<script type="application/ld+json">
		{
			"@context" : "http://schema.org",
			"@type" : "LocalBusiness",
			"name" : "iDAL",
			"image" : "https://idal.co/images/IDAL_metacard.png",
			"logo" : "https://idal.co/images/IDAL_metacard.png",
			"email" : "hello@idal.co",
			"description": "iDAL provides a new way for brands and models to connect, create and collaborate on dynamic projects together",
			"address" : {
				"@type" : "PostalAddress",
				"streetAddress" : "107-109 Great Portland St, London  W1W 6QG",
				"addressLocality" : "London",
				"addressRegion" : "London",
				"addressCountry" : "United Kingdom"
			},
			"url" : "https://idal.co",
			"legalName":"Finda Global LTD.",
			"sameAs" : [
				"https://www.facebook.com/findacommunity",
				"https://www.instagram.com/finda.co/",
				"https://www.linkedin.com/company/findaco/"
			]
		}
	</script>
	{/if}
	{*  END google rich cards *}
	
	{if $nocookie neq 1}
	<script src="/js/jquery/plugins/jquery.cookie.js" type="text/javascript"></script>
	<script src="/js/cookies/cookies.js" type="text/javascript"></script>
	<link rel="stylesheet" href="/css/cookies/cookies.css" />
	{/if}
</head>

<body class="{$body_class}" id="finda-website">
	<noscript>
		{if $userid == 0}
		{* facebook tracking *}
		<img height="1" width="1" src="https://www.facebook.com/tr?id=1863179183721118&ev=PageView&noscript=1"/>
		{* end facebook tracking *}
		{/if}
		<div id="noscript">For the best experience, please enable JavaScript</div>
	</noscript>
	
	{* cookie warning *}
	<div class="cookiewarning" style="display: none">
		<p>Cookies are currently disabled in your browser. To be able to log in and use the iDAL website needs cookies to be enabled. Please re-enable cookies and reload this page.</p>
	</div>
	
	{if $function neq 'homepage' && $function neq 'la' && $function neq 'app' && $function neq 'm' && $function neq 'generate' && $function neq 'invite'}
	{include file="shared/header.tpl"}
	{include file="$controller_template"}
	{include file="shared/footer.tpl"}
	{else}
	{include file="$controller_template"}
	{if $function eq 'invite'}{include file="shared/footer.tpl"}{/if}
	{/if}


	{* Attach footer JS files *}
	{if $js_minified_footer}
		<script src="{$smarty.const.CDN_ROOT}/js/{$js_minified_footer}" type="text/javascript"></script>
	{else}
	{foreach from=$js_files_footer item=js}
		<script src="{$smarty.const.CDN_ROOT}{$js}" type="text/javascript"></script>
	{/foreach}
	{/if}
	
	{if $notificationpopup}
	<input type="hidden" name="notificationpopup" data-message="{$notificationpopup}" />
	{/if}

	{if $nocookie neq 1}{include file="cookies/cookies.tpl"}{/if}
	{if $debugout}
	{include file="shared/debug.tpl"}
	{/if}
	</body>
</html>
