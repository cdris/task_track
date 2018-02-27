// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import $ from "jquery";
import "bootstrap-datetime-picker";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

const timeForm = `
<tr id="time-form-row">
<form id="time-form">
<td>
<div>
<input type="text" class="form-control" id="start-time" placeholder="Enter start time">
</div>
</td>
<td>
<div>
<input type="text" class="form-control" id="end-time" placeholder="Enter end time">
</div>
</td>
<td></td>
<td><button id="time-submit" class="btn btn-primary">Submit</button></td>
</form>
</tr>`

function manualAdd() {
  $("#time-table tbody").append(timeForm);
  $("#start-time").datetimepicker({
    format: "yyyy-mm-dd hh:ii"
  });
  $("#end-time").datetimepicker({
    format: "yyyy-mm-dd hh:ii"
  });
  $("#time-submit").off().on("click", submitNewTime);
}

function submitNewTime() {
  let text = JSON.stringify({
    time_block: {
      start_time: $("#start-time").val(),
      end_time: $("#end-time").val(),
      task_id: task_id
    }
  });

  $.ajax("/api/time_blocks", {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {
      location.reload();
    }
  });
}

const timeTracker = `
<div id="time-tracker">
  <div class="modal d-inline">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h3 class="modal-title">Time Tracker</h3>
        </div>
        <div id="time-tracker-body" class="modal-body text-center">
          <button id="time-tracker-button" class="btn btn-success btn-lg">Start</button>
        </div>
        <div class="modal-footer">
          <button id="time-tracker-close" class="btn btn-secondary">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</div>`

function trackerAdd() {
  $("body").prepend(timeTracker);
  $("#time-tracker-close").off().on("click", () => {
    $("#time-tracker").remove();
  });
  $("#time-tracker-button").off().on("click", startTracker);
}

function startTracker() {
  let startTime = "!";
  $("#time-tracker-body").prepend(`<h4>Start Time: <span id="time-tracker-start">${startTime}</span></h4>`);
  $("#time-tracker-button").removeClass("btn-success");
  $("#time-tracker-button").addClass("btn-danger");
  $("#time-tracker-button").text("Stop");
  $("#time-tracker-button").off().on("click", stopTracker);
}

function stopTracker() {
  $("#time-tracker").remove();
}

function initTime() {

  $("#manual-add").click(manualAdd);

  $("#tracker-add").click(trackerAdd);

}

$(initTime)
