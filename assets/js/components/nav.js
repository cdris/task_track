import React from 'react';
import { Redirect, NavLink } from 'react-router-dom';
import { NavItem, Navbar } from 'reactstrap';
import { connect } from 'react-redux';

function SignUp(props) {
  return (
    <nav className="ml-auto navbar-nav">
      <NavItem>
        <NavLink to="/register" exact={true} className="nav-link">
          Sign Up
        </NavLink>
      </NavItem>
    </nav>
  );
}

class LogOut extends React.Component {

  constructor(props) {
    super(props);
    this.state = {redirect: false};
  }

  logOut() {
    this.props.dispatch({type: 'DELETE_USER'});
    this.setState({redirect: true});
  }

  render() {
    if (this.state.redirect) {
      return <Redirect to="/" />;
    }
    return (
      <nav className="ml-auto navbar-nav">
        <NavItem>
          <span className="navbar-text text-warning">
            Hi, {this.props.user.username}!
          </span>
        </NavItem>
        <NavItem>
          <span onClick={this.logOut.bind(this)}
                  color="link" className="nav-link">
            Log Out
          </span>
        </NavItem>
      </nav>
    );
  }
}

let ConnectedLogOut = connect(({user}) => {return {user};})(LogOut);

function Nav(props) {
  let navRight = props.user ? <ConnectedLogOut /> : <SignUp />
  return (
    <Navbar color="dark" dark expand="sm">
      <NavLink className="navbar-brand" to="/tasks" exact={true}>
        Task Tracker
      </NavLink>
      { navRight }
    </Navbar>
  );
}

function stateToProps(state) {
  return {
    user: state.user
  };
}

export default connect(stateToProps)(Nav);
