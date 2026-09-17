/**
 * Croisssant Web Framework
 *
 * @author Tom Gordon
 * @copyright 2009-present Tom Gordon
 *
 */
$(function() {

	$('#dropdownMenu-calendarType').on('click', function() {
		$('.dropdown-menu').toggle();
	})
});

var ThisCalendar;

function CalendarInfo() {
	this.id = null;
	this.name = null;
	this.checked = true;
	this.color = null;
	this.bgColor = null;
	this.borderColor = null;
}

// add 1 calendar
var calendar = new CalendarInfo();
calendar.id = String('1');
calendar.name = 'Calendar';
calendar.color = '#ffffff';
calendar.bgColor = '#65b8bc';
calendar.dragBgColor = '#65b8bc';
calendar.borderColor = '#65b8bc';

ThisCalendar = calendar;

(function(window, Calendar) {
	var cal, resizeThrottled;
	var useCreationPopup = true;
	var useDetailPopup = true;
	var datePicker;

	cal = new Calendar(
		'#calendar', {
			defaultView : 'month',
			useCreationPopup : useCreationPopup,
			useDetailPopup : useDetailPopup,
			// calendars: ThisCalendar,
			template : {
				milestone : function(model) {
					return '<span class="calendar-font-icon ic-milestone-b"></span> <span style="background-color: '
							+ model.bgColor
							+ '">'
							+ model.title
							+ '</span>';
				},
				allday : function(schedule) {
					return getTimeTemplate(schedule, true);
				},
				time : function(schedule) {
					return getTimeTemplate(schedule, false);
				}
			},
			theme : {
				'common.creationGuide.backgroundColor' : 'rgba(101, 184, 188, 0.05)',
				'common.creationGuide.border' : '1px solid #65b8bc',
				'common.holiday.color' : '#b8142b',
				'common.border' : '1px solid #e6e6e6',
				'common.today.color' : '#fff',
				'month.dayname.fontSize': '14px',
			}
		});

	// event handlers
	cal.on({
		'clickSchedule' : function(e) {
			e.calendar = ThisCalendar;
		},
		'clickDayname' : function(date) {
		},
		'beforeCreateSchedule' : function(e) {
			e.calendarId = ThisCalendar.id;
			saveNewSchedule(e);
		},
		'beforeUpdateSchedule' : function(e) {
			e.calendar = ThisCalendar;
			e.schedule.start = e.start;
			e.schedule.end = e.end;
			e.schedule.calendarId = ThisCalendar.id;
			cal.updateSchedule(e.schedule.id, e.schedule.calendarId, e.schedule);
			updateModelSchedule(e.schedule);
		},
		'beforeDeleteSchedule' : function(e) {
			cal.deleteSchedule(e.schedule.id, e.schedule.calendarId);
			deleteModelSchedule(e.schedule.id);
		}
	});

	/**
	 * Get time template for time and all-day
	 * 
	 * @param {Schedule}
	 *            schedule - schedule
	 * @param {boolean}
	 *            isAllDay - isAllDay or hasMultiDates
	 * @returns {string}
	 */
	function getTimeTemplate(schedule, isAllDay) {
		var html = [];
		var start = moment(schedule.start.toUTCString());
		if (!isAllDay) {
			html.push('<strong>' + start.format('HH:mm') + '</strong> ');
		}
		if (schedule.isPrivate) {
			html.push('<span class="calendar-font-icon ic-lock-b"></span>');
			html.push(' Private');
		} else {
			if (schedule.isReadOnly) {
				html.push('<span class="calendar-font-icon ic-readonly-b"></span>');
			} else if (schedule.location) {
				html.push('<span class="calendar-font-icon ic-location-b"></span>');
			}
			html.push(' ' + schedule.title);
		}

		return html.join('');
	}

	/**
	 * A listener for click the menu
	 * 
	 * @param {Event}
	 *            e - click event
	 */
	function onClickMenu(e) {
		var target = $(e.target).closest('a[role="menuitem"]')[0];
		var action = getDataAction(target);
		var options = cal.getOptions();
		var viewName = '';

		switch (action) {
		case 'toggle-daily':
			viewName = 'day';
			break;
		case 'toggle-weekly':
			viewName = 'week';
			break;
		case 'toggle-monthly':
			options.month.visibleWeeksCount = 0;
			viewName = 'month';
			break;
		case 'toggle-weeks2':
			options.month.visibleWeeksCount = 2;
			viewName = 'month';
			break;
		case 'toggle-weeks3':
			options.month.visibleWeeksCount = 3;
			viewName = 'month';
			break;
		case 'toggle-narrow-weekend':
			options.month.narrowWeekend = !options.month.narrowWeekend;
			options.week.narrowWeekend = !options.week.narrowWeekend;
			viewName = cal.getViewName();

			target.querySelector('input').checked = options.month.narrowWeekend;
			break;
		case 'toggle-start-day-1':
			options.month.startDayOfWeek = options.month.startDayOfWeek ? 0 : 1;
			options.week.startDayOfWeek = options.week.startDayOfWeek ? 0 : 1;
			viewName = cal.getViewName();

			target.querySelector('input').checked = options.month.startDayOfWeek;
			break;
		case 'toggle-workweek':
			options.month.workweek = !options.month.workweek;
			options.week.workweek = !options.week.workweek;
			viewName = cal.getViewName();

			target.querySelector('input').checked = !options.month.workweek;
			break;
		default:
			break;
		}

		cal.setOptions(options, true);
		cal.changeView(viewName, true);

		setDropdownCalendarType();
		setRenderRangeText();
		setSchedules();
		$('.dropdown-menu').toggle();
	}

	function onClickNavi(e) {
		var action = getDataAction(e.target);

		switch (action) {
		case 'move-prev':
			cal.prev();
			break;
		case 'move-next':
			cal.next();
			break;
		case 'move-today':
			cal.today();
			break;
		default:
			return;
		}

		setRenderRangeText();
		setSchedules();
	}

	function onNewSchedule() {
		var title = $('#new-schedule-title').val();
		var location = $('#new-schedule-location').val();
		var notes = $('#new-schedule-notes').val();
		var isAllDay = document.getElementById('new-schedule-allday').checked;
		var start = datePicker.getStartDate().getTime();
		var end = datePicker.getEndDate().getTime();
		calendar = selectedCalendar ? selectedCalendar : CalendarList[0];

		if (!title) {
			return;
		}

		cal.createSchedules([ {
			id : String(chance.guid()),
			calendarId : calendar.id,
			title : title,
			isAllDay : isAllDay,
			isReadOnly: false,
			start : start,
			end : end,
			category : isAllDay ? 'allday' : 'time',
			dueDateClass : '',
			color : ThisCalendar.color,
			bgColor : ThisCalendar.bgColor,
			dragBgColor : ThisCalendar.bgColor,
			borderColor : ThisCalendar.borderColor,
			raw : {
				location : location
			},
			notes : notes,
			state : 'Busy'
		} ]);
	}

	function saveNewSchedule(scheduleData) {
		var schedule = {
			id: String(chance.guid()),
			title : scheduleData.title,
			isAllDay : scheduleData.isAllDay,
			isReadOnly: false,
			start : scheduleData.start,
			end : scheduleData.end,
			category : scheduleData.isAllDay ? 'allday' : 'time',
			dueDateClass : '',
			color : ThisCalendar.color,
			bgColor : ThisCalendar.bgColor,
			dragBgColor : ThisCalendar.bgColor,
			borderColor : ThisCalendar.borderColor,
			location: scheduleData.location,
			notes: scheduleData.notes,
			raw : {
				'class' : scheduleData.raw['class'],
				location : scheduleData.raw.location
			},
			state : scheduleData.state
		};
		if (ThisCalendar) {
			schedule.calendarId = ThisCalendar.id;
			schedule.color = ThisCalendar.color;
			schedule.bgColor = ThisCalendar.bgColor;
			schedule.borderColor = ThisCalendar.borderColor;
		}

		cal.createSchedules([ schedule ]);

		var saveSchedule = {
				scheduleId: schedule.id,
				title : schedule.title,
				isAllDay : schedule.isAllDay,
				isReadOnly : schedule.isReadOnly,
				starttime : schedule.start.getTime() / 1000,
				endtime : schedule.end.getTime() / 1000,
				category : scheduleData.isAllDay ? 'allday' : 'time',
				dueDateClass : '',
				location: schedule.location,
				notes: schedule.notes,
				state : schedule.state
		}
		
		$.ajax({
			type: 'POST',
			url: '/user/calendar/addSchedule',
			data: {
				'schedule': saveSchedule
			},
			success: function(resultData) {
				refreshScheduleVisibility();
			},
			error: function(resultData) {
				// do something here
			}
		})
	}
	
	function deleteModelSchedule(scheduleid) {
		$.ajax({
			type: 'POST',
			url: '/user/calendar/removeSchedule',
			data: {
				'scheduleid': scheduleid
			},
			success: function(resultData) {
				refreshScheduleVisibility();
			},
			error: function(resultData) {
				// do something here
			}
		})
	}
	
	function updateModelSchedule(scheduleData) {
		var saveSchedule = {
				scheduleId: scheduleData.id,
				title : scheduleData.title,
				isAllDay : scheduleData.isAllDay,
				isReadOnly : scheduleData.isReadOnly,
				starttime : scheduleData.start.getTime() / 1000,
				endtime : scheduleData.end.getTime() / 1000,
				category : scheduleData.isAllDay ? 'allday' : 'time',
				location: scheduleData.location,
				notes: scheduleData.notes,
				state : scheduleData.state
		}
		$.ajax({
			type: 'POST',
			url: '/user/calendar/updateSchedule',
			data: {
				'schedule': saveSchedule
			},
			success: function(resultData) {
				refreshScheduleVisibility();
			},
			error: function(resultData) {
				// do something here
			}
		})
	}

	function refreshScheduleVisibility() {
		cal.render(true);
	}

	function setDropdownCalendarType() {
		var calendarTypeName = document.getElementById('calendarTypeName');
		var calendarTypeIcon = document.getElementById('calendarTypeIcon');
		var options = cal.getOptions();
		var type = cal.getViewName();
		var iconClassName;

		if (type === 'day') {
			type = 'Daily';
			iconClassName = 'calendar-icon ic_view_day';
		} else if (type === 'week') {
			type = 'Weekly';
			iconClassName = 'calendar-icon ic_view_week';
		} else if (options.month.visibleWeeksCount === 2) {
			type = '2 weeks';
			iconClassName = 'calendar-icon ic_view_week';
		} else if (options.month.visibleWeeksCount === 3) {
			type = '3 weeks';
			iconClassName = 'calendar-icon ic_view_week';
		} else {
			type = 'Monthly';
			iconClassName = 'calendar-icon ic_view_month';
		}

		calendarTypeName.innerHTML = type;
		calendarTypeIcon.className = iconClassName;
	}

	function setRenderRangeText() {
		var renderRange = document.getElementById('renderRange');
		var options = cal.getOptions();
		var viewName = cal.getViewName();
		var html = [];
		if (viewName === 'day') {
			html.push(moment(cal.getDate().getTime()).format('Do MMMM, YYYY'));
		} else if (viewName === 'month' && (!options.month.visibleWeeksCount || options.month.visibleWeeksCount > 4)) {
			html.push(moment(cal.getDate().getTime()).format('MMMM YYYY'));
		} else {
			html.push(moment(cal.getDateRangeStart().getTime()).format('Do MMMM'));
			html.push(' ~ ');
			html.push(moment(cal.getDateRangeEnd().getTime()).format(' Do MMMM, YYYY'));
		}
		renderRange.innerHTML = html.join('');
	}

	function setSchedules() {
		cal.clear;
		refreshScheduleVisibility();
	}
	
	function setLoadedSchedules() {
		cal.clear;
		$.each(loadedSchedules, function(key, scheduleData) {
			var newschedule = {
				id: scheduleData.scheduleId,
				title : scheduleData.title,
				isAllDay : scheduleData.isAllDay,
				isReadOnly : scheduleData.isReadOnly,
				start : scheduleData.start,
				end : scheduleData.end,
				category : scheduleData.isAllDay ? 'allday' : 'time',
				dueDateClass : '',
				color : ThisCalendar.color,
				bgColor : ThisCalendar.bgColor,
				dragBgColor : ThisCalendar.bgColor,
				borderColor : ThisCalendar.borderColor,
				location: scheduleData.location,
				notes: scheduleData.notes,
				raw : {
					'class' : '',
					location : scheduleData.location
				},
				state : scheduleData.state
				
			};
			if (ThisCalendar) {
				newschedule.calendarId = ThisCalendar.id;
				newschedule.color = ThisCalendar.color;
				newschedule.bgColor = ThisCalendar.bgColor;
				newschedule.borderColor = ThisCalendar.borderColor;
			}
			if (scheduleData.jobid != 0) {
				newschedule.jobname = scheduleData.jobdetails.name;
				newschedule.bgColor = '#59c5cf';
				newschedule.borderColor = '#59c5cf';
				newschedule.raw.jobid = scheduleData.jobid;
				newschedule.raw.jobname = scheduleData.jobdetails.name;
				newschedule.raw.callsheet = scheduleData.jobdetails.callsheet;
				
				// sometimes the data gets lost
				// force isReadOnly if the jobid is non-zero
				newschedule.isReadOnly = true;
				
			}
			
			cal.createSchedules([newschedule]);
		})
		refreshScheduleVisibility();
	}
	
	function setEventListener() {
		$('#menu-navi').on('click', onClickNavi);
		$('.dropdown-menu a[role="menuitem"]').on('click', onClickMenu);
		
		$('button.tui-full-calendar-popup-save').on('click', onNewSchedule);

		window.addEventListener('resize', resizeThrottled);
	}

	function getDataAction(target) {
		return target.dataset ? target.dataset.action : target
				.getAttribute('data-action');
	}

	resizeThrottled = tui.util.throttle(function() {
		cal.render();
	}, 50);

	window.cal = cal;

	setDropdownCalendarType();
	setRenderRangeText();
	setLoadedSchedules();
	setEventListener();
})(window, tui.Calendar);
