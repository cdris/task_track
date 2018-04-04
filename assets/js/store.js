import { createStore, combineReducers } from 'redux';
import deepFreeze from 'deep-freeze';

/*
 * state layout:
 * {
 *   tasks: [... Tasks ...],
 *   user: {
 *     user_id: null,
 *     username: "",
 *     token: null
 *   },
 *   login: {
 *     email: "",
 *     password: ""
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

function user(state = null, action) {
  switch (action.type) {
    case 'SET_USER':
      return action.user;
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
    case 'UPDATE_LOGIN_FORM':
      return Object.assign({}, state, action.data);
    default:
      return state;
  }
}

function success(state = "", action) {
  switch (action.type) {
    case 'SUCCESS_MSG':
      return action.success;
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
    case 'RESET_ERROR':
      return "";
    default:
      return state;
  }
}

function rootReducer(state0, action) {
  //console.log("reducer", action);
  let reducer = combineReducers({tasks, user, login, success, error});
  let state1 = reducer(state0, action);
  //console.log("state1", state1);
  console.log("STATE", state1);
  return deepFreeze(state1);
}

let store = createStore(rootReducer);
export default store;
