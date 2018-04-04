import React from 'react';
import ReactDOM from 'react-dom';
import { Provider, connect } from 'react-redux';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { withRouter } from 'react-router';
import { Alert } from 'reactstrap';
import store from '../store';
import Nav from './nav';
import Login from './login';
import TaskList from './task_list';
import NewTask from './new_task';
import EditTask from './edit_task';

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
      console.log('location change');
      store.dispatch({type: 'RESET_ERROR'});
      store.dispatch({type: 'RESET_SUCCESS'});
    }
  }

  render() {
    return (
      <div>
        <Nav />
        <div className="mt-3 container">
          <MessageAlerts />
          <Route path="/" exact={true} render={() => <Login />} />
          <Route path="/tasks" exact={true} render={() => <TaskList />} />
          <Route path="/tasks/new" exact={true} render={() => <NewTask />} />
          <Route path="/tasks/:task_id/edit" exact={true}
                 render={({match}) => <EditTask task_id={match.params.task_id} />} />
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
