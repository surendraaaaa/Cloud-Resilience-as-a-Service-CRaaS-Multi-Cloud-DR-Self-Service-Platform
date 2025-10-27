import React, { useState } from 'react';
import { destroyEnvironment, getOutputs } from '../api/terraformApi';
import OutputsModal from './OutputsModal';

function WorkspaceList({ workspaces, setWorkspaces }) {
  const [selectedWorkspace, setSelectedWorkspace] = useState(null);

  const handleDestroy = async (workspace) => {
    if (!window.confirm(`Destroy workspace ${workspace}?`)) return;
    try {
      await destroyEnvironment(workspace);
      setWorkspaces(prev => prev.filter(w => w.workspace !== workspace));
      alert(`Workspace ${workspace} destroyed successfully!`);
    } catch (err) {
      console.error(err);
      alert('Destroy failed: ' + err.message);
    }
  };

  const handleViewOutputs = async (workspace) => {
    const data = await getOutputs(workspace);
    setSelectedWorkspace({ workspace, outputs: data.outputs });
  };

  return (
    <div>
      <h3>Active Workspaces</h3>
      {workspaces.length === 0 && <p>No deployments yet.</p>}
      {workspaces.map(w => (
        <div className="card mb-3" key={w.workspace}>
          <div className="card-body d-flex justify-content-between align-items-center">
            <div>
              <strong>{w.workspace}</strong>
            </div>
            <div>
              <button className="btn btn-info btn-sm me-2" onClick={() => handleViewOutputs(w.workspace)}>View Outputs</button>
              <button className="btn btn-danger btn-sm" onClick={() => handleDestroy(w.workspace)}>Destroy</button>
            </div>
          </div>
        </div>
      ))}
      {selectedWorkspace && 
        <OutputsModal workspace={selectedWorkspace.workspace} outputs={selectedWorkspace.outputs} onClose={() => setSelectedWorkspace(null)} />}
    </div>
  );
}

export default WorkspaceList;
