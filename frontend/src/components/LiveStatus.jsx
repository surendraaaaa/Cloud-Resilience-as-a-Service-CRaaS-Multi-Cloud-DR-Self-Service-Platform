import { useEffect, useState } from 'react';
import io from 'socket.io-client';

export default function LiveStatus() {
  const [logs, setLogs] = useState([]);
  useEffect(() => {
    const socket = io('http://localhost:5000');
    socket.on('terraform-log', (msg) => {
      setLogs((prev) => [...prev, msg]);
    });
    return () => socket.disconnect();
  }, []);

  return (
    <div className="bg-black text-green-400 p-4 rounded mt-6 font-mono h-64 overflow-y-scroll">
      {logs.map((log, i) => (
        <div key={i}>{log}</div>
      ))}
    </div>
  );
}
