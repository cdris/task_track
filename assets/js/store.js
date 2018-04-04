import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';

/*
 * state layout:
 * {
 *   tasks: [... Tasks ...],
 *   task: {
 *     id: "",
 *     title: "",
 *     description: "",
 *     assignee_email: "",
 *     time_worked: 0,
 *     completed: false
 *   },
 *   users: [... Users ...],
 *   user: {
 *     user_id: null,
 *     username: "",
 *     token: null
 *   },
 *   login: {
 *     email: "",
 *     password: ""
 *   },
 *   register: {
 *     name: "",
 *     email: "",
 *     password: ""
 *   },
 *   filter: {
 *     completed: false,
 *     reported: false
 *   },
 *   success: "",
 *   error: ""
 * }
 */

function tasks(state = [], action) {
  switch(action.type) {
    case 'TASKS_LIST':
      return [...action.tasks];
    default:
      return state;
  }
}

let emptyTask = {
  id: "",
  title: "",
  description: "",
  assignee: "",
  time_worked: 0,
  completed: false
}

function task(state = emptyTask, action) {
  switch (action.type) {
    case 'UPDATE_TASK':
      return Object.assign({}, state, action.data);
    case 'RESET_FORMS':
      return emptyTask;
    case 'TASK':
      return action.task;
    default:
      return state;
  }
}

function users(state = [], action) {
  switch (action.type) {
    case 'USERS_LIST':
      return [...action.users];
    default:
      return state;
  }
}

function user(state = null, action) {
  switch (action.type) {
    case 'SET_USER':
      return action.user;
    case 'DELETE_USER':
      console.log('deleting user');
      return null;
    default:
      return state;
  }
}

let emptyLogin = {
  email: "",
  password: ""
};

function login(state = emptyLogin, action) {
  switch (action.type) {
    case 'UPDATE_LOGIN':
      return Object.assign({}, state, action.data);
    case 'RESET_FORMS':
      return emptyLogin
    default:
      return state;
  }
}

let emptyRegister = {
  name: "",
  email: "",
  password: ""
};

function register(state = emptyRegister, action) {
  switch (action.type) {
    case 'UPDATE_REGISTER':
      return Object.assign({}, state, action.data);
    case 'RESET_FORMS':
      return emptyRegister
    default:
      return state;
  }
}

let emptyFilter = {
  completed: false,
  reported: false
}

function filter(state = emptyFilter, action) {
  switch (action.type) {
    case 'UPDATE_FILTER':
      return Object.assign({}, state, action.data);
    default:
      return state;
  }
}

function success(state = "", action) {
  switch (action.type) {
    case 'SUCCESS_MSG':
      return action.success;
    case 'ERROR_MSG':
      return "";
    case 'RESET_SUCCESS':
      return "";
    default:
      return state;
  }
}

function error(state = "", action) {
  switch (action.type) {
    case 'ERROR_MSG':
      return action.error;
    case 'SUCCESS_MSG':
      return "";
    case 'RESET_ERROR':
      return "";
    default:
      return state;
  }
}

function rootReducer(state0, action) {
  //console.log("reducer", action);
  let reducer = combineReducers({
    tasks, task, users, user, login, register, filter, success, error
  });
  let state1 = reducer(state0, action);
  //console.log("state1", state1);
  console.log("STATE", state1);
  return deepFreeze(state1);
}

let store = createStore(rootReducer);
export default store;
