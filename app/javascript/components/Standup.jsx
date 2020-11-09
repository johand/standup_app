import React, { useState } from 'react';
import PropTypes from 'prop-types';

function Standup(props) {
  const { standup } = props;

  return (
    <div className="col-4">
      <div className="card">
        <div className="card-header">
          <div className="float-right">
            <a href={'s/edit/' + standup.standup_date}>
              <button className="btn btn-default btn-sm">
                <span style={{ color: '#b30000' }}>
                  <i className="fas fas-pencil-atl"></i>
                </span>
              </button>
            </a>
          </div>
          <h3 className="card-title">{standup.standup_date}</h3>
        </div>

        <div className="card-body">
          <h4>
            Dids
            <ul className="todo-list">
              {standup.dids.map(did => {
                return <li key={did.id}>{did.title}</li>;
              })}
            </ul>
          </h4>

          <h4>
            Todos
            <ul className="todo-list">
              {standup.todos.map(todo => {
                return <li key={todo.id}>{todo.title}</li>;
              })}
            </ul>
          </h4>

          <h4>
            Blockers
            <ul className="todo-list">
              {standup.blockers.map(blocker => {
                return <li key={blocker.id}>{blocker.title}</li>;
              })}
            </ul>
          </h4>
        </div>
      </div>
    </div>
  );
}

Standup.propTypes = {
  standup: PropTypes.object,
};

export default Standup;
