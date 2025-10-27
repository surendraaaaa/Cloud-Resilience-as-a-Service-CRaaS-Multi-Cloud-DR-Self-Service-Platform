import React, { useState } from 'react';
import DeployForm from './components/DeployForm';
import WorkspaceList from './components/WorkspaceList';
import './styles/App.css';

function App() {
  const [workspaces, setWorkspaces] = useState([]);

  return (
    <div className="container mt-5">
      <h1 className="mb-4">Multi-Cloud Deployment Platform</h1>
      <DeployForm setWorkspaces={setWorkspaces} />
      <hr />
      <WorkspaceList workspaces={workspaces} setWorkspaces={setWorkspaces} />
    </div>
  );
}

export default App;
