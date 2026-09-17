<div class="invite-card">
	<div class="card-anim">
		{* card itself goes here *}
		<div class="card">
			<div class="heading"><img src="/images/card-heading.png" /></div>
			<div class="card-content">
				<h2 class="inviteheading"><span class="text-purple">Soft Launch Party</span></h2>
				<div class="invitetext">
					<p><span class="text-purple">Y</span>ou are cordially invited to celebrate the soft launch of <span class="text-purple">finda - a new booking platform and community for professional models.</span><br />
					{if $person.guest_type eq 'model'}
					Expect a discussion about confidence with <span class="text-darkyellow">inspirational speakers</span>, followed by <span class="text-blue">a summer editorial photoshoot</span>, DJ music, champagne reception and canapés.<br />
					{else}
					Expect to witness <span class="text-darkyellow">a summer editorial photoshoot</span> with our founding models, enjoy DJ music, champagne reception and canapés.<br />
					{/if}
					<span class="text-findagreen"><strong>rsvp is required!</strong></span></p>
					<p><br /></p>
					<p>Wednesday<br />July 18 {if $person.guest_type eq 'model'}6{else}7{/if}pm - 9:30pm<br />eccleston yards<br />belgravia</p> 
				</div>
			</div>
		</div>
	</div>

	<h1>IDAL Soft Launch Party</h1>
	<div class="invitee">To: {$person.name}</div>
	<div class="rsvp">
		{if $person.coming eq 'maybe'}
		<a class="rsvp-button" data-rsvp="yes">will attend</a>
		<a class="rsvp-button" data-rsvp="no">will not attend</a>
		{else if $person.coming eq 'yes'}
		<p>Great! We'll see you there!<br />If you want to change your mind, please email <a href="mailto:viktoriya@idal.co">viktoriya@idal.co</a>.</p>
		{else}
		<p>We're sad you cannot come and join us for our launch party.<br />If you want to change your mind, please email <a href="mailto:viktoriya@idal.co">viktoriya@idal.co</a>.</p>
		{/if}
		<input type="hidden" name="hash" value="{$person.hash}" />
	</div>
	
	<div class="data-section">
		<div class="half">
			<h2>date</h2>
			<p class="date">Wednesday, July 18th</p>
			<p>{if $person.guest_type eq 'model'}6{else}7{/if}:00PM<br />&nbsp;</p>
			<div class="popup">
				<a class="add-to-calendar">add to calendar</a>
				<div class="calendar-links">
					<ul>
						<li><a href="http://www.google.com/calendar/event?action=TEMPLATE&text=Finda+Soft+Launch+Party&dates=20180718T1{if $person.guest_type eq 'model'}8{else}9{/if}0000%2F20180718T213000&details=https%3A%2F%2Fwww.idal.co%2Finvite%2F{$person.hash}&sprop=website%3Awww.idal.co&location=Eccleston+Yards%2C+21+Eccleston+Pl%2C+London%2C+England" data-cal="google">Google Calendar</a></li>
						<li><a href="/invite/findasoftlaunch{if $person.guest_type eq 'model'}model{/if}.vcs" data-cal="outlook">Outlook</a></li>
						<li><a href="/invite/findasoftlaunch{if $person.guest_type eq 'model'}model{/if}.ics" data-cal="apple">Apple iCal</a></li>
						<li><a href="http://calendar.yahoo.com/?v=60&title=Finda+Soft+Launch+Party&in_loc=Eccleston+Yards%2C+21+Eccleston+Pl%2C+London%2C+England&url=https%3A%2F%2Fwww.idal.co%2Finvite%2F{$person.hash}&st=20180718T1{if $person.guest_type eq 'model'}8{else}9{/if}0000" data-cal="yahoo">Yahoo Calendar</a></li>
					</ul>
				</div>
			</div>
		</div>
		
		<div class="half">
			<h2>address</h2>
			<p class="date">Eccleston Yards</p>
			<p>23 Eccleston Place<br />London, England, SW1W 9NF</p>
			<a href="https://www.google.com/maps/place/Eccleston+Yards/@51.493547,-0.1505517,17z/data=!3m1!4b1!4m5!3m4!1s0x0:0xf659f234686acec2!8m2!3d51.493547!4d-0.148363" target="_blank" class="directions">get directions</a>
		</div>
	</div>
	<div class="map">
		<iframe width="100%" height="400px" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/place?key=REDACTED_GOOGLE_MAPS_API_KEY&q=Eccleston+Yards"></iframe>
	</div>
</div>