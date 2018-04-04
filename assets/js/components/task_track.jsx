import React from 'react';
import ReactDOM from 'react-dom';
import { Provider, connect } from 'react-redux';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import { withRouter } from 'react-router';
import { Alert } from 'reactstrap';
import AuthRoute from './auth_route';
import Nav from './nav';
import Login from './login';
import Register from './register';
import TaskList from './task_list';
import NewTask from './new_task';
import EditTask from './edit_task';
import api from '../api_server';

let MessageAlerts = connect((state) => state)((props) => {
  let success = props.success ?
                <Alert color="success">{props.success}</Alert> :
                '';
  let error = props.error ?
              <Alert color="danger">{props.error}</Alert> :
              '';
  return (
    <div>
      {success}
      {error}
    </div>
  );
});

class TaskTrackCore extends React.Component {

  componentWillUpdate(nextProps, nextState) {
    if (this.props.location != nextProps.location) {
      if (nextProps.location.pathname != '/tasks') {
        this.props.dispatch({type: 'RESET_SUCCESS'});
      }
      this.props.dispatch({type: 'RESET_ERROR'});
      this.props.dispatch({type: 'RESET_FORMS'});
    }
  }

  render() {
    return (
      <div>
        <Nav />
        <div className="mt-3 container">
          <MessageAlerts />
          <Switch>
            <AuthRoute path="/tasks/new" exact={true} render={() => <NewTask />} />
            <AuthRoute path="/tasks/edit/:task_id" exact={true}
                       render={({match}) => <EditTask task_id={match.params.task_id} />} />
            <AuthRoute path="/tasks" exact={true} render={() => <TaskList />} />
            <Route path="/register" exact={true} render={() => <Register />} />
            <Route path="/" exact={true} render={() => <Login />} />
          </Switch>
        </div>
      </div>
    );
  }
}

let ConnectedCore = withRouter(connect((state) => state)(TaskTrackCore));

let TaskTrack = connect((state) => state)((props) => {
  return (
    <Router>
      <ConnectedCore />
    </Router>
  );
});

export default function taskTrackInit(store) {
  ReactDOM.render(
    <Provider store={store}>
      <TaskTrack />
    </Provider>,
    document.getElementById('root')
  );
}
