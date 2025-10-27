import DeployForm from '../components/DeployForm';
import WorkspaceHistory from '../components/WorkspaceHistory';
import LiveStatus from '../components/LiveStatus';

export default function Dashboard() {
  return (
    <div className="container mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6">🌩 Multi-Cloud DR Platform</h1>
      <DeployForm onDeployed={() => window.location.reload()} />
      <LiveStatus />
      <WorkspaceHistory />
    </div>
  );
}
