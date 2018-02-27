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
<tr class="time-form">
  <td>
    <input type="text" class="form-control start-time-field" placeholder="YYYY-MM-DD HH:MM">
  </td>
  <td>
    <input type="text" class="form-control end-time-field" placeholder="YYYY-MM-DD HH:MM">
  </td>
  <td></td>
  <td><button class="btn btn-primary time-submit">Submit</button></td>
</tr>`

function getTimeForm() {
  let form = $(timeForm)
  form.find(".start-time-field").datetimepicker({
    format: "yyyy-mm-dd hh:ii"
  });
  form.find(".end-time-field").datetimepicker({
    format: "yyyy-mm-dd hh:ii"
  });
  return form;
}

function manualAdd() {
  let form = $(getTimeForm()).appendTo("#time-table tbody");
  form.find(".time-submit").off().on("click", submitNewTime);
}

function submitNewTime(event) {
  let form = $(event.target.closest(".time-form"));
  createTime({
    time_block: {
      start_time: form.find(".start-time-field").val(),
      end_time: form.find(".end-time-field").val(),
      task_id: task_id
    }
  });
}

function editTime(event) {
  let row = $(event.target.closest("tr"));
  let startTime = row.find(".start-time").text();
  let endTime = row.find(".end-time").text();
  let id = row.attr("id");
  let form = $(timeForm).insertBefore(row);
  row.remove();
  form.find(".start-time-field").val(startTime);
  form.find(".end-time-field").val(endTime);
  form.find(".time-submit").off().on("click", (event) => {
    submitEditTime(event, id);
  });
}

function submitEditTime(event, id) {
  let form = $(event.target.closest(".time-form"));
  updateTime(id, {
    time_block: {
      start_time: form.find(".start-time-field").val(),
      end_time: form.find(".end-time-field").val(),
      task_id: task_id
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
  let startTime = getFormattedNow();
  $("#time-tracker-body").prepend(`<h4>Start Time: <span id="time-tracker-start">${startTime}</span></h4>`);
  $("#time-tracker-button").removeClass("btn-success");
  $("#time-tracker-button").addClass("btn-danger");
  $("#time-tracker-button").text("Stop");
  $("#time-tracker-button").off().on("click", () => { stopTracker(startTime); });
}

function getFormattedNow() {
  var dt = new Date(Date.now());
  dt = dt.getUTCFullYear() + "-" +
       ("0" + (dt.getUTCMonth() + 1)).slice(-2) + "-" +
       ("0" + dt.getUTCDate()).slice(-2) + " " +
       ("0" + dt.getUTCHours()).slice(-2) + ":" +
       ("0" + dt.getUTCMinutes()).slice(-2);
  return dt;
}

function stopTracker(startTime) {
  let endTime = getFormattedNow();
  createTime({
    time_block: {
      start_time: startTime,
      end_time: endTime,
      task_id: task_id
    }
  });
  //$("#time-tracker").remove();
}

function createTime(body) {
  let text = JSON.stringify(body);

  $.ajax("/api/v1/time_blocks", {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {
      location.reload();
    }
  });
}

function updateTime(id, body) {
  let text = JSON.stringify(body);

  $.ajax("/api/v1/time_blocks/" + id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {
      location.reload();
    }
  });
}

function deleteTime(id) {
  $.ajax("/api/v1/time_blocks/" + id, {
    method: "delete",
    success: (resp) => {
      location.reload();
    }
  });
}

function confirmDeleteTime(event) {
  if (confirm("Are you sure?") == true) {
    let id = $(event.target.closest("tr")).attr("id");
    deleteTime(id);
  }
}

function initTime() {
  $("#manual-add").click(manualAdd);
  $("#tracker-add").click(trackerAdd);
  $(".edit-time").click(editTime);
  $(".delete-time").click(confirmDeleteTime);
}

$(initTime)
