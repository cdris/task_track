import React from 'react';
import { Link, Redirect } from 'react-router-dom';
import { Form, FormGroup, Input, Button, Label, Table } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api_server';

class TaskList extends React.Component {

  componentWillMount() {
    this.filter();
  }

  update(ev) {
    let target = ev.target;
    let data = {};
    data[$(target).attr('name')] = target.checked;
    this.props.dispatch({
      type: 'UPDATE_FILTER',
      data: data
    });
  }

  filter() {
    api.requestTasks(this.props.filter);
  }

  render() {

    let update = this.update.bind(this);
    let filter = this.filter.bind(this);
    let rows = _.map(this.props.tasks, (task) => {
      return <TaskRow key={task.id} task={task} reload={filter}/>;
    });

    return (
      <div>
        <div className="row">
          <div className="col">
            <h1>Your Tasks</h1>
          </div>
        </div>
        <div className="row">
          <div className="col pt-3">
            <Form inline>
              <FormGroup check inline>
                <Input onChange={update} name="completed" type="checkbox"
                       checked={this.props.filter.completed} />
                <Label for="completed">Show completed</Label>
              </FormGroup>
              <FormGroup check inline>
                <Input onChange={update} name="reported" type="checkbox"
                       checked={this.props.filter.reported} />
                <Label for="reported">Show reported by you</Label>
              </FormGroup>
              <Button onClick={filter}
                      color="primary"
                      className="btn-sm">
                Filter
              </Button>
            </Form>
          </div>
          <div className="col text-right py-2">
            <Link to="/tasks/new" className="btn btn-primary">New Task</Link>
          </div>
        </div>
        <Table>
          <thead>
            <tr>
              <th>Title</th>
              <th>Description</th>
              <th>Reporter</th>
              <th>Assignee</th>
              <th>Time Worked</th>
              <th>Completed</th>
              <th></th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {rows}
          </tbody>
        </Table>
      </div>
    );
  }
}

class TaskRow extends React.Component {
  constructor(props) {
    super(props);
    this.state = {redirect: false};
  }

  editTask() {
    this.setState({redirect: true});
  }

  deleteTask() {
    api.deleteTask(
      this.props.task.id,
      (() => this.props.reload()).bind(this)
    );
  }

  render() {
    let task = this.props.task;

    if (this.state.redirect) {
      return <Redirect to={`/tasks/edit/${task.id}`} />;
    }

    return (
      <tr>
        <td>{task.title}</td>
        <td>{task.description}</td>
        <td>{task.reporter}</td>
        <td>{task.assignee}</td>
        <td>{task.time_worked}</td>
        <td>
          <FormGroup check>
            <Input type="checkbox" disabled checked={task.completed} />
          </FormGroup>
        </td>
        <td>
          <Button onClick={this.editTask.bind(this)} color="primary">
            Edit
          </Button>
        </td>
        <td>
          <Button onClick={this.deleteTask.bind(this)} color="danger">
            Delete
          </Button>
        </td>
      </tr>
    );
  }
}

export default connect((state) => state)(TaskList);
