import store from './store';

// based on answer found here: https://stackoverflow.com/questions/38460949/what-is-the-best-way-to-access-redux-store-outside-a-react-component
store.subscribe(listener);

function getToken(state) {
  return state.user ? state.user.token : null;
}

function listener() {
  let token = getToken(store.getState());
  let headers = token ? {Authorization: `Bearer ${token}`} : {};
  $.ajaxSetup({headers});
}

function revokeToken(resp) {
  if (resp.status == 401) {
    store.dispatch({ type: 'DELETE_USER' });
    store.dispatch({
      type: 'ERROR_MSG',
      error: resp.responseJSON ?
             resp.responseJSON.message :
             "Session ended. Please log in again."
    });
  }
}

class APIServer {

  requestTasks(filter) {
    $.ajax("/api/v1/tasks", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(filter),
      success: (resp) => {
        store.dispatch({
          type: 'TASKS_LIST',
          tasks: resp.data
        });
      },
      error: revokeToken
    });
  }

  requestTask(task_id) {
    $.ajax(`/api/v1/tasks/${task_id}`, {
      method: "get",
      success: (resp) => {
        store.dispatch({
          type: 'TASK',
          task: resp.data
        });
      },
      error: (resp) => {
        revokeToken(resp);
        if (resp.status != 401) {
          store.dispatch({
            type: 'ERROR_MSG',
            error: resp.responseJSON.message
          });
        }
      }
    });
  }

  requestUsers() {
    $.ajax("/api/v1/users", {
      method: "get",
      success: (resp) => {
        store.dispatch({
          type: 'USERS_LIST',
          users: resp.data
        });
      },
      error: revokeToken
    });
  }

  submitLogin(data, onSuccess) {
    $.ajax("/api/v1/session", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify(data),
      success: (resp) => {
        store.dispatch({
          type: 'SET_USER',
          user: resp.data
        });
        store.dispatch({
          type: 'SUCCESS_MSG',
          success: `Welcome back, ${resp.data.username}!`
        });
        onSuccess();
      },
      error: revokeToken
    });
  }

  submitRegister(user, onSuccess, onError) {
    $.ajax("/api/v1/users/new", {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({user}),
      success: (resp) => {
        store.dispatch({
          type: 'SUCCESS_MSG',
          success: 'User created successfully'
        });
        onSuccess();
      },
      error: (resp) => {
        console.log("register error", resp);
        revokeToken(resp);
        if (resp.status != 401) {
          onError(resp.responseJSON.fields);
        }
      }
    });
  }

  submitTask(type, task, onSuccess, onError) {
    $.ajax(`/api/v1/tasks/${type}`, {
      method: "post",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: JSON.stringify({task}),
      success: (resp) => {
        store.dispatch({
          type: 'SUCCESS_MSG',
          success: 'Task created successfully'
        });
        onSuccess();
      },
      error: (resp) => {
        console.log("task error", resp);
        revokeToken(resp);
        if (resp.status != 401) {
          onError(resp.responseJSON.fields);
        }
      }
    });
  }
}

export default new APIServer();
