import store from './store';

class APIServer {

  requestTasks() {
    $.ajax("/api/v1/tasks", {
      method: "get",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      success: (resp) => {
        store.dispatch({
          type: 'TASKS_LIST',
          tasks: resp.data
        });
      }
    });
  }

  submitLogin(data) {
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
          success: `Welcome back, ${resp.data.username}`
        });
        store.dispatch({type: 'RESET_ERROR'});
      },
      error: (resp) => {
        store.dispatch({
          type: 'ERROR_MSG',
          error: resp.responseJSON.message
        });
        store.dispatch({type: 'RESET_SUCCESS'});
      }
    });
  }

}

export default new APIServer();
