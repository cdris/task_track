import React from 'react';
import { connect } from 'react-redux';
import api from '../api_server';
import TaskForm from './task_form';

class NewTask extends React.Component {

  constructor(props) {
    super(props);
    this.props.dispatch({
      type: 'RESET_FORMS'
    });
  }

  render() {
    return (
      <div>
        <h2>New Task</h2>
        <TaskForm type="new" />
      </div>
    );
  }
}

export default connect((state) => state)(NewTask);
