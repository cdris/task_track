import React from 'react';
import { connect } from 'react-redux';
import api from '../api_server';
import TaskForm from './task_form';

class EditTask extends React.Component {

  constructor(props) {
    super(props);
    api.requestTask(this.props.task_id);
  }

  render() {

    return (
      <div>
        <h2>Edit Task</h2>
        <TaskForm type={this.props.task_id}/>
      </div>
    );
  }
}

export default connect((state) => state)(EditTask);
