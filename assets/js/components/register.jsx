import React from 'react';
import { Redirect, Link } from 'react-router-dom';
import { Form, FormGroup, FormFeedback, Input, Button, Label } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api_server';

class Register extends React.Component {

  constructor(props) {
    super(props);
    this.state = {redirect: false, errors: {}};
  }

  update(ev) {
    let target = $(ev.target);
    let data = {};
    data[target.attr('name')] = target.val();
    this.props.dispatch({
      type: 'UPDATE_REGISTER',
      data: data
    });
  }

  submitRegister(ev) {
    this.setState({errors: {}});
    api.submitRegister(
      this.props.register,
      (() => {this.setState({redirect: true});}).bind(this),
      ((fields) => {this.setState({errors: fields});}).bind(this)
    );
  }

  feedback(field) {
    if (this.state.errors[field]) {
      return <FormFeedback>{this.state.errors[field][0]}</FormFeedback>;
    }
    return '';
  }

  render() {

    if (this.state.redirect) {
      return <Redirect to="/" />
    }
    let register = this.props.register;
    let update = this.update.bind(this);

    return (
      <div>
        <h2>Register</h2>
        <Form>
          <FormGroup>
            <Label for="name">Name:</Label>
            <Input type="text" name="name" placeholder="username"
                   value={register.name} onChange={update} />
            {this.feedback("name")}
          </FormGroup>
          <FormGroup>
            <Label for="email">Email:</Label>
            <Input type="email" name="email" placeholder="user@example.com"
                   value={register.email} onChange={update} />
            {this.feedback("email")}
          </FormGroup>
          <FormGroup>
            <Label for="password">Password:</Label>
            <Input type="password" name="password" placeholder="password"
                   value={register.password} onChange={update} />
            {this.feedback("password")}
          </FormGroup>
          <FormGroup>
            <Label for="password_confirmation">Confirm Password:</Label>
            <Input type="password" name="password_confirmation" placeholder="confirm password"
                   value={register.password_confirmation} onChange={update} />
            {this.feedback("password_confirmation")}
          </FormGroup>
          <FormGroup>
            <Button onClick={this.submitRegister.bind(this)} color="primary">
              Submit
            </Button>
          </FormGroup>
        </Form>
        <Link to="/" className="btn btn-link">Cancel</Link>
      </div>
    );
  }
}

export default connect((state) => state)(Register);
