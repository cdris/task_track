import React from 'react';
import { NavLink } from 'react-router-dom';
import { NavItem, Navbar } from 'reactstrap';
import { connect } from 'react-redux';
import api from '../api_server';

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

let LogOut = connect(({user}) => {return {user};})((props) => {
  return (
    <nav className="ml-auto navbar-nav">
      <NavItem>
        <span className="navbar-text text-warning">
          Hi, {props.user.username}!
        </span>
      </NavItem>
      <NavItem>
        <NavLink to="/" exact={true} className="nav-link">
          Log Out
        </NavLink>
      </NavItem>
    </nav>
  );
});

function Nav(props) {
  let navRight = props.user ? <LogOut /> : <SignUp />
  return (
    <Navbar color="dark" dark expand="sm">
      <NavLink className="navbar-brand" to="/" exact={true}>
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
