import React from 'react';
import { Redirect, Link } from 'react-router-dom';
import { Jumbotron, Form, FormGroup, Input, Button, Label, Col } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api_server';

class Login extends React.Component {

  constructor(props) {
    super(props);
    this.state = { redirect: false };
  }

  update(ev) {
    let target = $(ev.target);
    let data = {};
    data[target.attr('name')] = target.val();
    this.props.dispatch({
      type: 'UPDATE_LOGIN',
      data: data
    });
  }

  submitLogin(ev) {
    api.submitLogin(
      this.props.login,
      (() => {this.setState({redirect: true});}).bind(this)
    );
  }

  render() {

    if (this.state.redirect) {
      return <Redirect to="/tasks" />;
    }

    return (
      <div>
        <Jumbotron>
          <h1>Welcome to Task Tracker!</h1>
          <p className="lead">Track your tasks here in an <strong>extremely simple task tracker</strong>. This problem has already been solved countless times in far better ways. You should probably use one of those solutions instead.</p>
        </Jumbotron>
        <div className="row">
          <div className="col-lg-6">
            <h3>Log In</h3>
            <Form>
              <FormGroup row>
                <Label for="email" sm={2}>Email:</Label>
                <Col sm={10}>
                  <Input type="email" name="email" placeholder="user@example.com"
                         value={this.props.login.email}
                         onChange={this.update.bind(this)} />
                </Col>
              </FormGroup>
              <FormGroup row>
                <Label for="password" sm={2}>Password:</Label>
                <Col sm={10}>
                  <Input type="password" name="password" placeholder="password"
                         value={this.props.login.password}
                         onChange={this.update.bind(this)} />
                </Col>
              </FormGroup>
              <FormGroup row>
                <Col sm={2}>
                  <Button onClick={this.submitLogin.bind(this)}
                          color="primary">Log In</Button>
                </Col>
                <Col sm={2}>
                  <Link to="/register" className="btn btn-link">Register</Link>
                </Col>
              </FormGroup>
            </Form>
          </div>
        </div>
      </div>
    );
  }
}

export default connect(({login}) => {return {login};})(Login);
