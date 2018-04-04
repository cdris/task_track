import React from 'react';
import { Redirect, Link } from 'react-router-dom';
import { Form, FormGroup, FormFeedback, Input, Button, Label } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api_server';

class TaskForm extends React.Component {

  constructor(props) {
    super(props);
    this.state = {redirect: false, errors: {}};
    api.requestUsers();
  }

  update(data) {
    this.props.dispatch({
      type: 'UPDATE_TASK',
      data: data
    });
  }

  updateCheck(ev) {
    let target = ev.target;
    let data = {};
    data[$(target).attr('name')] = target.checked;
    this.update(data);
  }

  updateText(ev) {
    let target = $(ev.target);
    let data = {};
    data[target.attr('name')] = target.val();
    this.update(data);
  }

  submitTask() {
    api.submitTask(
      this.props.type,
      this.props.task,
      (() => {this.setState({redirect: true});}).bind(this),
      ((fields) => {this.setState({errors: fields});}).bind(this)
    );
  }

  feedback(field) {
    console.log("ERRORS");
    if (this.state.errors[field]) {
      return <FormFeedback>{this.state.errors[field][0]}</FormFeedback>
    }
    return '';
  }

  render() {

    if (this.state.redirect) {
      return <Redirect to="/tasks" />;
    }

    let users = _.map(this.props.users, (user, i) => {
      return (
        <option key={i} value={user.email}>
          {user.name} - {user.email}
        </option>
      );
    });

    let updateText = this.updateText.bind(this);
    let updateCheck = this.updateCheck.bind(this);

    return (
      <div>
        <Form>
          <FormGroup>
            <Label for="title">Title</Label>
            <Input type="text" name="title" value={this.props.task.title}
                   onChange={updateText} />
            {this.feedback("title")}
          </FormGroup>
          <FormGroup>
            <Label for="description">Description</Label>
            <Input type="textarea" name="description" value={this.props.task.description}
                   onChange={updateText} />
            {this.feedback("description")}
          </FormGroup>
          <FormGroup>
            <Label for="assignee_email">Assignee Email</Label>
            <Input type="text" name="assignee_email" value={this.props.task.assignee_email}
                   onChange={updateText} list="users"/>
            <datalist id="users">
              {users}
            </datalist>
            {this.feedback("assignee_email")}
          </FormGroup>
          <FormGroup>
            <Label for="time_worked">Time Worked</Label>
            <Input type="number" name="time_worked" value={this.props.task.time_worked}
                   onChange={updateText} min="0" step="15"/>
            {this.feedback("time_worked")}
          </FormGroup>
          <FormGroup check>
            <Input type="checkbox" name="completed" onChange={updateCheck}
                   checked={this.props.task.completed} />
            <Label for="completed">Completed</Label>
            {this.feedback("completed")}
          </FormGroup>
          <FormGroup>
            <Button onClick={this.submitTask.bind(this)} color="primary">Submit</Button>
          </FormGroup>
        </Form>
        <Link to="/tasks" className="btn btn-link">Cancel</Link>
      </div>
    );
  }
}

export default connect((state) => state)(TaskForm);
