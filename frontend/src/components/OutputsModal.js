import React from 'react';
import { Modal, Button } from 'react-bootstrap';

function OutputsModal({ workspace, outputs, onClose }) {
  return (
    <Modal show={true} onHide={onClose}>
      <Modal.Header closeButton>
        <Modal.Title>Outputs for {workspace}</Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <pre>{JSON.stringify(outputs, null, 2)}</pre>
      </Modal.Body>
      <Modal.Footer>
        <Button variant="secondary" onClick={onClose}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default OutputsModal;
